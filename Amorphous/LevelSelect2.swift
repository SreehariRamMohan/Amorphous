//
//  LevelSelect2.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/18/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//
import Foundation
import SpriteKit
class LevelSelect2: LevelSelect {
    
    //button variables for chapter 2 levels 
    var button_previous_chapter: MSButtonNode!
    var button_back_to_forest: MSButtonNode!
    var button_level_21: MSButtonNode!
    
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
    }
    
    override func setButtonCallbacks() {
    
        button_back_to_forest.selectedHandler = {
            self.load_forest()
        }
        
        button_previous_chapter.selectedHandler = {
            //go back one chapter
            self.current_chapter = 1
            print(self.current_chapter)
            self.loadLevelSelect(levelSelect: self.current_chapter)
        }
        
        button_level_21.selectedHandler = {
            //go to level 21
            LevelSelect.current_level = 21
            self.loadLevel(level: 21)
        }
        
       
        
    }
}
