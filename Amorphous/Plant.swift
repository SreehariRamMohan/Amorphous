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
    
    var x: CGFloat!
    var y: CGFloat!
    var plant_type: Int!
    
    var date_last_watered: Date!
    
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
    
    init(type: Int, x_position: CGFloat, y_position: CGFloat, date_last_watered: Date) {
        //set a default texture for the tree so if something gets screwed up, the app won't crash on the user
        var texture = SKTexture(imageNamed: "tree_1")
        if(type == 1) {
            // Make a texture from an image, a color, and size
            texture = SKTexture(imageNamed: "tree_1")
        } else if(type == 2){
            texture = SKTexture(imageNamed: "tree_2")
        } else if(type == 3) {
            texture = SKTexture(imageNamed: "tree_3")
        } else if(type == 4) {
            texture = SKTexture(imageNamed: "tree_4")
        } else if(type == 5) {
            texture = SKTexture(imageNamed: "tree_5")
        } else if(type == 6) {
            texture = SKTexture(imageNamed: "tree_6")
        }
        let color = UIColor.clear
        let size = texture.size()
        
        self.x = x_position
        self.y = y_position
        self.plant_type = type
        self.date_last_watered = date_last_watered
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        self.position = CGPoint(x: self.x, y: self.y)
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //You can allow every obstacle of the sponge type to have a certain behavior every tick from here
        
    }
    
    func getX() -> CGFloat {
        return x
    }
    
    func getY() -> CGFloat {
        return y
    }
    
    func getPlantType() -> Int {
        return plant_type
    }
    
    func getLastWateredDate() -> Date {
        return date_last_watered
    }
    
    func setDateLastWatered(date: Date) {
        self.date_last_watered = date
    }
}
