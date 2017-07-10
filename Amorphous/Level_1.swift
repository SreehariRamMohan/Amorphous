//
//  Level_1.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/10/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit

class Level_1: Level {
    
    //button variables
    var button_back_to_level_select: MSButtonNode!
    
    //player variable
    var player: Player!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        initialize_variables()
        set_button_callbacks()
    }
    
    func initialize_variables() {
        button_back_to_level_select = self.childNode(withName: "button_back_to_level_select") as! MSButtonNode
        
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        //call didMove in Level
        
        //add player to the world
        addChild(player)
        
        
    }
    
    func set_button_callbacks() {
        button_back_to_level_select.selectedHandler = {
            self.loadLevelSelect()
        }
    }
    
    func loadLevelSelect() {
        /* Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* Load Game scene */
        guard let scene = LevelSelect(fileNamed: "LevelSelect") else {
            print("Could not go back and load level select")
            return
        }
        
        /* Ensure correct aspect mode */
        scene.scaleMode = .aspectFit
        
        /* Show debug */
        skView.showsPhysics = true
        skView.showsDrawCount = true
        skView.showsFPS = true
        
        /* Start game scene */
        skView.presentScene(scene)
    }
}
