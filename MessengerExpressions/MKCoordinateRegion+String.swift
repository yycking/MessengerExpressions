//
//  MKCoordinateRegion+String.swift
//  MessengerExpressions
//
//  Created by Wayne Yeh on 2017/2/20.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import MapKit

protocol JSONSerializable {
    var json: [String: Any]  { get }
    var jsonString: String? { get }
    init?(data: Data)
    init?(string: String)
    init?(json: [String: Any]?)
}

extension JSONSerializable {
    var json: [String: Any] {
        var representation = [String: Any]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value where JSONSerialization.isValidJSONObject(value):
                representation[label] = value
                
            case let value as JSONSerializable:
                representation[label] = value.json
                
            case let value as CustomStringConvertible:
                representation[label] = value
                
            default:
                // Ignore any unserializable properties
                print("\(label) of \(type(of: self)) dose not support JSONSerializable")
                break
            }
        }
        
        return representation
    }
    
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self.json, options: .prettyPrinted) else { return nil }
            
        if let json = String(data: jsonData, encoding: .utf8) {
            return json
        }
        
        return nil
    }
    
    init?(data: Data) {
        guard
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
            let dictionary = json as? [String: Any]
            else { return nil }

        self.init(json: dictionary)
    }
    
    init?(string: String) {
        guard let data = string.data(using: .utf8) else { return nil }
        self.init(data: data)
    }
}

extension CLLocationCoordinate2D: JSONSerializable {
    public init?(json: [String: Any]?) {
        let latitude = json?["latitude"] as? CLLocationDegrees ?? 0
        let longitude = json?["longitude"] as? CLLocationDegrees ?? 0
        
        self.init(latitude: latitude, longitude: longitude)
    }
}

extension MKCoordinateSpan: JSONSerializable {
    public init?(json: [String: Any]?) {
        let latitudeDelta = json?["latitudeDelta"] as? CLLocationDegrees ?? 0
        let longitudeDelta = json?["longitudeDelta"] as? CLLocationDegrees ?? 0
        
        self.init(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
}

extension MKCoordinateRegion: CustomStringConvertible, JSONSerializable {
    public init?(json: [String: Any]?) {
        let center = CLLocationCoordinate2D(json: json?["center"] as? [String : Any])!
        let span = MKCoordinateSpan(json: json?["span"] as? [String : Any])!
        
        self.init(center: center, span: span)
    }
    
    public var description: String {
        return self.jsonString!
    }
}
