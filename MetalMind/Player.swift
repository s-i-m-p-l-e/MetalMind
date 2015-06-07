//
//  Player.swift
//  MetalMind
//
//  Created by Victor Vasilica on 5/11/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import SpriteKit

/**
Responsible for player actions, animations and positioning in the `MMArena`.
*/
 class MMPlayer {
    
    // MARK: - variables
     var textures = [MMSpriteOrientation: [SKTexture]]()
     weak var parentScene: SKScene?
     var spriteNode = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: 50.0, height: 50.0))
    
    private var currentSpriteOrientation: HorizontalOrientation
    
    /**
    Default initializer
    */
     init(horizontalSpriteOrientation: HorizontalOrientation) {
        self.currentSpriteOrientation = horizontalSpriteOrientation
    }
    
    /** Animated action for idle position */
     func idleAction() -> SKAction? {
        if textures[.Idle] == nil { return nil }
        
        let firstTexture = textures[.Idle]?.first
        spriteNode.texture = firstTexture
        let animationAction = SKAction.animateWithTextures(textures[.Idle]!,
            timePerFrame: 1.0/Double(textures[.Idle]!.count))
        
        return animationAction
    }
    
    /** Animated action to move down */
     func moveDownAction() -> SKAction? {
        if textures[.Down] == nil { return nil }
        
        let firstTexture = textures[.Down]?.first
        let animationAction = SKAction.animateWithTextures(textures[.Down]!,
            timePerFrame: 1.0/Double(textures[.Down]!.count))
        
        return animationAction
    }
    
    /** Animated action to move up */
     func moveUpAction() -> SKAction? {
        if textures[.Up] == nil { return nil }
        
        let firstTexture = textures[.Up]?.first
        spriteNode.texture = firstTexture
        let animationAction = SKAction.animateWithTextures(textures[.Down]!,
            timePerFrame: 1.0/Double(textures[.Up]!.count))
        
        return animationAction
    }
    
    /**
    Animated action to move right
    
    :param: distance How far from current position
    :param: duration How long should the shifting take
    */
     func moveRightAction(distance: CGFloat, duration: NSTimeInterval) -> SKAction? {
        if textures[.Horizontal] == nil { return nil }
        if currentSpriteOrientation != .Right {
            spriteNode.xScale *= -1
            currentSpriteOrientation = .Right
        }
        
        let firstTexture = textures[.Horizontal]?.first
        spriteNode.texture = firstTexture
        let animationAction = SKAction.animateWithTextures(textures[.Horizontal]!,
            timePerFrame: duration/Double(textures[.Horizontal]!.count))
        let shiftAction = SKAction.moveBy(CGVector(dx: distance, dy: 0.0), duration: duration)
        
        return SKAction.group([animationAction, shiftAction])
    }
    
    /**
    Animated action to move left
    
    :param: distance How far from current position
    :param: duration How long should the shifting take
    */
     func moveLeftAction(distance: CGFloat, duration: NSTimeInterval) -> SKAction? {
        if textures[.Horizontal] == nil { return nil }
        if currentSpriteOrientation != .Left {
            spriteNode.xScale *= -1
            currentSpriteOrientation = .Left
        }
        
        let firstTexture = textures[.Horizontal]?.first
        spriteNode.texture = firstTexture
        let animationAction = SKAction.animateWithTextures(textures[.Horizontal]!,
            timePerFrame: duration/Double(textures[.Horizontal]!.count))
        let shiftAction = SKAction.moveBy(CGVector(dx: -distance, dy: 0.0), duration: duration)
        
        return SKAction.group([animationAction, shiftAction])
    }
    
    /**
    Set sprite node size to the size of the first texture in the chosen orientation category
    
    :param: orientationSprites From what sprite orientation category to take texture for sizing
    */
     func setSpriteNodeSize(orientationSprites: MMSpriteOrientation) {
        let texture = textures[orientationSprites]?.first
        let newSize = texture!.size()
        spriteNode.size = newSize
    }
}   

/**
Possible movment directions for animation
*/
 enum MMSpriteOrientation: String {
    case Down = "Down"
    case Horizontal = "Horizontal"
    case Up = "Up"
    case Idle = "Idle"
}

extension MMSpriteOrientation: Printable {
     var description: String { get { return self.rawValue } }
}

 enum HorizontalOrientation: String {
    case Left = "Left"
    case Right = "Right"
}

extension HorizontalOrientation: Printable {
     var description: String { get { return self.rawValue } }
}

/** Extension to extract textures easier */
 extension SKTextureAtlas {
    /** Extract all textures in an array */
    var textures: [SKTexture] {
        let orderedTextureNames = (self.textureNames as! [String]).sorted() { $0 < $1 }
        return map(orderedTextureNames) { self.textureNamed($0) }
    }
}