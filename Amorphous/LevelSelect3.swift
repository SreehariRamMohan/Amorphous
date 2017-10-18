//
//  LevelSelect3.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/26/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
import AudioToolbox
import AVFoundation

class LevelSelect3: LevelSelect {
    
    //button variables for chapter 2 levels
    var button_previous_chapter: MSButtonNode!
    var button_back_to_forest: MSButtonNode!
    var button_level_21: MSButtonNode!
    var button_level_22: MSButtonNode!
    var button_level_23: MSButtonNode!
    var button_level_24: MSButtonNode!
    var button_level_25: MSButtonNode!
    var button_level_26: MSButtonNode!
    var button_level_27: MSButtonNode!
    var button_level_28: MSButtonNode!
    
    var chapter_3_star_references: [SKReferenceNode] = []
    
    
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
        
        //play the backgorund music
        playSound()
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
        
        button_level_26 = self.childNode(withName: "//button_level_26") as! MSButtonNode
        
        button_level_27 = self.childNode(withName: "//button_level_27") as! MSButtonNode
        
        button_level_28 = self.childNode(withName: "//button_level_28") as! MSButtonNode
    }
    
    override func initializeStarReferences() {
        for i in 20..<27 { //27 represents the upper limit for the number of level's shown on the screen
            chapter_3_star_references.append(self.childNode(withName: "stars_level_\(i + 1)") as! SKReferenceNode)
            var star_object = chapter_3_star_references[i-20].childNode(withName: ".//star_background") as! LevelSelectStars
            star_object.initializeStars()
            //initialize the game where all of the star objects have no stars. Since the player has not defeated any of the levels yet.
            star_object.set_no_stars()
        }
    }
    
    override func updateStarReferences() {
        for i in 20..<27 { //27 represents the upper limit for the number of level's shown on the screen
            chapter_3_star_references.append(self.childNode(withName: "stars_level_\(i + 1)") as! SKReferenceNode)
            var star_object = chapter_3_star_references[i-20].childNode(withName: ".//star_background") as! LevelSelectStars
            star_object.initializeStars()
            //set the stars on the screen to the stars that the player has earned. These stars will be present in the array.
            if(i <= Level.starsReceived.count) {
                let stars_received_on_level_i = Level.starsReceived[i]
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
        
        button_back_to_forest.selectedHandler = { [weak self] in
            self?.load_forest()
        }
        
        button_previous_chapter.selectedHandler = { [weak self] in
            //go back one chapter
            LevelSelect.current_chapter = 2
            print(LevelSelect.current_chapter)
            self?.loadLevelSelect(levelSelect: LevelSelect.current_chapter)
        }
        
        button_level_21.selectedHandler = { [weak self] in
            //go to level 21
            LevelSelect.current_level = 21
            self?.loadLevel(level: 21)
        }
        
        button_level_22.selectedHandler = { [weak self] in
            //go to level 22
            LevelSelect.current_level = 22
            self?.loadLevel(level: 22)
        }
        
        button_level_23.selectedHandler = { [weak self] in
            //go to level 23
            LevelSelect.current_level = 23
            self?.loadLevel(level: 23)
        }
        
        button_level_24.selectedHandler = { [weak self] in
            //go to level 24
            LevelSelect.current_level = 24
            self?.loadLevel(level: 24)
        }
        
        button_level_25.selectedHandler = { [weak self] in
            //go to level 25
            LevelSelect.current_level = 25
            self?.loadLevel(level: 25)
        }
        
        button_level_26.selectedHandler = { [weak self] in
            //go to level 26
            LevelSelect.current_level = 26
            self?.loadLevel(level: 26)
            
        }
        
        button_level_27.selectedHandler = { [weak self] in
            //go to level 27
            LevelSelect.current_level = 27
            self?.loadLevel(level: 27)
        }
        
        button_level_28.selectedHandler = { [weak self] in
            //go to level 28
            LevelSelect.current_level = 28
            self?.loadLevel(level: 28)
        }
    }
    
    override func playSound() {
        let url = Bundle.main.url(forResource: "Level_Select_Chapter_3", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            //makes sure that the player continues to loop over the sound once the song finishes so the music never stops.
            player.numberOfLoops = -1
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
}
