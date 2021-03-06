//
//  GameScene.swift
//  Space Defender
//
//  Created by Dulio Denis on 5/1/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation


class GameScene: SKScene {
    
    let spaceship = SKSpriteNode(imageNamed: "rocket")
    // to keep track of the drag
    var moveableNode: SKNode?
    // to keep track of the spaceship original position
    var spaceshipStartX: CGFloat = 0.0
    var spaceshipStartY: CGFloat = 0.0
    
    let shootButton = SKSpriteNode(imageNamed: "shootButton")
    let laserBeamSound = SKAction.playSoundFileNamed("laserBeamSound.mp3", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosionSound.mp3", waitForCompletion: false)
    
    let engineExhaust = SKEmitterNode(fileNamed: "engineExhaust.sks")
    
    // keep track of collisions
    var spaceshipHit = false
    var isPlaying = true
    
    // life tracking
    var lives = 3
    let livesLabel = SKLabelNode(fontNamed: "Menlo")
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    
    override func didMove(to view: SKView) {
        // midnight blue background
        backgroundColor = SKColor(red: 44/256, green: 62/256, blue: 80/256, alpha: 1.0)
        
        // background music
        playBackgroundMusic()
        
        // Set-up the Lives Label
        livesLabel.text = "Lives: \(lives)"
        // Cloud Font Color
        livesLabel.fontColor = SKColor(red: 236/256, green: 240/256, blue: 241/256, alpha: 1.0)
        livesLabel.fontSize = 75
        livesLabel.zPosition = 10
        livesLabel.horizontalAlignmentMode = .center
        livesLabel.verticalAlignmentMode = .center
        livesLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(livesLabel)
        
        // position, scale and anchor the spaceship
        spaceship.position = CGPoint(x: size.width * 0.2, y: size.height * 0.2)
        spaceship.setScale(0.4)
        spaceship.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        spaceship.zPosition = 5
        spaceship.name = "spaceship"
        addChild(spaceship)
        
        // add exhaust to rocket
        engineExhaust?.position = CGPoint(x: 0.0, y: -(spaceship.size.height) * 1.3)
        engineExhaust?.setScale(3)
        spaceship.addChild(engineExhaust!)
        
        // animateSpaceship()
        
        // position, scale, and anchor the shoot button
        shootButton.position = CGPoint(x: size.width * 0.80, y: size.height * 0.15)
        shootButton.setScale(0.2)
        shootButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shootButton.zPosition = 10
        shootButton.name = "shootButton"
        addChild(shootButton)
        
        addStarfields()
        
        // spawn some aliens
        let wait = SKAction.wait(forDuration: 2.0)
        let constantSpawn = SKAction.run { self.spawnInvader() }
        let spawnSequence = SKAction.sequence([wait, constantSpawn])
        run(SKAction.repeatForever(spawnSequence))
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
        livesLabel.text = "Lives: \(lives)"
    }
    
    
    override func didEvaluateActions() {
        checkForCollisions()
    }
    
    
    func checkForCollisions() {
        // did the invader collide with the rocket?
        enumerateChildNodes(withName: "invader") { node, _ in
            let invader = node as! SKSpriteNode
            
            // if the two boundaries of this invader and the spaceship are touching
            if invader.frame.intersects(self.spaceship.frame) {
                // check to see that this is the first time hit
                if self.spaceshipHit == false {
                    self.spaceshipHitByInvader()
                } else if self.spaceshipHit == true {
                    // otherwise its already been hit - and return
                    return
                }
            }
        }
        
        // TODO: - Laser/Invader Collision Detection
    }
    
    
    // MARK: - Spaceship and Invader Animation
    
    func animateSpaceship() {
        let rightMovement = SKAction.moveTo(x: size.width * 0.80, duration: 2.5)
        let leftMovement = SKAction.moveTo(x: size.width * 0.20, duration: 2.5)
        
        let sequence = SKAction.sequence([rightMovement, leftMovement])
        let animation = SKAction.repeatForever(sequence)
        
        spaceship.run(animation)
    }
    
    
    func spawnInvader() {
        // scale, position, and name the alien invader
        let invader = SKSpriteNode(imageNamed: "ufo_scarlet")
        invader.setScale(0.30)
        invader.zPosition = 7
        invader.name = "invader"
        invader.position = CGPoint(
            x: CGFloat.random(min: -200, max: size.width + 200),
            y: size.height + 200)
        addChild(invader)
        
        // add a wobble effect
        let leftRotation = SKAction.rotate(byAngle: 3.14 / 8.0, duration: 0.5)
        let rightRotation = leftRotation.reversed()
        let fullRotation = SKAction.sequence([leftRotation, rightRotation])
        invader.run(SKAction.repeatForever(fullRotation))
        
        // animate the invader from off screen randomly towards the rocket
        let destination = CGPoint(
            x: CGFloat.random(min: 0, max: size.width),
            y: -200) // off screen
        let invaderMove = SKAction.move(to: destination, duration: 4)
        let invaderRemove = SKAction.removeFromParent()
        
        // set the animation sequence
        let animation = SKAction.sequence([invaderMove, invaderRemove])
        invader.run(animation)
    }
    
    
    func spaceshipHitByInvader() {
        spaceshipHit = true
        
        // during invincibility have a blink animation
        let blinkTimes = 15.0   // blinks
        let duration = 3.0      // seconds
        
        let blinkAction = SKAction.customAction(withDuration: duration) { node, elapsedTime in
            // smooth intervals
            let slice = duration / blinkTimes
            let remainder = Double(elapsedTime).truncatingRemainder(dividingBy: slice)
            // set to hide
            node.isHidden = remainder > slice / 2
        }
        
        let setHiddenAction = SKAction.run() { [weak self] in
            self?.spaceship.isHidden = false
            self?.spaceshipHit = false
        }
        
        spaceship.run(SKAction.sequence([blinkAction, setHiddenAction]))
        
        // explosion sound
        run(explosionSound)
        
        // decrement one life
        lives -= 1
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
    
    
    // MARK: - Background Music
    
    func playBackgroundMusic() {
        do {
            let path = Bundle.main.path(forResource: "spaceDefenderBackgroundMusic", ofType: "mp3")
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            backgroundMusicPlayer.volume = 0.7
            backgroundMusicPlayer.numberOfLoops = -1 // loop forever
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch {
            print("Error loading audio for background music.")
        }
    }
    
}


// MARK: - CGFloat Extensions

extension CGFloat {
    
    public func degreesToRadians() -> CGFloat {
        let π = CGFloat(M_PI)
        return π * self / 180.0
    }
    
    
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    
    static func random(min minimum: CGFloat, max maximum: CGFloat) -> CGFloat {
        assert(minimum < maximum)
        return CGFloat.random() * (maximum - minimum) + minimum
    }
    
}
