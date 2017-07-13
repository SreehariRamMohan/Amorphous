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
        print("did move of level 2")
        
    }
    
    
    func initialize_variables() {
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        print("reset the player")
        print("in level 2")
        
        //add player to the world
        addChild(player)
    }
    
    override func updateCamera() {
        if(currentPlayer != nil && currentPlayer?.position != nil) {
            
            let y = clamp(value: currentPlayer.position.y, lower: 20, upper: 6*UIScreen.main.bounds.height)
            
            var x = currentPlayer.position.x
            if( LevelSelect.current_level == 1) {
                //clamp with level 1 dimensions in mind
                x = clamp(value: currentPlayer.position.x, lower: 0 , upper: 5*(UIScreen.main.bounds.width/2) + 165)
                
            } else {
                //add other if statements here to customize for the other levels
                x = currentPlayer.position.x
            }
            cameraNode.position.x = x
            cameraNode.position.y = y
        }
    }
    
}
