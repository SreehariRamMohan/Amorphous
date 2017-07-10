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
    
    //button variables for chapter 1 levels 1 - 5
    var button_level_1: MSButtonNode!
    var button_level_2: MSButtonNode!
    var button_level_3: MSButtonNode!
    var button_level_4: MSButtonNode!
    var button_level_5: MSButtonNode!
    
    //next chapter button variable
    var button_next_chapter: MSButtonNode!

    override func didMove(to view: SKView) {
        initializeButtons()
        setButtonCallbacks()
    }
    
    func loadGame(level: Int) {
    
    }
    
    func initializeButtons(){
        //making a code connection with the buttons
        
        back_to_forest_button = self.childNode(withName: "//back_to_forest_button") as! MSButtonNode
        
        button_next_chapter = self.childNode(withName: "//button_next_chapter") as! MSButtonNode
        
        button_level_1 = self.childNode(withName: "//button_level_1") as! MSButtonNode
        
        button_level_2 = self.childNode(withName: "//button_level_2") as! MSButtonNode
        
        button_level_2 = self.childNode(withName: "//button_level_2") as! MSButtonNode
        
        button_level_3 = self.childNode(withName: "//button_level_3") as! MSButtonNode
        
        button_level_4 = self.childNode(withName: "//button_level_4") as! MSButtonNode
        
        button_level_5 = self.childNode(withName: "//button_level_5") as! MSButtonNode
    }
    
    func setButtonCallbacks() {
        back_to_forest_button.selectedHandler = {
            self.load_forest()
        }
        
        button_level_1.selectedHandler = {
            //load level 1
            print("Going to level 1")
        }
        
        button_level_2.selectedHandler = {
            //load level 2
        }
        
        button_level_3.selectedHandler = {
            //load level 3
        }
        
        button_level_4.selectedHandler = {
            //load level 4
        }
        
        button_level_5.selectedHandler = {
            //load level 5
        }
        
        button_next_chapter.selectedHandler = {
            //load next chapter
        }
        
    }
    
    func load_forest(){
        /* Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* Load Game scene */
        guard let scene = Forest(fileNamed: "Forest") else {
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
