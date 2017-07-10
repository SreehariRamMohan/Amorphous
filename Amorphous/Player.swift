//
//  Player.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/10/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    
    enum State: Int {
        case solid = 1, liquid = 2, gas = 3, plasma = 0
    }
    
    var currentState: State!
    
    init() {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: "water_droplet_image")
        let color = UIColor.clear
        let size = texture.size()
        
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        
        // Set physics properties
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        physicsBody?.categoryBitMask = 1
        physicsBody?.friction = 0.6
        physicsBody?.mass = 0.5
        
        
        //turn off the gravity for now
        physicsBody?.affectedByGravity = false
        
        currentState = .liquid
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCurrentState() -> Int{
        return currentState.rawValue
    }
    
    func changeState() {
        var currentRaw: Int = self.currentState.rawValue
        currentRaw += 1
        if(currentRaw > 3){
            currentRaw = 1
        }
        self.currentState = State(rawValue: currentRaw)
        self.updateState()
    }
    
    func updateState() {
        if(currentState.rawValue == 1) {
            //change to solid state
            self.texture = SKTexture(imageNamed:"ice_cube_image")
        } else if(currentState.rawValue == 2) {
            //change to liquid state
            self.texture = SKTexture(imageNamed:"water_droplet_image")
        } else if(currentState.rawValue == 3) {
            //change to gas state
            self.texture = SKTexture(imageNamed:"water_vapor_image")
        } else if(currentState.rawValue == 0) {
            //change to plasma state
        }
    }

}