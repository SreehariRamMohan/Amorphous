//
//  Water.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/15/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit


class Water: SKSpriteNode, SKPhysicsContactDelegate {
    
    var currentPlayer: SKSpriteNode!
    var width: CGFloat = 400
    var height: CGFloat = 400
    var x: CGFloat!
    var y: CGFloat!
    
    //MARK: Factors
    static let VISCOSITY: CGFloat = 6 //Increase to make the water "thicker/stickier," creating more friction.
    static let BUOYANCY: CGFloat = 0.4 //Slightly increase to make the object "float up faster," more buoyant.
    static let OFFSET: CGFloat = 70 //Increase to make the object float to the surface higher.
    //MARK: -
    var water: SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the Water is created.
        print("Water created")
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Level class.
        //You can allow every obstacle of the sponge type to have a certain behavior every tick from here
    }

}

