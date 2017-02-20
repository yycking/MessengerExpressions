//
//  ViewController.swift
//  MessengerExpressions
//
//  Created by Wayne Yeh on 2017/2/15.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit
import MapKit

import FBSDKMessengerShareKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var region: MKCoordinateRegion?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initFB()
        
        if let region = region {
            mapView.region = region
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - FaceBook
    func initFB() {
        let width = (self.navigationController?.navigationBar.frame.size.height ?? 44) - 8
        let button = FBSDKMessengerShareButton.circularButton(with: .blue, width: width)
        button?.addTarget(self, action: #selector(share), for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: button!)
        navigationItem.setRightBarButton(buttonItem, animated: true)
    }
    
    func share() {
        let options = MKMapSnapshotOptions()
        options.region = self.mapView.region
        options.scale = UIScreen.main.scale
        options.size = self.mapView.frame.size
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let shareOptions = FBSDKMessengerShareOptions()
            shareOptions.metadata = options.region.toString()
            shareOptions.contextOverride = appDelegate?.contextFBMessenger
            FBSDKMessengerSharer.share(snapshot.image, with: shareOptions)
        }
    }
}

