//
//  ViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 3/28/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import SpriteKit
import Locksmith
import MetalMindKit

class HomeViewController: UIViewController {
    
    var userData: NSDictionary? {
        get {
            let (data, error) = Locksmith.loadDataForUserAccount("MetalMindUserAccount")
            if error != nil { return nil }
            
            return data
        }
    }
    var token: String?  { return userData?.objectForKey("token") as? String }

    // MARK:- UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        let playesOverviewScene = HomeScene(size: view.bounds.size)
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        playesOverviewScene.scaleMode = .ResizeFill
        skView.presentScene(playesOverviewScene)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if userData?.objectForKey("token") == nil {
            self.performSegueWithIdentifier("ModalLoginViewController", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

