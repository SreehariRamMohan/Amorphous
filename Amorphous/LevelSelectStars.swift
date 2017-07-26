//
//  LevelStar.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/26/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
class LevelSelectStars: SKSpriteNode, SKPhysicsContactDelegate {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the LevelSelectStar is created.
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //You can allow every star of the LevelSelectStar type to have a certain behavior every tick from here
        
    }
    
    
    
    
}
