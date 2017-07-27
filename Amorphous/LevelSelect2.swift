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
    var button_next_chapter2: MSButtonNode!
    var button_level_11: MSButtonNode!
    var button_level_12: MSButtonNode!
    var button_level_13: MSButtonNode!
    var button_level_14: MSButtonNode!
    var button_level_15: MSButtonNode!
    var button_level_16: MSButtonNode!
    var button_level_17: MSButtonNode!
    var button_level_18: MSButtonNode!
    var button_level_19: MSButtonNode!
    var button_level_20: MSButtonNode!
    
    var chapter_2_star_references: [SKReferenceNode] = []
    

    override func didMove(to view: SKView) {
        print("here")
        initializeButtons()
        setButtonCallbacks()
        initializeStarReferences()
        
        //create a data manager so the stars can be loaded in the scene as soon as the level select is created!
        Level.dataManager = DataManager()
        for element in Level.dataManager.getScores() {
            Level.starsReceived.append(element.getScore())
        }
        //if this function is called when the user presses back, we need to update the star references to reflect the score the player got on each level.
        updateStarReferences()

    }
    
    override func initializeButtons(){
        //making a code connection with the buttons
        
        button_previous_chapter = self.childNode(withName: "//button_previous_chapter") as! MSButtonNode
        
        button_back_to_forest = self.childNode(withName: "//back_to_forest_button") as! MSButtonNode
        
        button_next_chapter2 = self.childNode(withName: "//button_next_chapter") as! MSButtonNode
        
        button_level_11 = self.childNode(withName: "//button_level_11") as! MSButtonNode
        
        button_level_12 = self.childNode(withName: "//button_level_12") as! MSButtonNode
        
        button_level_13 = self.childNode(withName: "//button_level_13") as! MSButtonNode
        
        button_level_14 = self.childNode(withName: "//button_level_14") as! MSButtonNode
        
        button_level_15 = self.childNode(withName: "//button_level_15") as! MSButtonNode
        
        button_level_16 = self.childNode(withName: "//button_level_16") as! MSButtonNode
        
        button_level_17 = self.childNode(withName: "//button_level_17") as! MSButtonNode
        
        button_level_18 = self.childNode(withName: "//button_level_18") as! MSButtonNode
        
        button_level_19 = self.childNode(withName: "//button_level_19") as! MSButtonNode
        
        button_level_20 = self.childNode(withName: "//button_level_20") as! MSButtonNode

    }
    
    override func initializeStarReferences() {
        for i in 10..<20 {
            chapter_2_star_references.append(self.childNode(withName: "stars_level_\(i + 1)") as! SKReferenceNode)
            var star_object = chapter_2_star_references[i-10].childNode(withName: ".//star_background") as! LevelSelectStars
            star_object.initializeStars()
            //initialize the game where all of the star objects have no stars. Since the player has not defeated any of the levels yet.
            star_object.set_no_stars()
        }
    }
    
    override func updateStarReferences() {
        print("__________Updating stars____________")
        for i in 10..<20 {
            chapter_2_star_references.append(self.childNode(withName: "stars_level_\(i + 1)") as! SKReferenceNode)
            var star_object = chapter_2_star_references[i-10].childNode(withName: ".//star_background") as! LevelSelectStars
            star_object.initializeStars()
            //set the stars on the screen to the stars that the player has earned. These stars will be present in the array.
            if(i <= Level.starsReceived.count) {
                let stars_received_on_level_i = Level.starsReceived[i]
                print(stars_received_on_level_i)
                if(stars_received_on_level_i == 0) {
                    star_object.set_no_stars()
                } else if(stars_received_on_level_i == 1) {
                    star_object.set_1_star()
                } else if(stars_received_on_level_i == 2) {
                    star_object.set_2_star()
                } else if(stars_received_on_level_i == 3) {
                    star_object.set_3_star()
                }
            } else {
                print("Couldn't update")
            }
        }
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
      
        
        button_next_chapter2.selectedHandler = {
                //load next chapter
                self.current_chapter = 3
                self.loadLevelSelect(levelSelect: self.current_chapter)
        }
        
        button_level_11.selectedHandler = {
            //load level 11
            LevelSelect.current_level = 11
            self.loadLevel(level: 11)
            print("Going to level 11")
        }
        
        button_level_12.selectedHandler = {
            //load level 12
            LevelSelect.current_level = 12
            self.loadLevel(level: 12)
            print("Going to level 12")
        }
        
        button_level_13.selectedHandler = {
            //load level 13
            LevelSelect.current_level = 13
            self.loadLevel(level: 13)
            print("Going to level 13")
        }
        
        button_level_14.selectedHandler = {
            //load level 14
            LevelSelect.current_level = 14
            self.loadLevel(level: 14)
            print("Going to level 14")
        }
        
        button_level_15.selectedHandler = {
            //load level 15
            LevelSelect.current_level = 15
            self.loadLevel(level: 15)
            print("Going to level 15")
        }
        
        button_level_16.selectedHandler = {
            //load level 16
            LevelSelect.current_level = 16
            self.loadLevel(level: 16)
            print("Going to level 16")
        }
        
        button_level_17.selectedHandler = {
            //load level 17
            LevelSelect.current_level = 17
            self.loadLevel(level: 17)
            print("Going to level 17")
        }
        
        button_level_18.selectedHandler = {
            //load level 18
            LevelSelect.current_level = 18
            self.loadLevel(level: 18)
            print("Going to level 18")
        }
        
        button_level_19.selectedHandler = {
            //load level 19
            LevelSelect.current_level = 19
            self.loadLevel(level: 19)
            print("Going to level 19")
        }
        
        button_level_20.selectedHandler = {
            //load level 20
            LevelSelect.current_level = 20
            self.loadLevel(level: 20)
            print("Going to level 20")
        }
    }
}
