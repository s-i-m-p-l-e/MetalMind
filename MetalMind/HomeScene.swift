//
//  HomeScene.swift
//  MetalMind
//
//  Created by Victor Vasilica on 3/28/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import SpriteKit
import MetalMindKit

class HomeScene: SKScene {
    
    let player = MMPlayer(horizontalSpriteOrientation: .Right)
    
    override func didMoveToView(view: SKView) {
        player.textures[.Down] = SKTextureAtlas(named: "downWalk").textures
        player.textures[.Horizontal] = SKTextureAtlas(named: "rightWalks").textures
        
        println(player.textures[.Down])
        
        let backgroundImage = SKSpriteNode(imageNamed: "spaceShipBackground")
        player.spriteNode.size = CGSizeMake(size.width * 0.8, size.height * 0.6)
        player.spriteNode.position = CGPoint(x: size.width/2, y: size.height/3)
        
        backgroundImage.position = CGPointMake(size.width/2, size.height/2 - 40.0)
        addChild(backgroundImage)
        addChild(player.spriteNode)
        
        if let moveDown = player.moveDownAction() {
            player.spriteNode.runAction(SKAction.repeatActionForever(moveDown))
        }
        
        if let moveRight = player.moveRightAction(130.0, duration: 4.0) {
            player.spriteNode.runAction(moveRight) {
                if let moveLeft = self.player.moveLeftAction(130.0, duration: 4.0) {
                    self.player.spriteNode.runAction(moveLeft, completion: nil)
                }
            }
        }
    }
}