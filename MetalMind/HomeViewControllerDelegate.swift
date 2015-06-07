//
//  HomeViewControllerDelegate.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/18/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate {
    func controller(controller: UIViewController, didLoginUser: Bool)
    func controller(contorller: UIViewController, didAddRobot: Bool)
}
