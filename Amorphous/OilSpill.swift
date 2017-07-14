//
//  OilSpill.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/14/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit


class OilSpill: SKSpriteNode, SKPhysicsContactDelegate {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the OilSpill is created.
        self.physicsBody?.friction = 0
        print("Oil spill friction set to 0")
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //You can allow every obstacle of the sponge type to have a certain behavior every tick from here
        
    }
    
    
    
    
    
    
}
