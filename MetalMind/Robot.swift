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
    var attackSpeed: Float?
    var health: Float?
    var energy: Float?
    var defence: Float?
    var damage: Float?
    var level: UInt?
//    owner (User, optional),
    var points: UInt?
    var win: UInt?
    var lost: UInt?
//    currentConfig (string, optional): The current attached config for the robot which will be used in battles
    
    init (json: [String: NSObject]) {
        if let id = json["id"] as? Int {
            self.id = id
        } else {
            log("Invalid json[\"_id\"] field - expected Int")
            self.id = nil
        }
        
        if let name = json["name"] as? String {
            self.name = name
        } else {
            log("Invalid json[\"name\"] field - expected String")
            self.name = nil
        }
        
        if let attackSpeed = json["attackSpeed"] as? Float {
            self.attackSpeed = attackSpeed
        } else {
            log("Invalid json[\"attackSpeed\"] field - expected Float")
            self.attackSpeed = nil
        }
        
        if let health = json["health"] as? Float {
            self.health = health
        } else {
            log("Invalid json[\"helth\"] field - expected Float")
            self.health = nil
        }
        
        if let energy = json["energy"] as? Float {
            self.energy = energy
        } else {
            log("Invalid json[\"energy\"] field - expected Float")
            self.energy = nil
        }
        
        if let defence = json["defence"] as? Float {
            self.defence = defence
        } else {
            log("Invalid json[\"defence\"] field - expected Float")
            self.defence = nil
        }
        
        if let damage = json["damage"] as? Float {
            self.damage = damage
        } else {
            log("Invalid json[\"damage\"] field - expected Float")
            self.damage = nil
        }
        
        if let level = json["level"] as? UInt {
            self.level = level
        } else {
            log("Invalid json[\"level\"] field - expected UInt")
            self.level = nil
        }
        
        if let points = json["points"] as? UInt {
            self.points = points
        } else {
            log("Invalid json[\"points\"] field - expected UInt")
            self.points = nil
        }
        
        if let win = json["wins"] as? UInt {
            self.win = win
        } else {
            log("Invalid json[\"wins\"] field - expected UInt")
            self.win = nil
        }
        
        if let lost = json["looses"] as? UInt {
            self.lost = lost
        } else {
            log("Invalid json[\"looses\"] field - expected UInt")
            self.lost = nil
        }

    }
}

extension Robot: Printable {
    var description: String {
        get {
            var dataArray: [String] = []
            if let id = self.id { dataArray.append( "ID: \(id)") }
            if let name = self.name { dataArray.append("Name: \(name)") }
            if let attackSpeed = self.attackSpeed { dataArray.append("Attack Speed: \(attackSpeed)") }
            if let health = self.health { dataArray.append("Health: \(health)") }
            if let energy = self.energy { dataArray.append("Energy: \(energy)") }
            if let defence = self.defence { dataArray.append("Defence: \(defence)") }
            if let damage = self.damage { dataArray.append("Damage: \(damage)") }
            if let points = self.points { dataArray.append("Ponits: \(points)") }
            if let win = self.win { dataArray.append("Win: \(win)") }
            if let lost = self.lost { dataArray.append("Lost: \(lost)") }
            return join("\n", dataArray)
        }
    }
}

extension Robot: Equatable {}

func ==(lhs: Robot, rhs: Robot) -> Bool {
    return lhs.id == rhs.id
}
