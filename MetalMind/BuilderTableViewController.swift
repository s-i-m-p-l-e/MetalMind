//
//  BuilderTableViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/21/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class BuilderTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    // Trigger
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var whenSegmenControl: UISegmentedControl!
    @IBOutlet weak var whoSegmentControl: UISegmentedControl!
    @IBOutlet weak var whatSegmentControl: UISegmentedControl!
    // Clause
    @IBOutlet weak var actorSegmentControl: UISegmentedControl!
    @IBOutlet weak var statsSegmentControl: UISegmentedControl!
    @IBOutlet weak var operatorSegmentControl: UISegmentedControl!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var metricsSegmentControl: UISegmentedControl!

    @IBOutlet weak var saveChangesButton: UIButton!
    
    // MARK: - Variables
    var delegate: SkillListTableViewController?
    var skillIndex: Int?
    var skillBuilder: Builder?
    var skillID: Int?
    var downloadingSkillData = false
    var userData: NSDictionary? {
        get {
            let (data, error) = Locksmith.loadDataForUserAccount("MetalMindUserAccount")
            if error != nil { return nil }
            
            return data
        }
    }
    var token: String?  { return userData?.objectForKey("token") as? String }
    
    // MARK: - UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSkillData()
        
        /* Make table header smaller */
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 0.1))
        
        /* Gesture recognizer to hide keypad */
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tapGestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGestureRecognizer)
        
        /* Update interface to show builder changes */
//        saveChangesButton.setTitle(self.navigationItem.title, forState: .Normal)
        whenSegmenControl.selectedSegmentIndex = Int(skillBuilder!.trigger.when.rawValue)
        whoSegmentControl.selectedSegmentIndex = Int(skillBuilder!.trigger.who.rawValue)
        whatSegmentControl.selectedSegmentIndex = Int(skillBuilder!.trigger.what.rawValue)
        
        actorSegmentControl.selectedSegmentIndex = Int(skillBuilder!.clause.actor.rawValue)
        statsSegmentControl.selectedSegmentIndex = Int(skillBuilder!.clause.stats.rawValue)
        operatorSegmentControl.selectedSegmentIndex = Int(skillBuilder!.clause.mmOperator.rawValue)
        valueTextField.text = "\(skillBuilder!.clause.value)"
        metricsSegmentControl.selectedSegmentIndex = Int(skillBuilder!.clause.metrics.rawValue)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        /* Configure section header text color */
        let header = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor.whiteColor()
    }
    
    // MARK: - Helpers
    func hideKeyboard() {
        self.view.endEditing(false)
    }
    
    func loadSkillData() {
//        if downloadingSkillData { return }
//        downloadingSkillData = true
//        
//        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
//        let currentRobotID = appDelegate?.currentRobot!.id
//        
//        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/action/\(currentRobotID!)")
//        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
//        if token != nil {
//            mutableURLRequest.setValue(token!, forHTTPHeaderField: "Authorization")
//        }
//        
//        var manager = Alamofire.Manager.sharedInstance
//        var request = manager.request(mutableURLRequest)
//        
//        request.responseJSON { (request, response, arrayJSON, error) -> Void in
//            //            println(arrayJSON)
//            
//            if arrayJSON != nil && error == nil {
//                let json = arrayJSON as? [[String: NSObject]]
//                self.skillList = map(json!) { Skill(activeSkillJSON: $0) }
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                self.tableView.reloadData()
//            }
//        }
//        downloadingSkillData = false
//        
    }
    
    func changeData() {
        
        /* get user data */
        skillBuilder?.trigger.when = When(rawValue: UInt32(whenSegmenControl.selectedSegmentIndex))!
        skillBuilder?.trigger.who = Who(rawValue: UInt32(whoSegmentControl.selectedSegmentIndex))!
        skillBuilder?.trigger.what = What(rawValue: UInt32(whatSegmentControl.selectedSegmentIndex))!
        
        skillBuilder?.clause.actor = Actor(rawValue: UInt32(actorSegmentControl.selectedSegmentIndex))!
        skillBuilder?.clause.stats = Stats(rawValue: UInt32(statsSegmentControl.selectedSegmentIndex))!
        skillBuilder?.clause.mmOperator = MMOperator(rawValue: UInt32(operatorSegmentControl.selectedSegmentIndex))!
        skillBuilder?.clause.value = valueTextField.text.floatValue
        skillBuilder?.clause.metrics = Metrics(rawValue: UInt32(metricsSegmentControl.selectedSegmentIndex))!
        
        /* prepare needed variables for request */
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let currentRobotID = appDelegate?.currentRobot!.id
        let action = skillBuilder?.toDefaultDictionary()["action"]
        let actionID = (action!["actionId"]! as NSString).floatValue
        
        /* set parameters */
        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/action/\(skillID!)")
        let parameters: [String : AnyObject] = [
            "id": skillID!,
            "robotId": currentRobotID!,
            "config": [
                "trigger": skillBuilder!.trigger.toDictionary(),
                "clause": skillBuilder!.clause.toDictionary(),
                "action": ["actionId": actionID,
                           "quantity": 1]
            ]
        ]
        
        /* parameter serialization */
        var error: NSError?
        let dataJSON = NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
        let stringJSON = NSString(data: dataJSON!,
            encoding: NSASCIIStringEncoding)
        println(stringJSON)
        
        /* custom request configuration */
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        if token != nil {
            mutableURLRequest.setValue(token!, forHTTPHeaderField: "Authorization")
        }
        mutableURLRequest.HTTPMethod = "PUT"
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.HTTPBody = dataJSON
        
        var manager = Alamofire.Manager.sharedInstance
        var request = manager.request(mutableURLRequest)
        
        request.responseJSON {(request, response, JSON, error) in
            println(JSON)
            
            dispatch_async(dispatch_get_main_queue()) {
                if let delegate = self.delegate {
                    delegate.controller(self, didAddSkill: true)
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func deleteCurrentSkill() {
        let aManager = Manager.sharedInstance
        
        if let token = self.token where skillID != nil {
            aManager.session.configuration.HTTPAdditionalHeaders = [
                "Authorization": token ]
            let url = "https://api.metalmind.rocks/v1/action/\(skillID!)"
            let parameters = [
                "id": self.skillID!
            ]
            
            Alamofire.request(.DELETE, url, parameters: parameters, encoding: .JSON).responseJSON { (request, response, jsonObject, error) in
                let json = jsonObject as? [String:Int]
                if json?["success"] == 1 {
                    
                    if let delegate = self.delegate {
                        delegate.controller(self, didAddSkill: false)
                    }
                    let alert = UIAlertView(title: "DELETED", message: "Skill deleted successfully", delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                    
                    self.navigationController?.popViewControllerAnimated(true)
                    
                }
            }
        }

    }
    
    // MARK: - IBActions
    @IBAction func saveChangesButtonAction(sender: UIButton) {
        changeData()
    }
    
    @IBAction func deleteSkillAction(sender: UIBarButtonItem) {
        deleteCurrentSkill()
    }
}

internal extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
