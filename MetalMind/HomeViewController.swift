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

class HomeViewController: UIViewController, HomeViewControllerDelegate {
    
    // MARK: - Segue identifiers
    let loginVCSegue = "ShowLoginTableViewController"
    let statsTVCSegue = "ShowStatsTableViewController"
    let createRobotVCSegue = "ShowCreateRobotViewController"
    
    // MARK: - IBOutlets
    @IBOutlet weak var loadingDataActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var createRobotLabel: UILabel!
    
    // MARK: - Variables
    var userData: NSDictionary? {
        get {
            let (data, error) = Locksmith.loadDataForUserAccount("MetalMindUserAccount")
            if error != nil { return nil }
            
            return data
        }
    }
    var token: String?  { return userData?.objectForKey("token") as? String }

    var robots: [Robot] = [] {
        didSet {
            if currentRobotIndex >= robots.count && robots.count > 0 {
                currentRobotIndex = robots.count - 1
            }
            self.title = currentRobot?.name ?? ""
            tapGestureRecognizer.enabled = !robots.isEmpty
            playerOverviewScene?.hidden = robots.isEmpty
            createRobotLabel.hidden = !robots.isEmpty
            
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                delegate.currentRobot = currentRobot
            }
        }
    }
    var currentRobotIndex: Int = 0 {
        didSet {
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                delegate.currentRobot = currentRobot
            }
        }
    }
    var currentRobot: Robot? { return robots.isEmpty ? nil : robots[currentRobotIndex] }
    var downloadingRobotData = false
    var playerOverviewScene: OverviewScene?

    // MARK:- UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRobotsData(nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if playerOverviewScene == nil {
            /* configure scene view */
            let skView = self.view as! SKView

        /* create and configure the scene */
            playerOverviewScene = OverviewScene(size: view.bounds.size)
//            playerOverviewScene?.scaleMode = .AspectFit
            playerOverviewScene?.hidden = true
            
            /* present the scene */
            skView.presentScene(playerOverviewScene)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
                
        /* ask for user to login if there is no token */
        if token == nil {
            createRobotLabel.hidden = true
            self.performSegueWithIdentifier(loginVCSegue, sender: self)
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
    func loadRobotsData(completion: (() -> Void)? ) {
        if downloadingRobotData { return }
        downloadingRobotData = true
        
        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/robots")
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        if token != nil {
            mutableURLRequest.setValue(token!, forHTTPHeaderField: "Authorization")
        }
        
        var manager = Alamofire.Manager.sharedInstance
        var request = manager.request(mutableURLRequest)

        request.RobotDataLoadResponseJSON { (request, response, arrayJSON, error) -> Void in
            
            if arrayJSON != nil && error == nil {
                self.robots = map(arrayJSON!) { Robot(json: $0) }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion?()
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
        self.animateCharacterChange(self.view, duration: 0.5)
    }
    
    func switchToNextRobot() {
        if robots.isEmpty { return }
        
        if currentRobotIndex + 1 > robots.count - 1 {
            currentRobotIndex = 0
        } else {
            currentRobotIndex += 1
        }
        self.title = robots[currentRobotIndex].name
        self.animateCharacterChange(self.view, duration: 0.5)
    }
    
    func animateCharacterChange(view: UIView, duration: NSTimeInterval = 2.0) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        UIView.animateWithDuration(
            duration,
            delay: 0.0,
            options: .Autoreverse,
            animations: {
                self.playerOverviewScene?.view?.alpha = 0.0
            },
            completion: { finished in
                self.playerOverviewScene?.view?.alpha = 1.0
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
    }
    
    func deleteCurrentRobot() {
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
                    
                    self.animateCharacterChange(self.view, duration: 0.5)
                    self.robots.removeAtIndex(self.currentRobotIndex)

                    let alert = UIAlertView(title: "DELETED", message: "Robot deleted successfully", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func previousButtonAction(sender: UIButton) {
        switchToPreviousRobot()
    }
    
    @IBAction func nextButtonAction(sender: UIButton) {
        switchToNextRobot()
    }
    
    @IBAction func deleteButtonAction(sender: UIBarButtonItem) {
        if robots.isEmpty { return }
        let alertMessage = "Are you sure you want to delete robot \"\(currentRobot!.name!)\""
        var alert = UIAlertController(title: "DELETE Robot", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "DELETE", style: .Destructive){ action in
            self.deleteCurrentRobot()
        })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - HomeViewControllerDelegate
    func controller(controller: UIViewController, didLoginUser: Bool) {
        if token != nil && didLoginUser == true {
            self.loadRobotsData(){
                self.view.setNeedsDisplay()
            }
        }
    }
    
    func controller(controller: UIViewController, didAddRobot: Bool) {
        if token != nil && didAddRobot == true {
            if self.robots.count - 1 >= 0 {
                self.currentRobotIndex = self.robots.count - 1
            }
            
            self.loadRobotsData(){
                self.switchToNextRobot()
            }
        }
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
        case loginVCSegue:
            let loginVC = segue.destinationViewController as? LoginTableViewController
            loginVC?.delegate = self
        case statsTVCSegue:
            let showStatsTVC = segue.destinationViewController as? StatsTableViewController
            showStatsTVC?.robot = currentRobot
        case createRobotVCSegue:
            let createRobotVC = segue.destinationViewController as? CreateRobotViewController
            createRobotVC?.delegate = self
        default: break
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

