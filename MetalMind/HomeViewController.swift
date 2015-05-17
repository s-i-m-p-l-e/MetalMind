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
    var currentRobotIndex: Int = 0
    var currentRobot: Robot? { return robots[currentRobotIndex] }
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
    
    // MARK: - Helpers
    func loadRobotsData() {
        println("LoadRobotData")
        if downloadingRobotData { return }
        downloadingRobotData = true
        
        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/robots")
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        mutableURLRequest.setValue(token!, forHTTPHeaderField: "Authorization")
        
        var manager = Alamofire.Manager.sharedInstance
        var request = manager.request(mutableURLRequest)

        request.RobotDataLoadResponseJSON { (request, response, arrayJSON, error) -> Void in
//            println(arrayJSON)
//            println(error)
            
            if arrayJSON != nil && error == nil  {
                
                for json in arrayJSON! {
                    self.robots.append(Robot(json: json))
                }
                self.title = self.robots.first?.name
            }
        }
        downloadingRobotData = false
    }
    
    func switchToPreviousRobot() {
        if robots.isEmpty { return }
        
        if (currentRobotIndex - 1) < 0 {
            currentRobotIndex = robots.count - 1
        } else {
           currentRobotIndex -= 1
        }
        self.title = robots[currentRobotIndex].name
    }
    
    func switchToNextRobot() {
        if robots.isEmpty { return }
        
        if currentRobotIndex + 1 > robots.count - 1 {
            currentRobotIndex = 0
        } else {
            currentRobotIndex += 1
        }
        self.title = robots[currentRobotIndex].name
    }
    
    // MARK: - IBActions
    @IBAction func previousButtonAction(sender: UIButton) {
        switchToPreviousRobot()
    }
    @IBAction func nextButtonAction(sender: UIButton) {
        switchToNextRobot()
    }
    
    @IBAction func deleteCurrentRobot(sender: UIBarButtonItem) {
        let aManager = Manager.sharedInstance
        
        if let id = currentRobot?.id where token != nil {
            aManager.session.configuration.HTTPAdditionalHeaders = [
                "Authorization": token! ]
           let url = "https://api.metalmind.rocks/v1/robot/\(id)"
            let parameters = [
                "id": id
                ]
        
        Alamofire.request(.DELETE, url, parameters: parameters, encoding: .JSON).responseJSON { (request, response, jsonObject, error) in
            let json = jsonObject as? [String:Int]
            if json?["success"] == 1 {
                let alert = UIAlertView(title: "DELETED", message: "Robot deleted successfully", delegate: nil, cancelButtonTitle: "OK")
            }
            self.switchToNextRobot()
            }
        }
    }
}

// MARK: - Alamofire Extensions
typealias RobotDataLoadCompletitionHandler =  (NSURLRequest, NSHTTPURLResponse?, [[String: NSObject]]?, NSError?) -> Void

internal extension Request {
    class func RobotDataLoadResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil { return (nil, nil) }
            
            let opt = NSJSONReadingOptions.AllowFragments
            var error = NSErrorPointer()
            let JSONArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: opt, error: nil)
            
            let json = JSONArray as? [[String: NSObject]]
            
            return (json, nil)
        }
    }
    
    func RobotDataLoadResponseJSON(completionHandler: RobotDataLoadCompletitionHandler) -> Self {
        return response(serializer: Request.RobotDataLoadResponseSerializer(),
            completionHandler: { (request, response, arrayJSON, error) in
                completionHandler(request, response, arrayJSON as? [Dictionary<String, NSObject>], error)
            }
        )
    }
}

