//
//  HomeScene.swift
//  MetalMind
//
//  Created by Victor Vasilica on 3/28/15.
//  Copyright (c) 2015 simple. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {

    
    let playerWalkAnimationAtlas = SKTextureAtlas(named: "boyDownWalk")
    lazy var playerWalkFrames: [SKTexture] = {
        let frameNames = self.playerWalkAnimationAtlas.textureNames as! [String]
        var lazyPlayerWalkFrames = [SKTexture]()
        
        for name in frameNames {
            lazyPlayerWalkFrames.append(
                self.playerWalkAnimationAtlas.textureNamed(name)
                )
        }
        
        return lazyPlayerWalkFrames
    }()
    
    override func didMoveToView(view: SKView) {
        
        let firstFrame = playerWalkFrames.first!
        let player = SKSpriteNode(texture: firstFrame)
        let backgroundImage = SKSpriteNode(imageNamed: "spaceShipBackground")
        
        player.size = CGSizeMake(size.width * 0.8, size.height * 0.6)
        player.position = CGPoint(x: size.width/2, y: size.height/3)

        backgroundImage.position = CGPointMake(size.width/2, size.height/2 - 40.0)
        

        let playerWalkAction = SKAction.animateWithTextures(playerWalkFrames, timePerFrame: 0.5)
        player.runAction(SKAction.repeatActionForever(playerWalkAction))
        
        self.backgroundColor = SKColor.whiteColor()
        
        addChild(backgroundImage)
        addChild(player)
        
    }
}