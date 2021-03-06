//
//  Arena.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/18/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class ArenaViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var battleButton: UIButton! {
        didSet {
            battleButton.layer.borderWidth = 2.0
            battleButton.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    // MARK: - Variables
    var userData: NSDictionary? {
        get {
            let (data, error) = Locksmith.loadDataForUserAccount("MetalMindUserAccount")
            if error != nil { return nil }
            
            return data
        }
    }
    var token: String?  { return userData?.objectForKey("token") as? String }
    
    // MARK: - IBActions
    @IBAction func practiceActionButton(sender: UIButton) {

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
        }

    }
}
