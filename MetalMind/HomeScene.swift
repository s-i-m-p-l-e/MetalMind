//
//  HomeScene.swift
//  MetalMind
//
//  Created by Victor Vasilica on 3/28/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import SpriteKit
import MetalMindKit
import SpineSpriteKit
import ObjectiveSpine

class HomeScene: SKScene {
    
    let player = MMPlayer(horizontalSpriteOrientation: .Right)
    
    override func didMoveToView(view: SKView) {
        /* load textures */
        player.textures[.Down] = SKTextureAtlas(named: "downWalk").textures
        player.textures[.Horizontal] = SKTextureAtlas(named: "rightWalks").textures
        player.textures[.Idle] = SKTextureAtlas(named: "idleCharTest").textures
        let backgroundImage = SKSpriteNode(imageNamed: "spaceShipBackground")
        
        /* sizing and positioning textures */
        player.setSpriteNodeSize(.Idle)
        player.spriteNode.setScale(0.5)
        player.spriteNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        backgroundImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        addChild(backgroundImage)
        addChild(player.spriteNode)
        
        if let idlePosition = player.idleAction() {
            player.spriteNode.runAction(SKAction.repeatActionForever(idlePosition))
        }
    }
}




