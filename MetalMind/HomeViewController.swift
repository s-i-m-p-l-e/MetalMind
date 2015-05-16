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
import Alamofire

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var loadingDataActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    var userData: NSDictionary? {
        get {
            let (data, error) = Locksmith.loadDataForUserAccount("MetalMindUserAccount")
            if error != nil { return nil }
            
            return data
        }
    }
    var token: String?  { return userData?.objectForKey("token") as? String }

    var robots: [Robot] = []
    var downloadingRobotData = false

    // MARK:- UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRobotsData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
                
        /* configure scene view */
        let skView = self.view as! SKView

        /* create and configure the scene */
        let playerOverviewScene = OverviewScene(size: view.bounds.size)
        playerOverviewScene.scaleMode = .AspectFill
        
        /* present the scene */
        skView.presentScene(playerOverviewScene)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* ask for user to login if there is no token */
        if token == nil {
            self.performSegueWithIdentifier("ModalLoginViewController", sender: self)
        } else {
            /* hide loading data actividy indicator */
            loadingDataActivityIndicator.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configuring the View Rotation Settings
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    func loadRobotsData() {
        if downloadingRobotData { return }
        downloadingRobotData = true
        
        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/robots")
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.setValue(token!, forHTTPHeaderField: "Authorization")
        
        var manager = Alamofire.Manager.sharedInstance
        var request = manager.request(mutableURLRequest)

        request.responseJSON { (request, response, arrayJSON, error) -> Void in
            println(arrayJSON)
            println(error)
            
            if arrayJSON != nil && error == nil  {
                
                for json in arrayJSON! {
                    localRobots.append(Robot(json: json))
                }
            }
            
        }
        
    }
    
}

