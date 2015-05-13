//
//  SignUpViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/12/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    
    // MARK: - Variables
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
    
    // MARK: - Private helpers
    private func validateUsername(username: String) -> Bool {
        return true
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@",emailRegex)
        return emailTest.evaluateWithObject(email)
    }
    
    private func validatePassword(password: String, retypePassword: String) -> Bool {
        if password != retypePassword { return false }
        return true
    }
    
    private func registerUser() {
        if !validateEmail(emailTextField.text) {
            alertView.message = "Invalid email address"
            alertView.show()
        }
    }
}
