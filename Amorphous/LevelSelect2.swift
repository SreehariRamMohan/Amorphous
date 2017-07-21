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
    
    //button variables for chapter 1 levels 1 - 5
    var button_level_6: MSButtonNode!
    var button_level_7: MSButtonNode!
    var button_level_8: MSButtonNode!
    var button_level_9: MSButtonNode!
    var button_level_10: MSButtonNode!
    var button_previous_chapter: MSButtonNode!
    var button_back_to_forest: MSButtonNode!
    
    override func didMove(to view: SKView) {
        print("here")
        initializeButtons()
        setButtonCallbacks()
    }
    
    override func initializeButtons(){
        //making a code connection with the buttons
        print("WHYYYYYYYYY 248209348203948230482-0348203842034209384234234")
        button_level_6 = self.childNode(withName: "//button_level_6") as! MSButtonNode
        
        button_level_7 = self.childNode(withName: "//button_level_7") as! MSButtonNode
        
        button_level_8 = self.childNode(withName: "//button_level_8") as! MSButtonNode
        
        button_level_9 = self.childNode(withName: "//button_level_9") as! MSButtonNode
        
        button_level_10 = self.childNode(withName: "//button_level_10") as! MSButtonNode
        
        button_previous_chapter = self.childNode(withName: "//button_previous_chapter") as! MSButtonNode
        
        button_back_to_forest = self.childNode(withName: "//back_to_forest_button") as! MSButtonNode
    }
    
    override func setButtonCallbacks() {
    
        button_back_to_forest.selectedHandler = {
            self.load_forest()
        }
        button_level_6.selectedHandler = {
            //load level 1
            LevelSelect.current_level = 6
            self.loadLevel(level: 6)
            print("Going to level 6")
        }
        
        button_level_7.selectedHandler = {
            //load level 2
            LevelSelect.current_level = 7
            self.loadLevel(level: 7)
            print("Going to level 7")
        }
        
        button_level_8.selectedHandler = {
            //load level 3
            LevelSelect.current_level = 8
            self.loadLevel(level: 8)
            print("Going to level 8")
        }
        
        button_level_9.selectedHandler = {
            //load level 4
            LevelSelect.current_level = 9
            self.loadLevel(level: 9)
            print("Going to level 9")
        }
        
        button_level_10.selectedHandler = {
            //load level 5
            LevelSelect.current_level = 10
            self.loadLevel(level: 10)
            print("Going to level 10")
        }
        
        button_previous_chapter.selectedHandler = {
            //go back one chapter
            self.current_chapter = 1
            print(self.current_chapter)
            self.loadLevelSelect(levelSelect: self.current_chapter)
        }
        
       
        
    }
}