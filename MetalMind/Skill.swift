//
//  Skill.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/14/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import UIKit

class Skill {
    
    var id: Int?
    var effect: String?
    var value: Int?
    var cost: Int?
    var actionID: Float?
    
    var image: UIImage?
    var name: String?
    var description: String?
    var builder = Builder()
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    init(json: [String: NSObject]) {
        println(json)
        if let id = json["id"] as? Int {
            self.id = id
        } else {
            log("Invalid json[\"id\"] field - expected Int")
            self.id = nil
        }
        
        if let effect = json["effect"] as? String {
            self.effect = effect
        } else {
            log("Invalid json[\"effect\"] field - expected String")
            self.effect = nil
        }
        
        if let value = json["value"] as? Int {
            self.value = value
        } else {
            log("Invalid json[\"value\"] field - expected Int")
            self.value = nil
        }
        
        if let cost = json["cost"] as? Int {
            self.cost = cost
        } else {
            log("Invalid json[\"cost\"] field - expected Int")
            self.cost = nil
        }
        
        if let name = json["name"] as? String {
            self.name = name
        } else {
            log("Invalid json[\"name\"] field - expected String")
            self.name = nil
        }
        
        if let description = json["description"] as? String {
            self.description = description
        } else {
            log("Invalid json[\"description\"] field - expected String")
            self.description = nil
        }
    }
    
    init(activeSkillJSON: [String: NSObject]) {
        
        if let id = activeSkillJSON["id"] as? Int {
            self.id = id
        } else {
            log("Invalid json[\"id\"] field - expected Int")
            self.id = nil
        }
        
        if let action = activeSkillJSON["action"] as? [String: NSObject] {
            if let name = action["name"] as? String {
                self.name = name
            } else {
                log("Invalid json[\"name\"] field - expected String")
                self.name = nil
            }
            if let id = action["id"] as? Float {
                self.actionID = id
            } else {
                log("Invalid json[\"actionId\"] field - expected Float")
                self.actionID = nil
            }
            
            if let description = action["description"] as? String {
                self.description = description
            } else {
                log("Invalid json[\"description\"] field - expected String")
                self.description = nil
            }
        }
        
        if let trigger = activeSkillJSON["trigger"] as? [String: NSObject] {
            builder.trigger = Trigger(json: trigger)
        }
        
        if let clause = activeSkillJSON["clause"] as? [String: NSObject] {
            builder.clause = Clause(json: clause)
        }
    }
}