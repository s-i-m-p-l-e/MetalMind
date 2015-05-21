//
//  OverviewViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/6/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Foundation

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
    
    // MARK: - UIViewController Life-Cycle
    override func viewDidLoad() {
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
        
//        [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor whiteColor]];
//        
//        UILabel.appearanceForTraitCollection(<#trait: UITraitCollection#>)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        /* Configure section header text color */
        let header = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = UIColor(red: 182, green: 182, blue: 182, alpha: 1.0)
    }
}