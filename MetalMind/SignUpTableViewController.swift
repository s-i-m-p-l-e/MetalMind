//
//  SignUpViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/12/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

class SignUpTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    // MARK: - Variables
    let userAccount = "MetalMindUserAccount"
    let alertView = UIAlertView(title: "Please try again", message: "", delegate: nil, cancelButtonTitle: "OK")
    
    // MARK: - IBActions
    @IBAction func returnBackToLoginViewController(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUpButtonAction(sender: UIButton) {
        registerUser()
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            self.emailTextField.becomeFirstResponder()
        case emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case passwordTextField:
            self.retypePasswordTextField.becomeFirstResponder()
        case retypePasswordTextField:
            registerUser()
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
    private func invalidPassword() -> Bool {
        return self.passwordTextField.text != self.retypePasswordTextField.text
    }
    
    private func registerUser() {
        let url = "https://api.metalmind.rocks/v1/user"
        let parameters = [
            "username": usernameTextField.text,
            "email": emailTextField.text,
            "password": passwordTextField.text
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON).responseJSON { (request, response, jsonObject, error) in
//            println(request)
//            println(response)
//            println(jsonObject)
//            println(error)
            
            if error == nil {
                if let json = jsonObject! as? [[String:String]] {
                    var errorMessages: String = ""
                    
                    for jsonDictionary in json {
                        errorMessages += jsonDictionary["message"]! + "\n"
                    }
                    
                    if self.invalidPassword() {
                        errorMessages += "Password do not match"
                    }
                    
                    
                    self.alertView.message = errorMessages
                    self.alertView.show()
                } else {
                    let token = jsonObject!.objectForKey("token") as! String
                    let keychainError = Locksmith.saveData(["token": token], forUserAccount: self.userAccount)
                    
                    if self.invalidPassword() {
                        self.alertView.message = "Password do not match"
                        self.alertView.show()
                        return
                    }
                    
                    self.alertView.message = "Registered successfully"
                    self.alertView.show()
                    self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
    }
}
