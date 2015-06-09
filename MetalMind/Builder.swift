//
//  Builder.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/18/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import Foundation

// MARK: - Builder

struct Builder {
    
    var trigger: Trigger
    var clause: Clause
    
    init() {
        self.trigger = Trigger()
        self.clause = Clause()
    }
    
    static func toRandomDictionary() -> [String : [String : String]] {
        let trigger: [String : String] = Trigger.toRandomDictionary()
        let clause: [String : String] = Clause.toRandomDictionary()
        return ["trigger": trigger,
                "clause": clause,
                "action": ["actionId": "1.0", "quantity": "1.0"],
                "actions": [ "id": "1.0",
                             "effect": "health",
                             "value": "100.0",
                             "cost": "3.0",
                             "duration": "null"
                           ]
                ]
    }
    
    func toDefaultDictionary() -> [String : [String : String]] {
        let trigger: [String : String] = self.trigger.toDictionary()
        let clause: [String : String] = self.clause.toDictionary()
        return ["trigger": trigger,
            "clause": clause,
            "action": ["actionId": "1.0", "quantity": "1.0"],
            "actions": [ "id": "1.0",
                "effect": "health",
                "value": "100.0",
                "cost": "3.0",
                "duration": "null"
            ]
        ]
    }

}


// MARK: - Trigger

struct Trigger {
    var when: When = .Before
    var who: Who = .Me
    var what: What = .Attack
    
    init() {
        self.when = .Before
        self.who =  .Me
        self.what = .Attack
    }
    
    init(json: [String: NSObject]) {
        self.when = When.fromString(json["when"] as! String)!
        self.who = Who.fromString(json["who"] as! String)!
        self.what = What.fromString(json["what"] as! String)!
    }
    
    func toDictionary() -> [String : String] {
        return ["when": self.when.toString(),
                "who": self.who.toString(),
                "what": self.what.toString()]
    }
    
    static func toRandomDictionary() -> [String : String] {
        return ["when": When.random().toString(),
                "who": Who.random().toString(),
                "what": What.random().toString()]
    }
}

enum When: UInt32 {
    case Before
    case After
    
    static func fromString(str: String) -> When? {
        switch str {
            case "before": return .Before
            case "after": return .After
            default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .Before:
            return "before"
        case .After:
            return "after"
        }
    }
    
    static var count: UInt32 {
        var max: UInt32 = 0
        while let _ = self(rawValue: ++max) {}
        return max
    }
    
    static func random() -> When {
        let rand = arc4random_uniform(When.count)
        return self(rawValue: rand)!
    }
}

enum Who: UInt32 {
    case Me
    case Enemy
    
    static func fromString(str: String) -> Who? {
        switch str {
        case "me": return .Me
        case "enemy": return .Enemy
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .Me:
            return "me"
        case .Enemy:
            return "enemy"
        }
    }
    
    static var count: UInt32 {
        var max: UInt32 = 0
        while let _ = self(rawValue: ++max) {}
        return max
    }
    
    static func random() -> Who {
        let rand = arc4random_uniform(Who.count)
        return self(rawValue: rand)!
    }
}

enum What: UInt32 {
    case Attack
    
    static func fromString(str: String) -> What? {
        switch str {
        case "attack": return .Attack
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .Attack:
            return "attack"
        }
    }
    
    static var count: UInt32 {
        var max: UInt32 = 0
        while let _ = self(rawValue: ++max) {}
        return max
    }
    
    static func random() -> What {
        let rand = arc4random_uniform(What.count)
        return self(rawValue: rand)!
    }
}


// MARK: - Caluse
struct Clause {
    var actor: Actor = .Me
    var stats: Stats = .Health
    var mmOperator: MMOperator = .Less
    var value: Float = 0.0
    var metrics: Metrics = .Points
    
    init() {
        self.actor = .Me
        self.stats = .Health
        self.mmOperator = .Less
        self.value = 0.0
        self.metrics = .Points
    }
    
    init(json: [String:NSObject]) {
        self.actor = Actor.fromString(json["actor"] as! String)!
        self.stats = Stats.fromString(json["stats"] as! String)!
        self.mmOperator = MMOperator.fromString(json["operator"] as! String)!
        let stringValue = json["value"] as? NSString
        self.value = stringValue!.floatValue
        self.metrics = Metrics.fromString(json["metrics"] as! String)!
    }
    
    func toDictionary() -> [String : String] {
        return ["actor": self.actor.toString(),
                "stats": self.stats.toString(),
                "operator": self.mmOperator.toString(),
                "value": "\(self.value)",
                "metrics": self.metrics.toString()]
    }
    
    static func toRandomDictionary() -> [String : String] {
        return ["actor": Actor.random().toString(),
                "stats": Stats.random().toString(),
                "operator": MMOperator.random().toString(),
                "value": "\(Double.random(min: 2.0, max: 20.0))",
                "metrics": Metrics.random().toString()]
    }
}

enum Actor: UInt32 {
    case Me
    case Enemy
    
    static func fromString(str: String) -> Actor? {
        switch str {
        case "me": return .Me
        case "enemy": return .Enemy
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .Me:
            return "me"
        case .Enemy:
            return "enemy"
        }
    }
    
    static var count: UInt32 {
        var max: UInt32 = 0
        while let _ = self(rawValue: ++max) {}
        return max
    }
    
    static func random() -> Actor {
        let rand = arc4random_uniform(Actor.count)
        return self(rawValue: rand)!
    }
}

enum Stats: UInt32 {
    case Health
    case Damage
    case Energy
    case Armor
    case AttackSpeed
    
    static func fromString(str: String) -> Stats? {
        switch str {
        case "health": return .Health
        case "damage": return .Damage
        case "energy": return .Energy
        case "armor": return .Armor
        case "attackspeed": return .AttackSpeed

        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .Health:
            return "health"
        case .Damage:
            return "damage"
        case .Energy:
            return "energy"
        case .Armor:
            return "armor"
        case .AttackSpeed:
            return "attackSpeed"
        }
    }
    
    static var count: UInt32 {
        var max: UInt32 = 0
        while let _ = self(rawValue: ++max) {}
        return max
    }
    
    static func random() -> Stats {
        let rand = arc4random_uniform(Stats.count)
        return self(rawValue: rand)!
    }
}

enum MMOperator: UInt32 {
    case Less
    case Equal
    case Greater
    case LessOrEqual
    case GreaterOrEqual
    
    static func fromString(str: String) -> MMOperator? {
        switch str {
        case "<": return .Less
        case "=": return .Equal
        case ">": return .Greater
        case "<=": return .LessOrEqual
        case ">=": return .GreaterOrEqual
            
        default: return nil
        }
    }
    
    
    
    func toString() -> String {
        switch self {
        case .Less:
            return "<"
        case .Equal:
            return "="
        case .Greater:
            return ">"
        case .LessOrEqual:
            return "<="
        case .GreaterOrEqual:
            return ">="
        }
    }
    
    static var count: UInt32 {
        var max: UInt32 = 0
        while let _ = self(rawValue: ++max) {}
        return max
    }
    
    static func random() -> MMOperator {
        let rand = arc4random_uniform(MMOperator.count)
        return self(rawValue: rand)!
    }
}

enum Metrics: UInt32 {
    case Points
    case Procents
    
    static func fromString(str: String) -> Metrics? {
        switch str {
        case "points": return .Points
        case "%": return .Procents
            
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .Points:
            return "points"
        case .Procents:
            return "%"
        }
    }
    
    static var count: UInt32 {
        var max: UInt32 = 0
        while let _ = self(rawValue: ++max) {}
        return max
    }
    
    static func random() -> Metrics {
        let rand = arc4random_uniform(Metrics.count)
        return self(rawValue: rand)!
    }
}
