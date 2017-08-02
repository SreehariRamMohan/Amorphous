//
//  LevelSummary.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/19/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import GameplayKit

class LevelSummary: SKSpriteNode {

    var star1: SKNode!
    var star2: SKNode!
    var star3: SKNode!
    
    var label_3_star: SKLabelNode!
    var label_2_star: SKLabelNode!
    var label_1_star: SKLabelNode!
    
    var time_label: SKLabelNode!
    
    var button_retry: MSButtonNode!
    var button_onward: MSButtonNode!
    
    //Declared WEAK to prevent MEMORY LEAKS!
    weak var parentRef: Level!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.name = "LevelSummary"
    }
    
    func setup() {
        //initializing key variables
        initializeVariables()
        //set button callbacks
        setButtonCallbacks()
    }
    
    func setParentReference(parentReference: Level) {
        //sets the reference to the parent from the superclass
        self.parentRef = parentReference
        print("parent ref set")
    }
    
    func initializeVariables() {
        star1 = self.childNode(withName: "//star_1")
        star2 = self.childNode(withName: "//star_2")
        star3 = self.childNode(withName: "//star_3")
        
        label_3_star = self.childNode(withName: "//time_label_for3") as! SKLabelNode
        
        label_2_star = self.childNode(withName: "//time_label_for2") as! SKLabelNode
        
        label_1_star = self.childNode(withName: "//time_label_for1") as! SKLabelNode
        
        button_retry = self.childNode(withName: "//retry_button_image") as! MSButtonNode
        
        button_onward = self.childNode(withName: "//button_onward_image") as! MSButtonNode
        
        time_label = self.childNode(withName: "//time_label") as! SKLabelNode
    }
    
    func setButtonCallbacks() {
        button_retry.selectedHandler = {
            print("restarting level")
            
            //remove buttons from the screen to prevent buildup of buttons and memory leaks
            self.parentRef.removeButtons()
            
            guard let skView = self.parentRef.view as SKView! else{
                print("Could not get Skview")
                return
            }
            
            guard let scene = Level(fileNamed: "Level_" + String(LevelSelect.current_level)) else {
                return
            }
            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
        }
        
        button_onward.selectedHandler = {
            //insert code to go to the next level
            self.parentRef.gotToNextLevel()
        }
    }
    
    //function to set the amount of stars that show on screen
    func setStars(score: Int) {
        if(score == 3) {
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = false
            //set the number of stars the player received on this level
            Level.starsReceived[LevelSelect.current_level-1] = 3
        } else if(score == 2) {
            star1.isHidden = false
            star2.isHidden = false
            star3.isHidden = true
            //set the number of stars the player received on this level
            Level.starsReceived[LevelSelect.current_level-1] = 2
        } else if(score == 1) {
            star1.isHidden = false
            star2.isHidden = true
            star3.isHidden = true
            //set the number of stars the player received on this level
            Level.starsReceived[LevelSelect.current_level-1] = 1
        } else if(score == 0) {
            star1.isHidden = true
            star2.isHidden = true
            star3.isHidden = true
            //set the number of stars the player received on this level
            Level.starsReceived[LevelSelect.current_level-1] = 0
        }
    }
    //setters for the min time to get stars
    func set_3_star_time(time: Double) {
        self.label_3_star.text! += String(time)
    }
    
    func set_2_star_time(time: Double) {
        self.label_2_star.text! += String(time)
    }
    
    func set_1_star_time(time: Double) {
        self.label_1_star.text! += String(time)
    }
    
    func set_player_time(time: Double) {
        //format the counter time the player took to one decimal place
        self.time_label.text! += String(parentRef.counter.format(f: ".1"))
    }
    
    
    func populateWithInformation() {
        let score = parentRef.counter
        let levelSpecificGoal = parentRef.goals[LevelSelect.current_level-1]
        //set the times for different stars
        set_3_star_time(time: Double(levelSpecificGoal.0))
        set_2_star_time(time: Double(levelSpecificGoal.1))
        set_1_star_time(time: Double(levelSpecificGoal.2))
        //set the amount of stars shown
        if(score! <= Double(levelSpecificGoal.0)) {
            //player deserves 3 stars
            setStars(score: 3)
        } else if(score! < Double(levelSpecificGoal.1)) {
            //player deserves 2 stars
            setStars(score: 2)
        } else if(score! < Double(levelSpecificGoal.2)) {
            //player deserves 1 star
            setStars(score: 1)
        } else {
            //player deserves no stars
            setStars(score: 0)
        }
        //display the time the player took to complete the level
        set_player_time(time: parentRef.counter)
    }
    
}
