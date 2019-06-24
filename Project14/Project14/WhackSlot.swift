//
//  WhackSlot.swift
//  Project14
//
//  Created by Ben Oveson on 6/24/19.
//  Copyright © 2019 Ben Oveson. All rights reserved.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    var isVisable = false
    var isHit = false
    
    var charNode: SKSpriteNode!

    func configure(at position: CGPoint) {
        self.position = position
        
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
        
        
    }
    
    func show(hideTime: Double) {
        if isVisable { return }
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisable = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hideTime * 3.5) { [weak self] in
            self?.hide()
        }
        
    }
    
    func hide() {
        if !isVisable { return }
        
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisable = false
    }
    
    func hit() {
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisable = SKAction.run { [weak self] in self?.isVisable = false }
        
        let sequence = SKAction.sequence([delay, hide, notVisable])
        charNode.run(sequence)
    }

}
