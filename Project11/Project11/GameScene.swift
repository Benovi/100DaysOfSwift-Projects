//
//  GameScene.swift
//  Project11
//
//  Created by Ben Oveson on 6/3/19.
//  Copyright © 2019 Ben Oveson. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var scoreLbl: SKLabelNode!
    var gameOverLbl: SKLabelNode!
    var ballCount = 1
    var obsticals = 0
    
    var score = 0 {
        didSet {
            scoreLbl?.text = "Score: \(score)"
        }
    }
    
    var editLbl: SKLabelNode!
    
    var editMode: Bool = false {
        didSet {
            if editMode {
                editLbl.text = "Done"
            } else {
                editLbl.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let backGround = SKSpriteNode(imageNamed: "background")
        backGround.position = CGPoint(x: 512, y: 384)
        backGround.blendMode = .replace
        backGround.zPosition = -1
        addChild(backGround)
        
        scoreLbl = SKLabelNode(fontNamed: "Chalkduster")
        scoreLbl.text = "Score: 0"
        scoreLbl.horizontalAlignmentMode = .right
        scoreLbl.position = CGPoint(x: frame.size.width - 50, y: frame.size.height - 50)
        addChild(scoreLbl)
        
        editLbl = SKLabelNode(fontNamed: "Chalkduster")
        editLbl.text = "Edit"
        editLbl.horizontalAlignmentMode = .right
        editLbl.position = CGPoint(x: 100, y: frame.size.height - 50)
        addChild(editLbl)

        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let locationTouch = touch.location(in: self)
        
        let objects = nodes(at: locationTouch)
        
        if objects.contains(editLbl) {
            
            editMode.toggle()
           
        } else {
            if editMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let obstical = SKSpriteNode(color: UIColor.init(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                obstical.zRotation = CGFloat.random(in: 0...3)
                obstical.physicsBody = SKPhysicsBody(rectangleOf: obstical.size)
                obstical.physicsBody?.restitution = 0.2
                obstical.physicsBody?.isDynamic = false
                obstical.position = locationTouch
                obstical.name = "obstical"
                obsticals += 1
                addChild(obstical)
            } else {
                if ballCount <= 5 {
                    ballCount += 1
                    let ball = SKSpriteNode(imageNamed: "ballRed")
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
                    ball.physicsBody?.restitution = 0.5
                    ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                    ball.position = CGPoint(x: locationTouch.x, y: frame.size.height - 50)
                    ball.name = "ball"
                    addChild(ball)
                } else {
                    gameOverLbl = SKLabelNode(fontNamed: "Chalkduster")
                    gameOverLbl.text = "Game Over"
                    gameOverLbl.horizontalAlignmentMode = .center
                    gameOverLbl.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
                    addChild(gameOverLbl)
                    goToGameScene()
                }
                
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.restitution = 0.6
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name  = "bad"
        }
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotBase.position = position
        addChild(slotBase)
        slotGlow.position = position
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    
    }
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
            
        } else if object.name == "obstical" {
            destroy(ball: object)
            obsticals -= 1
            if obsticals == 0 {
                
                gameOverLbl = SKLabelNode(fontNamed: "Chalkduster")
                gameOverLbl.text = "Nice Job!"
                gameOverLbl.horizontalAlignmentMode = .center
                gameOverLbl.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
                addChild(gameOverLbl)
                goToGameScene()
            }
        }
    }
    
    func goToGameScene(){
        let gameScene:GameScene = GameScene(size: self.view!.bounds.size)
        let transition = SKTransition.fade(withDuration: 5.0)
        gameScene.scaleMode = SKSceneScaleMode.fill
        self.view!.presentScene(gameScene, transition: transition)
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
            
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
    }
    
}
