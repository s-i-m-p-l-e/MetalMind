//
//  NavigationController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/9/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {
    
    // MARK: - Configuring the View Rotation Settings
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return self.topViewController.supportedInterfaceOrientations()
    }
}