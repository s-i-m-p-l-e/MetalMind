//
//  LoginViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/6/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Locksmith
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var audioAnimationView: UIView!
    
    // MARK: - Variables
    let alertView = UIAlertView(title: "Please try again", message: "", delegate: nil, cancelButtonTitle: "OK")
    
    // MARK: - UIViewContorlle Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Direct user to usernameTextField when view is presented */
//        usernameTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    // MARK: - IBActions
    /* Login user action */
    @IBAction func loginButtonAction(sender: UIButton) {
        loginUser()
    }
    
    /* Gesture recognizer action */
    @IBAction func tagGestureRecognizer(sender: UITapGestureRecognizer) {
        /* hide keyboard */
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    /* Define action for text fields return key */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            self.passwordTextField.becomeFirstResponder()
        case passwordTextField:
            loginUser()
        default: break
        }
        return true
    }
    
    // MARK: - Configuring the View Rotation Settings
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
    // MARK: - Private helpers
    /* Login user using username and password */
    private func loginUser() {
        let url = "https://api.metalmind.rocks/v1/authenticate"
        let parameters = [
            "username": usernameTextField.text,
            "password": passwordTextField.text
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON).responseJSON {
            (_, response, jsonObject, error) in
//            println(response!)
//            println(jsonObject!)
            
            if error == nil {
                if let token = jsonObject!.objectForKey("token") as? String {
                    let keychainError = Locksmith.saveData(["token": token], forUserAccount: "MetalMindUserAccount")
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.alertView.message = jsonObject!.objectForKey("message") as? String
                    self.alertView.show()
                }
            }
        }
    }
}