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

class LoginViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    // MARK:- UIViewContorlle Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    // MARK:- IBActions
    @IBAction func loginButtonAction(sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        let url = "https://api.metalmind.rocks/v1/authenticate"
        let parameters = [
            "username": username,
            "password": password
        ]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
                 .responseJSON { (_, _, jsonObject, error) in
                    let json = jsonObject as? [String: String]

                    if let token = json?["token"] where error == nil {
                        let keychainError = Locksmith.saveData(["token": token], forUserAccount: "MetalMindUserAccount")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
        }
    }
    
    @IBAction func loginViewTap(sender: UITapGestureRecognizer) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}