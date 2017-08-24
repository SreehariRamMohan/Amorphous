//
//  CollisionManager.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/11/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

//This class handles all of the constants that deal with Bitmasks for CollisionManager
//It has static getter for all of the Bitmasks for easy accessible. 
//All of the information about the bitmasks should be done here.

import Foundation

class CollisionManager {
    //Bitmask Constants for the Player
    static let ICE_COLLISION_BITMASK = 8 + CollisionManager.SPIKE_CATEGORY_BITMASK + CollisionManager.FAN_CATEGORY_BITMASK + CollisionManager.OIL_RIGHT_CATEGORY_BITMASK + CollisionManager.OIL_LEFT_CATEGORY_BITMASK + CollisionManager.FALLING_BLOCK_CATEGORY_BITMASK
    static let ICE_CONTACT_BITMASK = 0 + CollisionManager.FAN_CATEGORY_BITMASK + CollisionManager.FALLING_BLOCK_CATEGORY_BITMASK + CollisionManager.FLAME_CATEGORY_BITMASK
    static let ICE_CATEGORY_BITMASK = 2
    
    static let WATER_COLLISION_BITMASK = 64 + CollisionManager.OIL_RIGHT_CATEGORY_BITMASK + CollisionManager.OIL_LEFT_CATEGORY_BITMASK
    static let WATER_CONTACT_BITMASK = 0 + CollisionManager.FLAME_CATEGORY_BITMASK
    static let WATER_CATEGORY_BITMASK = 1
    
    static let GAS_COLLISION_BITMASK = 64 + CollisionManager.SPONGE_CATEGORY_BITMASK + CollisionManager.FAN_CATEGORY_BITMASK
    static let GAS_CONTACT_BITMASK = 0 + CollisionManager.FAN_CATEGORY_BITMASK
    static let GAS_CATEGORY_BITMASK = 4
    
    //friction values for the main character
    static let WATER_DROPLET_FRICTION_VALUE = 0.7
    static let GAS_FRICTION_VALUE = 0
    static let ICE_CUBE_FRICTION_VALUE = 0.5
    
    //Sponge Bitmask Constants
    static let SPONGE_CATEGORY_BITMASK = 8
    static let SPONGE_COLLISION_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.GAS_CATEGORY_BITMASK
    static let SPONGE_CONTACT_BITMASK = 1
    
    //Window Bitmask Constants
    static let WINDOW_CATEGORY_BITMASK = 64
    static let WINDOW_COLLISION_BITMASK = 5
    static let WINDOW_CONTACT_BITMASK = 2
    
    //Spike Bitmask Constants
    static let SPIKE_CATEGORY_BITMASK = 128
    static let SPIKE_COLLISION_BITMASK = 2
    static let SPIKE_CONTACT_BITMASK = 2
    
    //Fan Bitmask Constants
    static let FAN_CATEGORY_BITMASK = 256
    static let FAN_COLLISION_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.GAS_CATEGORY_BITMASK
    static let FAN_CONTACT_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.GAS_CATEGORY_BITMASK
    
    //Oil Right Bitmask Constants
    static let OIL_RIGHT_CATEGORY_BITMASK = 512
    static let OIL_RIGHT_COLLISION_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.WATER_CATEGORY_BITMASK
    static let OIL_RIGHT_CONTACT_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.WATER_CATEGORY_BITMASK
    static let OIL_RIGHT_IMPULSE_FORCE = 100
    
    //Oil Left Bitmask Constants
    static let OIL_LEFT_CATEGORY_BITMASK = 1024
    static let OIL_LEFT_COLLISION_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.WATER_CATEGORY_BITMASK
    static let OIL_LEFT_CONTACT_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.WATER_CATEGORY_BITMASK
    static let OIL_LEFT_IMPULSE_FORCE = -100
    
    //Water Bitmask Constants
    static let WATER_POOL_CATEGORY_BITMASK = 2048
    static let WATER_POOL_COLLISION_BITMASK = 0
    static let WATER_POOL_CONTACT_BITMASK = CollisionManager.WATER_CATEGORY_BITMASK + CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.GAS_CATEGORY_BITMASK

    //Falling Block Bitmask Constants
    static let FALLING_BLOCK_CATEGORY_BITMASK = 4096
    static let FALLING_BLOCK_CONTACT_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK
    static let FALLING_BLOCK_COLLISION_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK

    //Flame Bitmask Contants
    static let FLAME_CATEGORY_BITMASK = 8192
    static let FLAME_COLLISION_BITMASK = 0
    static let FLAME_CONTACT_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.WATER_CATEGORY_BITMASK
    
    //Gravity Down Bitmask Constants
    static let GRAVITY_CATEGORY_BITMASK = 16384
    static let GRAVITY_COLLISION_BITMASK = 0
    static let GRAVITY_CONTACT_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.WATER_CONTACT_BITMASK + CollisionManager.GAS_CATEGORY_BITMASK
    
    //Gravity Up Bitmask Constants
    static let ANTI_GRAVITY_CATEGORY_BITMASK = 32768
    static let ANTI_GRAVITY_COLLISION_BITMASK = 0
    static let ANTI_GRAVITY_CONTACT_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK + CollisionManager.WATER_CONTACT_BITMASK + CollisionManager.GAS_CATEGORY_BITMASK
    
    
    

}

