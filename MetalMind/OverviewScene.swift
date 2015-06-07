//
//  HomeScene.swift
//  MetalMind
//
//  Created by Victor Vasilica on 3/28/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import SpriteKit

class OverviewScene: SKScene {
    
    // MARK: - Variables
    let player = MMPlayer(horizontalSpriteOrientation: .Right)
    let downTextures = SKTextureAtlas(named: "downWalk").textures
    let horizontalTextures = SKTextureAtlas(named: "rightWalks").textures
    let idleTextures = SKTextureAtlas(named: "idleCharTest").textures
    let backgroundSceneImage = SKSpriteNode(imageNamed: "dark_background")
    
    // MARK: - SKScene Life-Cycle
    override func didMoveToView(view: SKView) {
        /* load textures */
        player.textures[.Down] = downTextures
        player.textures[.Horizontal] = horizontalTextures
        player.textures[.Idle] = idleTextures
        let backgroundImage = backgroundSceneImage
        
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




