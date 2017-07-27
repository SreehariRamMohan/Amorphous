//
//  Plant.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/27/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Plant: SKSpriteNode {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the sponge is created.
    }
    
    init() {
    // Make a texture from an image, a color, and size
    let texture = SKTexture(imageNamed: "tree_1")
    let color = UIColor.clear
    let size = texture.size()
    
    // Call the designated initializer
    super.init(texture: texture, color: color, size: size)
    
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //You can allow every obstacle of the sponge type to have a certain behavior every tick from here
        
    }
    
    
    
    
}
