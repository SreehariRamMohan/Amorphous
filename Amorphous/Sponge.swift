//
//  Sponge.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/11/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//


//LINKING THE .SKS FILE TO THE SPONGE
import Foundation
import SpriteKit
import GameplayKit


class Sponge: SKSpriteNode, SKPhysicsContactDelegate {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("Init")
        
        
        
        
    }
    
    func sayHi() {
        print("hi yo soy un sponge")
    }
    
    
    
    
}
