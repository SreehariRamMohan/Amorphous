//
//  Hammer.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/19/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class FallingBlock: SKSpriteNode, SKPhysicsContactDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the falling block is created.
        self.physicsBody?.mass = 1
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //You can allow every obstacle of the sponge type to have a certain behavior every tick from here
    }
    
    func fall() {
       //called when the block should fall from the ceiling
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -500))
    }
    
    func rise() {
        //call when the block should rise back to the top
    }
    
    func getX() -> CGFloat {
        return self.position.x
    }
    
    func getY() -> CGFloat {
        return self.position.y
    }
}
