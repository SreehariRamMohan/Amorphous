//
//  LevelSelect3.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/26/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
class LevelSelect3: LevelSelect {
    
    //button variables for chapter 2 levels
    var button_previous_chapter: MSButtonNode!
    var button_back_to_forest: MSButtonNode!
    var button_level_21: MSButtonNode!
    var button_level_22: MSButtonNode!
    var button_level_23: MSButtonNode!
    var button_level_24: MSButtonNode!
    var button_level_25: MSButtonNode!
    
    
    override func didMove(to view: SKView) {
        print("here")
        initializeButtons()
        setButtonCallbacks()
    }
    
    override func initializeButtons(){
        //making a code connection with the buttons
        
        button_previous_chapter = self.childNode(withName: "//button_previous_chapter") as! MSButtonNode
        
        button_back_to_forest = self.childNode(withName: "//back_to_forest_button") as! MSButtonNode
        
        button_level_21 = self.childNode(withName: "//button_level_21") as! MSButtonNode
        
        button_level_22 = self.childNode(withName: "//button_level_22") as! MSButtonNode
        
        button_level_23 = self.childNode(withName: "//button_level_23") as! MSButtonNode
        
        button_level_24 = self.childNode(withName: "//button_level_24") as! MSButtonNode
        
        button_level_25 = self.childNode(withName: "//button_level_25") as! MSButtonNode
    }
    
    override func setButtonCallbacks() {
        
        button_back_to_forest.selectedHandler = {
            self.load_forest()
        }
        
        button_previous_chapter.selectedHandler = {
            //go back one chapter
            self.current_chapter = 2
            print(self.current_chapter)
            self.loadLevelSelect(levelSelect: self.current_chapter)
        }
        
        button_level_21.selectedHandler = {
            //go to level 21
            LevelSelect.current_level = 21
            self.loadLevel(level: 21)
        }
        
        button_level_22.selectedHandler = {
            //go to level 22
            LevelSelect.current_level = 22
            self.loadLevel(level: 22)
        }
        
        button_level_23.selectedHandler = {
            //go to level 23
            LevelSelect.current_level = 23
            self.loadLevel(level: 23)
        }
        
        button_level_24.selectedHandler = {
            //go to level 24
            LevelSelect.current_level = 24
            self.loadLevel(level: 24)
        }
        
        button_level_25.selectedHandler = {
            //go to level 25
            LevelSelect.current_level = 25
            self.loadLevel(level: 25)
        }
    }
}
