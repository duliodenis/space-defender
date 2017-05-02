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
    // to keep track of the drag
    var moveableNode: SKNode?
    // to keep track of the spaceship original position
    var spaceshipStartX: CGFloat = 0.0
    var spaceshipStartY: CGFloat = 0.0
    
    
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
        
        // animateSpaceship()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            // if the spaceship is being tapped then make it the moveableNode
            if spaceship.contains(touchLocation) {
                moveableNode = spaceship
                spaceshipStartX = (moveableNode?.position.x)! - touchLocation.x
                spaceshipStartY = (moveableNode?.position.y)! - touchLocation.y
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, moveableNode != nil {
            let location = touch.location(in: self)
            // update the moveableNode's position
            moveableNode!.position = CGPoint(x: location.x + spaceshipStartX, y: location.y + spaceshipStartY)
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first, moveableNode != nil {
            moveableNode = nil
        }
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            moveableNode = nil
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    // MARK: - Spaceship Animation
    
    func animateSpaceship() {
        let rightMovement = SKAction.moveTo(x: size.width * 0.80, duration: 2.5)
        let leftMovement = SKAction.moveTo(x: size.width * 0.20, duration: 2.5)
        
        let sequence = SKAction.sequence([rightMovement, leftMovement])
        let animation = SKAction.repeatForever(sequence)
        
        spaceship.run(animation)
    }
    
}
