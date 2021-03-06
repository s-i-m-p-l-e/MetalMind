//
//  AvalableSkillList.swift
//  MetalMind
//
//  Created by Victor Vasilica on 6/9/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class AvailableSkillList: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Variables
    var skillList = [Skill]()
    var downloadingSkillList = false
    var userData: NSDictionary? {
        get {
            let (data, error) = Locksmith.loadDataForUserAccount("MetalMindUserAccount")
            if error != nil { return nil }
            
            return data
        }
    }
    var token: String?  { return userData?.objectForKey("token") as? String }
    var delegate: SkillListDelegate?
    
    // MARK: - UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSkills()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skillList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "SkillListCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        
        if (cell != nil)
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
                reuseIdentifier: identifier)
        }
        let index = indexPath.row
        
        cell?.imageView?.image = UIImage(named: "skill_placeholder1")
        cell?.textLabel?.text = skillList[index].name
        cell?.detailTextLabel?.text = skillList[index].description
        
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let actionID = skillList[indexPath.row].id
        
        addSkillToActiveSkillList(actionID!)
    }
    
    // MARK: - Helpers
    func loadSkills() {
        if downloadingSkillList { return }
        downloadingSkillList = true
        
        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/builder")
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        if token != nil {
            mutableURLRequest.setValue(token!, forHTTPHeaderField: "Authorization")
        }
        
        var manager = Alamofire.Manager.sharedInstance
        var request = manager.request(mutableURLRequest)
        
        request.responseJSON { (request, response, arrayJSON, error) -> Void in
            
            if arrayJSON != nil && error == nil {
                let actions  = arrayJSON?.objectForKey("actions") as? [String: [String:NSObject]]
               self.skillList = map(actions!) { (key, value) in Skill(json: value) }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        downloadingSkillList = false
    }
    
    func addSkillToActiveSkillList(actionID: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let currentRobotID = appDelegate?.currentRobot!.id
        
        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/action/\(currentRobotID!)")
        let parameters: [String : AnyObject] = [
            "config": [
                "trigger": Trigger().toDictionary(),
                "clause": Clause().toDictionary(),
                "action": ["actionId": actionID,
                           "quantity": 1]
                ]
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
            
            dispatch_async(dispatch_get_main_queue()) {
                if let delegate = self.delegate {
                    delegate.controller(self, didAddSkill: true)
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }

}
