//
//  SkillListTableViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/21/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class SkillListTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, SkillListDelegate {
    
    // MARK: - Segue Identifiers
    let builderTVCSegue = "ShowBuilderTableViewController"
    let availableSkillListTVCSegue = "ShowAvailableSkillList"
    
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
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
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
        performSegueWithIdentifier(builderTVCSegue, sender: indexPath.row)
    }
    
    // MARK: - SkillListDelegate
    func controller(controller: UITableViewController, didChangeSkillData: Bool, index: Int, builder: Builder) {
        println("Index: \(index) \n Builder: \(builder)")
        println(builder.trigger.what.rawValue)
        skillList[index].builder = builder
    }
    
    func controller(controller: UITableViewController, didAddSkill: Bool) {
        loadSkills()
        self.tableView.reloadData()
    }
    
    // MARK: - Helpers
    func loadSkills() {
        if downloadingSkillList { return }
        downloadingSkillList = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let currentRobotID = appDelegate?.currentRobot!.id
        
        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/actions/\(currentRobotID!)")
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        if token != nil {
            mutableURLRequest.setValue(token!, forHTTPHeaderField: "Authorization")
        }
        
        var manager = Alamofire.Manager.sharedInstance
        var request = manager.request(mutableURLRequest)
        
        request.responseJSON { (request, response, arrayJSON, error) -> Void in
//            println(arrayJSON)

            if arrayJSON != nil && error == nil {
                let json = arrayJSON as? [[String: NSObject]]
                self.skillList = map(json!) { Skill(activeSkillJSON: $0) }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        downloadingSkillList = false
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let index = sender as? Int
        
        switch segue.identifier! {
        case builderTVCSegue:
            let builderTVC = segue.destinationViewController as? BuilderTableViewController
            builderTVC?.delegate = self
            builderTVC?.skillIndex = index
            builderTVC?.skillID = skillList[index!].id
            builderTVC?.skillBuilder = skillList[index!].builder
            builderTVC?.navigationItem.title = skillList[index!].name
        case availableSkillListTVCSegue:
            let availableSkillListTVC = segue.destinationViewController as? AvailableSkillList
            availableSkillListTVC?.delegate = self
        default: break
        }
    }
    
    
}
