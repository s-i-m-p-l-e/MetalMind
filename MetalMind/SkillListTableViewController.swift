//
//  SkillListTableViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/21/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

class SkillListTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, SkillListDelegate {
    
    // MARK: - Segue Identifiers
    let builderTVCSegue = "ShowBuilderTableViewController"
    
    // MARK: - Variables
    var skillList = [Skill]()
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        /* make table header smaller */
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 0.1))
        
        skillList.append(Skill(name: "Attack", description: "Basic attack"))
        skillList.append(Skill(name: "Heal", description: "Heals the character"))
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
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let index = sender as! Int
        
        switch segue.identifier! {
        case builderTVCSegue:
            let builderTVC = segue.destinationViewController as? BuilderTableViewController
            builderTVC?.delegate = self
            builderTVC?.skillIndex = index
            builderTVC?.skillBuilder = skillList[index].builder
            builderTVC?.navigationItem.title = skillList[index].name
        default: break
        }
    }
}
