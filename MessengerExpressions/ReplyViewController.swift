//
//  ReplyViewController.swift
//  MessengerExpressions
//
//  Created by Wayne Yeh on 2017/2/20.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit

import FBSDKMessengerShareKit

class ReplyViewController: ViewController {

    override func initFB() {
        let replyItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(share))
        navigationItem.setRightBarButton(replyItem, animated: true)
        
        let width = (self.navigationController?.navigationBar.frame.size.height ?? 44) - 8
        let button = FBSDKMessengerShareButton.circularButton(with: .blue, width: width)
        button?.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backItem = UIBarButtonItem(customView: button!)
        navigationItem.setLeftBarButton(backItem, animated: true)
    }
    
    override func share() {
        _ = self.navigationController?.popViewController(animated: false)
        
        super.share()
    }
    
    func back() {
        _ = self.navigationController?.popViewController(animated: false)
        
        FBSDKMessengerSharer.openMessenger()
    }
}
