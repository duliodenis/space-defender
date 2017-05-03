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
    
    let shootButton = SKSpriteNode(imageNamed: "shootButton")
    let laserBeamSound = SKAction.playSoundFileNamed("laserBeamSound.mp3", waitForCompletion: false)
    
    
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
        
        // position, scale, and anchor the shoot button
        shootButton.position = CGPoint(x: size.width * 0.80, y: size.height * 0.15)
        shootButton.setScale(0.2)
        shootButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shootButton.zPosition = 10
        shootButton.name = "shootButton"
        addChild(shootButton)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let touchedNode = atPoint(touchLocation)
            
            // if the spaceship is being tapped then make it the moveableNode
            if spaceship.contains(touchLocation) {
                moveableNode = spaceship
                spaceshipStartX = (moveableNode?.position.x)! - touchLocation.x
                spaceshipStartY = (moveableNode?.position.y)! - touchLocation.y
            }
            
            if touchedNode.name == "shootButton" {
                run(laserBeamSound)
                shootLaserBeam()
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
    
    
    // MARK: - Laser Beam Animation
    
    func shootLaserBeam() {
        let laserBeam = SKSpriteNode(imageNamed: "laserBeam")
        
        // anchor, scale, name and set the laser beam position
        laserBeam.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        laserBeam.zPosition = 3
        laserBeam.setScale(0.10)
        laserBeam.name = "laserBeam"
        laserBeam.position = spaceship.position
        addChild(laserBeam)
        
        // set motion constants and destroy once complete
        let moveY = size.height
        let moveDuration = 1.5
        let move = SKAction.moveBy(x: 0, y: moveY, duration: moveDuration)
        let remove = SKAction.removeFromParent()
        
        // define sequence of motion and removal
        let sequence = SKAction.sequence([move, remove])
        
        laserBeam.run(sequence)
    }
    
}
