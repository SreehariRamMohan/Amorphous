//
//  Sponge.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/11/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit


class Sponge: SKSpriteNode, SKPhysicsContactDelegate {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the sponge is created.
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class. 
        //You can allow every obstacle of the sponge type to have a certain behavior every tick from here
        
    }
    
    
    
    
}
