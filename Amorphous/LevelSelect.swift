//
//  LevelSelect.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/10/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//
import Foundation
import SpriteKit
class LevelSelect: SKScene {
    
    //create variables for UI elements
    var back_to_forest_button: MSButtonNode!
    
    override func didMove(to view: SKView) {
        initializeButtons()
        setButtonCallbacks()
    }
    
    func loadGame(level: Int) {
    
    }
    
    func initializeButtons(){
        back_to_forest_button = self.childNode(withName: "//back_to_forest_button") as! MSButtonNode
    }
    
    func setButtonCallbacks() {
        back_to_forest_button.selectedHandler = {
            self.load_forest()
        }
    }
    
    func load_forest(){
        /* Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* Load Game scene */
        guard let scene = GameScene(fileNamed: "Forest") else {
            print("Could not load Forest")
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
