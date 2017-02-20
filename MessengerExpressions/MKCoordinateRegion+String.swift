//
//  MKCoordinateRegion+String.swift
//  MessengerExpressions
//
//  Created by Wayne Yeh on 2017/2/20.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import MapKit

extension MKCoordinateRegion {
    func toString() -> String {
        return "{\"center\":{\"latitude\":\(center.latitude), \"longitude\":\(center.longitude)}, \"span\":{\"latitudeDelta\":\(span.latitudeDelta),\"longitudeDelta\":\(span.longitudeDelta)}}"
    }
}

extension String {
    func toCoordinateRegion() -> MKCoordinateRegion? {
        guard
            let data = self.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:[String:Double]],
            let latitude = json?["center"]?["latitude"],
            let longitude = json?["center"]?["longitude"],
            let latitudeDelta = json?["span"]?["latitudeDelta"],
            let longitudeDelta = json?["span"]?["longitudeDelta"]
            else { return nil }
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        return MKCoordinateRegion(center: center, span: span)
    }
}
