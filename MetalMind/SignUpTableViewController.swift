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
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Variables
    var delegate: HomeViewControllerDelegate?
    let userAccount = "MetalMindUserAccount"
    let alertView = UIAlertView(title: "Please try again", message: "", delegate: nil, cancelButtonTitle: "OK")
    
    // MARK: - UIViewController Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /* navigation and tab bar configuration */
        self.navigationItem.hidesBackButton = true

        /* configure table view */
        let backgroundImage = UIImageView(image: UIImage(named: "metal_mind_background"))
        backgroundImage.frame = self.tableView.bounds
        self.tableView.backgroundView = backgroundImage
        
        /* configure text fields */
        // Username text field
        self.usernameTextField.layer.borderWidth = 1.0
        self.usernameTextField.layer.borderColor = UIColor.whiteColor().CGColor
        self.usernameTextField.attributedPlaceholder = NSAttributedString(
            string:self.usernameTextField.placeholder!,
            attributes: [NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: 0.35)]);
        
        // Email text field
        self.emailTextField.layer.borderWidth = 1.0
        self.emailTextField.layer.borderColor = UIColor.whiteColor().CGColor
        self.emailTextField.attributedPlaceholder = NSAttributedString(
            string:self.emailTextField.placeholder!,
            attributes: [NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: 0.35)]);
        
        // Password text field
        self.passwordTextField.layer.borderWidth = 1.0
        self.passwordTextField.layer.borderColor = UIColor.whiteColor().CGColor
        self.passwordTextField.attributedPlaceholder = NSAttributedString(
            string:self.passwordTextField.placeholder!,
            attributes: [NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: 0.35)]);
        
        // Retype Password text field
        self.retypePasswordTextField.layer.borderWidth = 1.0
        self.retypePasswordTextField.layer.borderColor = UIColor.whiteColor().CGColor
        self.retypePasswordTextField.attributedPlaceholder = NSAttributedString(
            string:self.retypePasswordTextField.placeholder!,
            attributes: [NSForegroundColorAttributeName: UIColor(red: 255, green: 255, blue: 255, alpha: 0.35)]);
        
        // Sign up button
        self.registerButton.layer.borderWidth = 1.0
        self.registerButton.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    // MARK: - IBActions
    @IBAction func returnBackToLoginViewController(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
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
                    if self.invalidPassword() {
                        self.alertView.message = "Password do not match"
                        self.alertView.show()
                        return
                    }
                    
                    let keychainError = Locksmith.saveData(["token": token], forUserAccount: self.userAccount)
                
                    self.alertView.title = "Congradulations!"
                    self.alertView.message = "Registration successfully"
                    self.alertView.show()
                    if let delegate = self.delegate {
                        delegate.controller(self, didLoginUser: true)
                    }
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            }
        }
        
    }
}
