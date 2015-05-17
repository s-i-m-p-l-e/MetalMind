//
//  CreateRobotViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/17/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class CreateRobotViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var robotNameTextField: UITextField!
    
    // MARK: - Variables
    var userData: NSDictionary? {
        get {
            let (data, error) = Locksmith.loadDataForUserAccount("MetalMindUserAccount")
            if error != nil { return nil }
            
            return data
        }
    }
    var token: String?  { return userData?.objectForKey("token") as? String }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        createRobot()
        return true
    }
    
    // MARK: - IBActions
    @IBAction func createRobotButtonAction(sender: AnyObject) {
        createRobot()
    }
    
    @IBAction func tapGestureAction(sender: UITapGestureRecognizer) {
        self.robotNameTextField.resignFirstResponder()
    }
    
    // MARK: - Helpers
    func createRobot() {
        let aManager = Manager.sharedInstance
        if token != nil {
            aManager.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": token! ]
        }
        
        let url = "https://api.metalmind.rocks/v1/robot"
        let parameters = [
            "name": robotNameTextField.text,
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON).responseJSON { (_, response, jsonObject, error) in
//            println(jsonObject)

            if error == nil && jsonObject != nil {
                let alert = UIAlertView(title: "Done", message: "Robot \(self.robotNameTextField.text) created!", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                let navigationStack = self.navigationController?.viewControllers
                let viewControllerCount = navigationStack!.count
                
                if let HomeVC = navigationStack?[viewControllerCount - 2] as? HomeViewController {
                    HomeVC.loadRobotsData()
                }
                self.navigationController?.popViewControllerAnimated(true)
                
            }
        }

    }
}