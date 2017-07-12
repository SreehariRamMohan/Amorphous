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
    static let ICE_COLLISION_BITMASK = 8
    static let ICE_CONTACT_BITMASK = 0
    static let ICE_CATEGORY_BITMASK = 2
    
    static let WATER_COLLISION_BITMASK = 64
    static let WATER_CONTACT_BITMASK = 0
    static let WATER_CATEGORY_BITMASK = 1
    
    static let GAS_COLLISION_BITMASK = 64 + CollisionManager.SPONGE_CATEGORY_BITMASK
    static let GAS_CONTACT_BITMASK = 0
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

    

}
