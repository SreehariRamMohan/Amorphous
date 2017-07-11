//
//  Window.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/11/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit


class Window: SKSpriteNode, SKPhysicsContactDelegate {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the window is created.
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //give the window some behavior here??
        
    }
    
    
    
    
}
