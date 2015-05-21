//
//  SkillListDelegate.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/22/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

protocol SkillListDelegate {
    func controller(controller: UITableViewController, didChangeSkillData: Bool, index: Int, builder: Builder)
}