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
    let IMPULSE_MAGNITUDE: CGFloat = 100
    let JUMP_MAGNITUDE: CGFloat = 100
    var currentLevel: Int!
    
    //friction values for the main character
    var WATER_DROPLET_FRICTION_VALUE: CGFloat
        = 0.7
    var GAS_FRICTION_VALUE: CGFloat = 0
    var ICE_CUBE_FRICTION_VALUE: CGFloat = 0.5
    var PLASMA_FRICTION_VALUE: CGFloat! //not decided yet
    
    //Bitmask Constants for the Player
    let ICE_COLLISION_BITMASK = 1
    let ICE_CONTACT_BITMASK = 0
    let ICE_CATEGORY_BITMASK = 2
    
    let WATER_COLLISION_BITMASK = 1
    let WATER_CONTACT_BITMASK = 0
    let WATER_CATEGORY_BITMASK = 1
    
    let GAS_COLLISION_BITMASK = 1
    let GAS_CONTACT_BITMASK = 0
    let GAS_CATEGORY_BITMASK = 4
    
    init() {
        // Make a texture from an image, a color, and size
        let texture = SKTexture(imageNamed: "water_droplet_image")
        let color = UIColor.clear
        let size = texture.size()
        
        // Call the designated initializer
        super.init(texture: texture, color: color, size: size)
        
        // Set physics properties
        self.physicsBody = SKPhysicsBody(texture: self.texture!,
                                           size: self.texture!.size())
        
        physicsBody?.mass = 0.5
        
        //turn off the gravity for now
        physicsBody?.affectedByGravity = true
        
        //set the default current state which is a liquid
        currentState = .liquid
        
        //set the current level to 1
        currentLevel = 1
        
        //set the friction according to the current state which is a water droplet
        self.physicsBody?.friction = WATER_DROPLET_FRICTION_VALUE
        
        self.physicsBody?.friction = WATER_DROPLET_FRICTION_VALUE
        self.physicsBody?.categoryBitMask = UInt32(WATER_CATEGORY_BITMASK)
        self.physicsBody?.contactTestBitMask = UInt32(WATER_CONTACT_BITMASK)
        self.physicsBody?.collisionBitMask = UInt32(WATER_COLLISION_BITMASK)
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
            //reset the physics body to fit the shape of the new texture
            self.physicsBody = SKPhysicsBody(texture: self.texture!,
                                             size: self.texture!.size())
            self.physicsBody?.friction = ICE_CUBE_FRICTION_VALUE
            self.physicsBody?.categoryBitMask = UInt32(ICE_CATEGORY_BITMASK)
            self.physicsBody?.contactTestBitMask = UInt32(ICE_CONTACT_BITMASK)
            self.physicsBody?.collisionBitMask = UInt32(ICE_COLLISION_BITMASK)
        } else if(currentState.rawValue == 2) {
            //change to liquid state
            self.texture = SKTexture(imageNamed:"water_droplet_image")
            //reset the physics body to fit the shape of the new texture
            self.physicsBody = SKPhysicsBody(texture: self.texture!,
                                             size: self.texture!.size())
            self.physicsBody?.friction = WATER_DROPLET_FRICTION_VALUE
            self.physicsBody?.categoryBitMask = UInt32(WATER_CATEGORY_BITMASK)
            self.physicsBody?.contactTestBitMask = UInt32(WATER_CONTACT_BITMASK)
            self.physicsBody?.collisionBitMask = UInt32(WATER_COLLISION_BITMASK)
        } else if(currentState.rawValue == 3) {
            //change to gas state
            self.texture = SKTexture(imageNamed:"water_vapor_image")
            //reset the physics body to fit the shape of the new texture
            self.physicsBody = SKPhysicsBody(texture: self.texture!,
                                             size: self.texture!.size())
            self.physicsBody?.friction = GAS_FRICTION_VALUE
            self.physicsBody?.categoryBitMask = UInt32(GAS_CATEGORY_BITMASK)
            self.physicsBody?.contactTestBitMask = UInt32(GAS_CONTACT_BITMASK)
            self.physicsBody?.collisionBitMask = UInt32(GAS_COLLISION_BITMASK)
        } else if(currentState.rawValue == 0) {
            //change to plasma state
        }
    }
    
    func applyRightImpulse() {
        self.physicsBody?.applyImpulse(CGVector(dx: IMPULSE_MAGNITUDE, dy: 0))
    }
    
    func applyLeftImpulse() {
        self.physicsBody?.applyImpulse(CGVector(dx: -1*IMPULSE_MAGNITUDE, dy: 0))

    }
    
    func getCurrentLevel() -> Int {
        return currentLevel
    }
    
    func setCurrentLevel(level: Int) {
        self.currentLevel = level
    }
    
    func update() {
        //This update method is called from Level superclass before each frame is rendered.
        if(currentState == State.gas) {
            float()
        }
    }
    
    func float() {
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 9.9))
    }
    
    func jump() {
        if(currentState == State.solid) {
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: JUMP_MAGNITUDE))
        }
    }
}
