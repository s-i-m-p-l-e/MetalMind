//
//  LoginViewController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/6/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK:- UIViewContorlle Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        println("login view appeared")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}