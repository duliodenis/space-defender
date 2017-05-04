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
        
        addStarfields()
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
    
    
    // MARK: Starfield background
    
    func addStarfields() {
        let starTexture = SKTexture(imageNamed: "spark")
        
        // Emitter 1: Near field
        let nearEmitter = SKEmitterNode()
        nearEmitter.particleTexture = starTexture
        nearEmitter.particleBirthRate = 15
        nearEmitter.particleLifetime = 45
        nearEmitter.emissionAngle = CGFloat(90.0).degreesToRadians()
        nearEmitter.emissionAngleRange = CGFloat(360.0).degreesToRadians()
        nearEmitter.yAcceleration = -5
        nearEmitter.particleSpeed = 30
        nearEmitter.particleAlpha = 0.0
        nearEmitter.particleAlphaSpeed = 0.5
        nearEmitter.particleScale = 0.005
        nearEmitter.particleScaleRange = 0.0075
        nearEmitter.particleScaleSpeed = 0.01
        nearEmitter.particleColorBlendFactor = 1.0
        // clouds stars
        nearEmitter.particleColor = SKColor(red: 236/256, green: 240/256, blue: 241/256, alpha: 1.0)
        nearEmitter.position = CGPoint(x: frame.width / 2, y: frame.height * 1.75)
        nearEmitter.zPosition = -4
        nearEmitter.advanceSimulationTime(45)
        addChild(nearEmitter)
        
        // Emitter 2: Far field
        let farEmitter = SKEmitterNode()
        farEmitter.particleTexture = starTexture
        farEmitter.particleBirthRate = 10
        farEmitter.particleLifetime = 180
        farEmitter.emissionAngle = CGFloat(90.0).degreesToRadians()
        farEmitter.emissionAngleRange = CGFloat(360.0).degreesToRadians()
        farEmitter.yAcceleration = 0
        farEmitter.particleSpeed = 30
        farEmitter.particleAlpha = 0.0
        farEmitter.particleAlphaSpeed = 0.5
        farEmitter.particleScale = 0.0005
        farEmitter.particleScaleRange = 0.0005
        farEmitter.particleScaleSpeed = 0.005
        farEmitter.particleColorBlendFactor = 1.0
        // clouds stars
        farEmitter.particleColor = SKColor(red: 236/256, green: 240/256, blue: 241/256, alpha: 1.0)
        farEmitter.position = CGPoint(x: frame.width / 2, y: frame.height * 1.75)
        farEmitter.zPosition = -5
        farEmitter.advanceSimulationTime(180)
        addChild(farEmitter)
    }
    
}


// MARK: - CGFloat Extension

extension CGFloat {
    
    public func degreesToRadians() -> CGFloat {
        let π = CGFloat(M_PI)
        return π * self / 180.0
    }
    
}
