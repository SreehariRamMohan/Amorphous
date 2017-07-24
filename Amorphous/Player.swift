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
    let IMPULSE_MAGNITUDE: CGFloat = 70
    let JUMP_MAGNITUDE: CGFloat = 90
    var currentLevel: Int!
    var mass: CGFloat = 1
    
    //friction values for the main character
    var WATER_DROPLET_FRICTION_VALUE: CGFloat
        = 0.7
    var GAS_FRICTION_VALUE: CGFloat = 0
    var ICE_CUBE_FRICTION_VALUE: CGFloat = 0.3
    var PLASMA_FRICTION_VALUE: CGFloat! //not decided yet
    
    //Bitmask Constants for the Player
    let ICE_COLLISION_BITMASK = CollisionManager.ICE_COLLISION_BITMASK
    let ICE_CONTACT_BITMASK = CollisionManager.ICE_CONTACT_BITMASK
    let ICE_CATEGORY_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK
    
    let WATER_COLLISION_BITMASK = CollisionManager.WATER_COLLISION_BITMASK
    let WATER_CONTACT_BITMASK = CollisionManager.WATER_CONTACT_BITMASK
    let WATER_CATEGORY_BITMASK = CollisionManager.WATER_CATEGORY_BITMASK
    
    let GAS_COLLISION_BITMASK = CollisionManager.GAS_COLLISION_BITMASK
    let GAS_CONTACT_BITMASK = CollisionManager.GAS_CONTACT_BITMASK
    let GAS_CATEGORY_BITMASK = CollisionManager.GAS_CATEGORY_BITMASK
    
    //constraints on player state
    let MAX_JUMPS: Int = 1
    var currentJumps: Int = 0
    var timeSinceLastJump: Double = 0
    var timeAsGas: Double = 0
    var preventLagWhenSwitching: Bool = false
    
    
    
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
        
        physicsBody?.mass = mass
        
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
        
        //set our z position to 2 so we are in front of everything else
        self.zPosition = 2
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
    
    func changeState(rawValue: Int) {
        self.currentState = State(rawValue: rawValue)
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
            
            /* Create a CLOSURE to safely keep the ice cube the same scale as the shrunken down water droplet */
            let scalePhysicsBody = SKAction.run({
                /* Scale the currentPlayer.physics body in the scene */
                //reset the physics body after scaling main character down
                let currSize = self.texture!.size()
                let currXSize = currSize.width * self.xScale
                let currYSize = currSize.height * self.yScale
                let newSize: CGSize = CGSize(width: currXSize, height: currYSize)
                self.physicsBody = SKPhysicsBody(texture: self.texture!,size: newSize)
                
                //reset the bitmasks for the player
                self.physicsBody?.friction = CGFloat(CollisionManager.ICE_CUBE_FRICTION_VALUE)
                self.physicsBody?.categoryBitMask = UInt32(self.ICE_CATEGORY_BITMASK)
                self.physicsBody?.contactTestBitMask = UInt32(self.ICE_CONTACT_BITMASK)
                self.physicsBody?.collisionBitMask = UInt32(self.ICE_COLLISION_BITMASK)
                
                //make sure that body is set to dynamic
                self.physicsBody?.isDynamic = true
            })
            self.run(scalePhysicsBody)
            //set mass of player to last mass value
            physicsBody?.mass = self.mass

        } else if(currentState.rawValue == 2) {
            //change to liquid state
            self.texture = SKTexture(imageNamed:"water_droplet_image")
            /* Create a CLOSURE to safely keep the water droplet the same scale as the shrunken down water droplet after player changes state after decreasing scale */
            let scalePhysicsBody = SKAction.run({
                /* Scale the currentPlayer.physics body in the scene */
                //reset the physics body after scaling main character down
                let currSize = self.texture!.size()
                let currXSize = currSize.width * self.xScale
                let currYSize = currSize.height * self.yScale
                let newSize: CGSize = CGSize(width: currXSize, height: currYSize)
                self.physicsBody = SKPhysicsBody(texture: self.texture!,size: newSize)
                
                //reset the bitmasks for the player
                self.physicsBody?.friction = CGFloat(CollisionManager.WATER_DROPLET_FRICTION_VALUE)
                self.physicsBody?.categoryBitMask = UInt32(self.WATER_CATEGORY_BITMASK)
                self.physicsBody?.contactTestBitMask = UInt32(self.WATER_CONTACT_BITMASK)
                self.physicsBody?.collisionBitMask = UInt32(self.WATER_COLLISION_BITMASK)
                
                //make sure that body is set to dynamic
                self.physicsBody?.isDynamic = true
                })
            self.run(scalePhysicsBody)
            //set mass of player to last mass value
            physicsBody?.mass = self.mass

        } else if(currentState.rawValue == 3) {
            //change to gas state
            self.texture = SKTexture(imageNamed:"water_vapor_image")
            
            //reset the physics body to fit the shape of the new texture
            
            /* Create a CLOSURE to safely keep the gas the same scale as the shrunken down water droplet */
            let scalePhysicsBody = SKAction.run({
                /* Scale the currentPlayer.physics body in the scene */
                //reset the physics body after scaling main character down
                let currSize = self.texture!.size()
                let currXSize = currSize.width * self.xScale
                let currYSize = currSize.height * self.yScale
                let newSize: CGSize = CGSize(width: currXSize, height: currYSize)
                self.physicsBody = SKPhysicsBody(texture: self.texture!,size: newSize)
                
                //reset the bitmasks for the player
                self.physicsBody?.friction = CGFloat(CollisionManager.GAS_FRICTION_VALUE)
                self.physicsBody?.categoryBitMask = UInt32(CollisionManager.GAS_CATEGORY_BITMASK)
                self.physicsBody?.contactTestBitMask = UInt32(CollisionManager.GAS_CONTACT_BITMASK)
                self.physicsBody?.collisionBitMask = UInt32(CollisionManager.GAS_COLLISION_BITMASK)
                
                //make sure that body is set to dynamic
                self.physicsBody?.isDynamic = true
                
                //record the starting time when we become gas so we can implement a cooldown later
                self.timeAsGas = CFAbsoluteTimeGetCurrent()
            })
            self.run(scalePhysicsBody)
            //set mass of player to last mass value
            physicsBody?.mass = self.mass

        } else if(currentState.rawValue == 0) {
            //change to plasma state
        }
    }
    
    func applyRightImpulse() {
        self.physicsBody?.applyImpulse(CGVector(dx: IMPULSE_MAGNITUDE*getMass(), dy: 0))
        //multiply by getMass() so that we don't move too fast if our mass has been reduced
    }
    
    func applyLeftImpulse() {
        self.physicsBody?.applyImpulse(CGVector(dx: -1*IMPULSE_MAGNITUDE*getMass(), dy: 0))
        //multiply by getMass() so that we don't move too fast if our mass has been reduced

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
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 9.8*sqrt(getMass())))
        
        //The line below can tend to cause some lag
        if(self.preventLagWhenSwitching && (CFAbsoluteTimeGetCurrent() - self.timeAsGas) > 2){
            //if the player has been in the gas state for more than 2 seconds then automatically change them to a water droplet.
            changeState(rawValue: 2)
            return
        } else {
            self.preventLagWhenSwitching = true
        }
        
        
    }
    
    func jump() {
        //prevent double jumping
        if(self.currentJumps > 0 && CFAbsoluteTimeGetCurrent() - self.timeSinceLastJump < 0.7) {
            print(CFAbsoluteTimeGetCurrent() - self.timeSinceLastJump)
            return
        } else {
            if(self.currentJumps > 1) {
                self.currentJumps = 0
            }
        }
        if(currentState == State.solid) {
            if(self.currentJumps == 0) {
                self.timeSinceLastJump = CFAbsoluteTimeGetCurrent()
            }
            //acutally perform the jump dependent on the player mass
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: JUMP_MAGNITUDE*sqrt(getMass())))
            //increment the amount of jumps the player has taken in a row
            self.currentJumps += 1

        }
    }
    
    func getMass() -> CGFloat {
        if(self.physicsBody != nil) {
            //return (self.physicsBody?.mass)!
            return self.mass
        } else {
            print("returning default of 1 for mass")
            //no player has been found, this is usually due to this method being called right after the restart button has been pressed. Return a default value of 1
            return 1
        }
    }
    
    func setMass(mass:CGFloat) {
        self.mass = mass
        self.physicsBody?.mass = self.mass
    }
    
    func getTimeAsGas() -> Double {
        return self.timeAsGas
    }
}
