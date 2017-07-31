//
//  VerticalMovingPlatform.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/24/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class VerticalMovingPlatform: SKSpriteNode, SKPhysicsContactDelegate {
    var start_y_position: CGFloat!
    weak var parentRef: Level!
    var maxDeviation: CGFloat = 300.0
    var direction: CGFloat = 2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the V is created.
        
        let randomNumber = arc4random_uniform(100)
        if(randomNumber < 50) {
            direction = -1
        } else {
            direction = 1
        }
        print("Finished initializing the vertical moving platform")
        
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //You can allow every obstacle of the moving platform vertical type to have a certain behavior every tick from here
        self.position.y += self.direction
        
        if(parentRef.convert(self.position, from: self).y > start_y_position + self.maxDeviation || parentRef.convert(self.position, from: self).y < start_y_position - self.maxDeviation) {
            direction *= -1
        }
    }
    
    func passParentReference(parent: Level) {
        self.parentRef = parent
        print("Passed reference to platform")
        setOriginLocation()
    }
    
    func setOriginLocation() {
        start_y_position = parentRef.convert(CGPoint(x: 0, y: 0), from: self).y
        print(start_y_position)
    }
    
    
    
    
}
