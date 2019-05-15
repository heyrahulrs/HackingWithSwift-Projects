//
//  GameScene.swift
//  Project11
//
//  Created by Rahul Sharma on 5/15/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var isEditing: Bool = false {
        didSet {
            if isEditing {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    var ballsLeftLabel: SKLabelNode!
    
    var ballsLeft = 5 {
        didSet {
            ballsLeftLabel.text = "Balls left: \(ballsLeft)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontName = "HelveticaNeue-Medium"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 900, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(text: "Edit")
        editLabel.fontName = "HelveticaNeue-Bold"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        ballsLeftLabel = SKLabelNode(text: "Balls left: 5")
        ballsLeftLabel.fontName = "HelveticaNeue-Medium"
        ballsLeftLabel.position = CGPoint(x: 650, y: 700)
        addChild(ballsLeftLabel)
        
        makeBouncer(atPosition: CGPoint(x: 0, y: 0))
        makeBouncer(atPosition: CGPoint(x: 256, y: 0))
        makeBouncer(atPosition: CGPoint(x: 512, y: 0))
        makeBouncer(atPosition: CGPoint(x: 768, y: 0))
        makeBouncer(atPosition: CGPoint(x: 1024, y: 0))
        
        makeSlot(atPosition: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(atPosition: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(atPosition: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(atPosition: CGPoint(x: 896, y: 0), isGood: false)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            isEditing.toggle()
        } else {
            
            if isEditing {
                
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
                
                let box = SKSpriteNode(color: color, size: size)
                box.position = location
                box.zRotation = CGFloat.random(in: 0...3.14)
                box.name = "box"
                
                box.physicsBody = SKPhysicsBody(rectangleOf: size)
                box.physicsBody?.isDynamic = false
                
                addChild(box)
                
            } else {
                
                guard ballsLeft > 0 else {
                    print("You have used all 5 of your available balls.")
                    return
                }
                
                guard location.y > 540 else {
                    print("You're tapping on the screen from too low. Tap near the top of the screen")
                    return
                }
                
                let balls = ["Red", "Blue", "Green", "Cyan", "Grey", "Purple", "Yellow"]
                let ball = SKSpriteNode(imageNamed: "ball" + balls.randomElement()!)
                ball.position = location
                ball.name = "ball"
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                addChild(ball)
                ballsLeft -= 1
                
            }
            
        }
        
    }
    
    func makeBouncer(atPosition position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(atPosition position: CGPoint, isGood: Bool) {
        let slotBase: SKSpriteNode
        let slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotBase.name = "good"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotBase.name = "bad"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotGlow.position = position
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let action = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(action)
        slotGlow.run(spinForever)
        
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        
        if object.name == "box" {
            score += 1
            destroy(object)
        }else if object.name == "good" {
            score += 1
            ballsLeft += 1
            destroy(ball)
        } else if object.name == "bad" {
            score -= 1
            destroy(ball)
        }
        
    }
    
    func destroy(_ object: SKNode) {
        if let particles = SKEmitterNode(fileNamed: "MyParticle") {
            particles.position = object.position
            addChild(particles)
        }
        object.removeFromParent()
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let bodyA = contact.bodyA.node else { return }
        guard let bodyB = contact.bodyB.node else { return }
        
        if bodyA.name == "ball" {
            collisionBetween(ball: bodyA, object: bodyB)
        } else if bodyB.name == "ball" {
            collisionBetween(ball: bodyB, object: bodyA)
        }
        
    }
    
}
