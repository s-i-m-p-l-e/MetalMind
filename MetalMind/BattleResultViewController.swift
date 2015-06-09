//
//  BattleResultViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 6/9/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class BattleResultViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet var announcerLabel: UILabel!
    @IBOutlet weak var actIndicator: UIActivityIndicatorView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Variables
    var userData: NSDictionary? {
        get {
            let (data, error) = Locksmith.loadDataForUserAccount("MetalMindUserAccount")
            if error != nil { return nil }
            
            return data
        }
    }
    var token: String?  { return userData?.objectForKey("token") as? String }
    
    // MARK: UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let currentRobotID = appDelegate?.currentRobot!.id
        
        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/fight/random")
        let parameters: [String : AnyObject] = [
            "robotId": currentRobotID!
        ]
        
        /* parameter serialization */
        var error: NSError?
        let dataJSON = NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
        let stringJSON = NSString(data: dataJSON!,
            encoding: NSASCIIStringEncoding)
        //        println(stringJSON)
        
        /* custom request configuration */
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        if token != nil {
            mutableURLRequest.setValue(token!, forHTTPHeaderField: "Authorization")
        }
        mutableURLRequest.HTTPMethod = "POST"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.HTTPBody = dataJSON
        
        var manager = Alamofire.Manager.sharedInstance
        var request = manager.request(mutableURLRequest)
        
        request.responseJSON {(request, response, JSON, error) in
            println(JSON)
            
            let winner: AnyObject? = JSON?.objectForKey("winner")
            let winnerID = winner?.objectForKey("id") as? Int
            println(winnerID)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.actIndicator.stopAnimating()
                if currentRobotID == winnerID {
                    self.announcerLabel.text = "You've Won!"
                } else {
                    self.announcerLabel.text = "You've Lost!"
                }
                self.continueButton.enabled = true
            }
        }
        
    }
    
    // MARK: IBActions
    @IBAction func continueAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
