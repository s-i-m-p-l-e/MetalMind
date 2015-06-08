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
    
    var image: UIImage?
    var name: String?
    var description: String?
    var builder = Builder()
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    init(json: [String: NSObject]) {
        if let id = json["id"] as? Int {
            self.id = id
        } else {
            log("Invalid json[\"_id\"] field - expected Int")
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
}