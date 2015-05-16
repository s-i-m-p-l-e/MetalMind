//
//  File.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/14/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import Foundation

class Robot {
    
    var id: Int?
    var name: String?
    var attackSpeed: Float? = 3.0
    var health: Float? = 300.0
    var energy: Float? = 300.0
    var defence: Float? = 10.0
    var damage: Float? = 10.0
    var level: UInt? = 1
//    owner (User, optional),
    var points: UInt? = 3
    var wins: UInt? = 0
    var looses: UInt? = 0
//    currentConfig (string, optional): The current attached config for the robot which will be used in battles
    
    init (json: [String: NSObject]) {
        if let id = json["_id"] as? Int {
            self.id = id
        } else {
            log("Invalid json[\"_id\"] field - expected string")
            self.id = nil
        }
}