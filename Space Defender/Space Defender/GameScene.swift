//
//  GameScene.swift
//  Space Defender
//
//  Created by Dulio Denis on 5/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let spaceship = SKSpriteNode(imageNamed: "rocket")
    
    override func didMove(to view: SKView) {
        // midnight blue background
        backgroundColor = SKColor(red: 44/256, green: 62/256, blue: 80/256, alpha: 1.0)
        
        // position, scale and anchor the spaceship
        spaceship.position = CGPoint(x: size.width * 0.2, y: size.height * 0.2)
        spaceship.setScale(0.4)
        spaceship.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spaceship.zPosition = 5
        spaceship.name = "spaceship"
        addChild(spaceship)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
