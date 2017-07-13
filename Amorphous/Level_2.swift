//
//  Level_2.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/13/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit

class Level_2: Level {
    
    //player variable
    var player: Player!
    
    override func didMove(to view: SKView) {
        //call did move in parent
        super.didMove(to: view)
        initialize_variables()
    }
    
    
    func initialize_variables() {
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        print("reset the player")
        
        //add player to the world
        addChild(player)
    }
}
