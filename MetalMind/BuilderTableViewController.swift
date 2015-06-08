//
//  BuilderTableViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/21/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

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
    
    // MARK: - UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Make table header smaller */
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 0.1))
        
        /* Gesture recognizer to hide keypad */
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tapGestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGestureRecognizer)
        
        /* Update interface to show builder changes */
        saveChangesButton.setTitle(self.navigationItem.title, forState: .Normal)
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
    
    func changeData() {
        
    }
    
    // MARK: - IBActions
    @IBAction func saveChangesButtonAction(sender: UIButton) {
        skillBuilder?.trigger.when = When(rawValue: UInt32(whenSegmenControl.selectedSegmentIndex))!
        skillBuilder?.trigger.who = Who(rawValue: UInt32(whoSegmentControl.selectedSegmentIndex))!
        skillBuilder?.trigger.what = What(rawValue: UInt32(whatSegmentControl.selectedSegmentIndex))!
        
        skillBuilder?.clause.actor = Actor(rawValue: UInt32(actorSegmentControl.selectedSegmentIndex))!
        skillBuilder?.clause.stats = Stats(rawValue: UInt32(statsSegmentControl.selectedSegmentIndex))!
        skillBuilder?.clause.mmOperator = MMOperator(rawValue: UInt32(operatorSegmentControl.selectedSegmentIndex))!
        skillBuilder?.clause.value = valueTextField.text.floatValue
        skillBuilder?.clause.metrics = Metrics(rawValue: UInt32(metricsSegmentControl.selectedSegmentIndex))!
        
        delegate?.controller(self, didChangeSkillData: true, index: self.skillIndex!, builder: self.skillBuilder!)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

internal extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
