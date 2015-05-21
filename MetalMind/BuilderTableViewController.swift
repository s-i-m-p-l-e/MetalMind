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
    
    // MARK: - UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* make table header smaller */
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 0.1))
        
        /* Gesture recognizer to hide  */
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        tapGestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGestureRecognizer)
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
    
    // MARK: - IBActions
    @IBAction func saveChangesButtonAction(sender: UIButton) {
        delegate?.controller(self, didSaveSkillData: true)
    }
    
}