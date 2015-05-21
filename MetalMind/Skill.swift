//
//  Skill.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/14/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

class Skill {
    
    var image: UIImage?
    var name: String?
    var description: String?
    var builder = Builder()
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
}