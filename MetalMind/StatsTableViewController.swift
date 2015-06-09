//
//  OverviewViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/6/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class StatsTableViewController: UITableViewController {
    
    // MARK: - @IBOutlets
    /* Score */
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    /* Stats */
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var energyLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var attackSpeedLabel: UILabel!
    
    // MARK: - Variables
    var robot: Robot?
    var userData: NSDictionary? {
        get {
            let (data, error) = Locksmith.loadDataForUserAccount("MetalMindUserAccount")
            if error != nil { return nil }
            
            return data
        }
    }
    var token: String?  { return userData?.objectForKey("token") as? String }
    var downloadingRobotData: Bool = false
    
    // MARK: - UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRobotData()
        
        if let robot = self.robot {
            self.winLabel.text = "\(robot.win!)"
            self.loseLabel.text = "\(robot.lost!)"
            self.xpLabel.text = "\(robot.points!)"
            self.pointsLabel.text = "\(robot.points!)"
            self.levelLabel.text = "\(robot.level!)"
            self.healthLabel.text = "\(robot.health!)"
            self.energyLabel.text = "\(robot.energy!)"
            self.defenceLabel.text = "\(robot.defence!)"
            self.damageLabel.text = "\(robot.damage!)"
            self.attackSpeedLabel.text = "\(robot.attackSpeed!)"
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        /* Configure section header text color */
        let header = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor(red: 182, green: 182, blue: 182, alpha: 1.0)
    }
    
    // MARK: - Helpers
    func loadRobotData() {
        if downloadingRobotData { return }
        downloadingRobotData = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let currentRobotID = appDelegate?.currentRobot!.id

        
        let URL =  NSURL(string: "https://api.metalmind.rocks/v1/robots/\(currentRobotID!)")
        var mutableURLRequest = NSMutableURLRequest(URL: URL!)
        if token != nil {
            mutableURLRequest.setValue(token!, forHTTPHeaderField: "Authorization")
        }
        
        var manager = Alamofire.Manager.sharedInstance
        var request = manager.request(mutableURLRequest)
        
        request.RobotDataLoadResponseJSON { (request, response, JSON, error) -> Void in
            
            if JSON != nil && error == nil {
                println(response)
                println(JSON)
                
                self.robot = Robot(json: JSON!.first!)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.winLabel.text = "\(self.robot?.win!)"
                    self.loseLabel.text = "\(self.robot?.lost!)"
                    self.xpLabel.text = "\(self.robot?.points!)"
                    self.pointsLabel.text = "\(self.robot?.points!)"
                    self.levelLabel.text = "\(self.robot?.level!)"
                    self.healthLabel.text = "\(self.robot?.health!)"
                    self.energyLabel.text = "\(self.robot?.energy!)"
                    self.defenceLabel.text = "\(self.robot?.defence!)"
                    self.damageLabel.text = "\(self.robot?.damage!)"
                    self.attackSpeedLabel.text = "\(self.robot?.attackSpeed!)"
                }
            }
        }
        downloadingRobotData = false
    }
}