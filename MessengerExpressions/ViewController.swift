//
//  ViewController.swift
//  MessengerExpressions
//
//  Created by Wayne Yeh on 2017/2/15.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit
import FBSDKMessengerShareKit

class ViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    let bgColor = UIColor.cyan

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = bgColor
        initFB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - drawing
    // Modified from https://www.raywenderlich.com/87899/make-simple-drawing-app-uikit-swift
    var lastPoint = CGPoint.zero
    var swiped = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        textLabel.text = nil
        
        if let touch = touches.first {
            lastPoint = touch.location(in: self.tempImageView)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(tempImageView.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            // 1
            tempImageView.image?.draw(in: tempImageView.bounds)
            
            // 2
            context.move(to: fromPoint)
            context.addLine(to: toPoint)
            
            // 3
            context.setLineCap(.round)
            context.setLineWidth(10)
            context.setStrokeColor(UIColor.blue.cgColor)
            context.setBlendMode(.normal)
            
            // 4
            context.strokePath()
        }
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.tempImageView)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(bgColor.cgColor)
            context.fill(tempImageView.bounds)
        }
        mainImageView.image?.draw(in: tempImageView.bounds, blendMode: .normal, alpha: 1.0)
        tempImageView.image?.draw(in: tempImageView.bounds, blendMode: .normal, alpha: 1.0)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    // MARK: - FaceBook
    func initFB() {
        let icon = UIImage(named:"messenger")?.withRenderingMode(.alwaysOriginal)
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(share))

        navigationItem.setRightBarButton(button, animated: true)
    }
    
    func share() {
        guard let image = mainImageView.image else { return }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let shareOptions = FBSDKMessengerShareOptions()
        shareOptions.contextOverride = appDelegate?.contextFBMessenger
        FBSDKMessengerSharer.share(image, with: shareOptions)
    }
}

