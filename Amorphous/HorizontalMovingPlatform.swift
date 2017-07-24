//
//  HorizontalMovingPlatform.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/24/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class HorizontalMovingPlatform: SKSpriteNode, SKPhysicsContactDelegate {
    var start_x_position: CGFloat!
    var parentRef: Level!
    var maxDeviation: CGFloat = 300.0
    var direction: CGFloat = 2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the HorizontalMovingPlatform is created.
        
        let randomNumber = arc4random_uniform(100)
        if(randomNumber < 50) {
            direction = -1
        } else {
            direction = 1
        }
    
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //You can allow every obstacle of the moving platform horizontal type to have a certain behavior every tick from here
        self.position.x += self.direction
        
        if(parentRef.convert(self.position, from: self).x > start_x_position + self.maxDeviation || parentRef.convert(self.position, from: self).x < start_x_position - self.maxDeviation) {
            direction *= -1
        }
    }
    
    func passParentReference(parent: Level) {
        self.parentRef = parent
        print("Passed reference to platform")
        setOriginLocation()
    }
    
    func setOriginLocation() {
        start_x_position = parentRef.convert(CGPoint(x: 0, y: 0), from: self).x
        print(start_x_position)
    }
    
    
    
    
}
