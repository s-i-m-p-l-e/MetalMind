//
//  RootTabBarController.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/9/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {
    
    // MARK: - Configuring the View Rotation Settings
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if self.selectedViewController != nil {
            return self.selectedViewController!.supportedInterfaceOrientations()
        }
        
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
}
