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
    
    var star1: SKSpriteNode!
    var star2: SKSpriteNode!
    var star3: SKSpriteNode!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the LevelSelectStar is created.
    }
    
    func initializeStars() {
        star1 = self.childNode(withName: "star_1") as! SKSpriteNode
        star2 = self.childNode(withName: "star_2") as! SKSpriteNode
        star3 = self.childNode(withName: "star_3") as! SKSpriteNode
    }
    
    func set_1_star(){
        star1.isHidden = false
        star2.isHidden = true
        star3.isHidden = true
    }
    
    func set_2_star() {
        star1.isHidden = false
        star2.isHidden = false
        star3.isHidden = true
    }
    
    func set_3_star() {
        star1.isHidden = false
        star2.isHidden = false
        star3.isHidden = false
    }
    
    func set_no_stars() {
        star1.isHidden = true
        star2.isHidden = true
        star3.isHidden = true
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //You can allow every star of the LevelSelectStar type to have a certain behavior every tick from here
        
    }
}
