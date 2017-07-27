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
    var button_level_6: MSButtonNode!
    var button_level_7: MSButtonNode!
    var button_level_8: MSButtonNode!
    var button_level_9: MSButtonNode!
    var button_level_10: MSButtonNode!
    
    var chapter_1_star_references: [SKReferenceNode] = []
    
    //next chapter button variable
    var button_next_chapter: MSButtonNode!
    
    static var current_level = 1
    var current_chapter: Int = 1
    
    override func didMove(to view: SKView) {
        initializeButtons()
        initializeStarReferences()
        setButtonCallbacks()
        
        //create a data manager so the stars can be loaded in the scene as soon as the level select is created!
        Level.dataManager = DataManager()
        for element in Level.dataManager.getScores() {
            Level.starsReceived.append(element.getScore())
        }
        //if this function is called when the user presses back, we need to update the star references to reflect the score the player got on each level.
        updateStarReferences()
        
        }
    
    func loadLevel(level: Int) {
        /* Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* Load Game scene */
        guard let scene = LevelSelect.level(level) else {
            print("Could not load GameScene with level " + String(level))
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
    
    func loadLevelSelect(levelSelect: Int) {
        /* Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        print("Scene values is " + String(levelSelect))
        
        
        if(levelSelect == 1) {
            print("In first if")
            /* Load Game scene */
            guard let scene = LevelSelect(fileNamed: "LevelSelect") else {
                print("Special Case broken")
                return
            }
            /* Ensure correct aspect mode */
            scene.scaleMode = .aspectFit
            print(scene)
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            print("Got here")
            
            /* Start game scene */
            skView.presentScene(scene)
        } else {
            print("In else block")
            /* Load Game scene */
            guard let scene = LevelSelect.levelselect(current_chapter) else {
                print("Could not load levelselect # " + String(current_chapter))
                return
            }
            /* Ensure correct aspect mode */
            scene.scaleMode = .aspectFit
            print(scene)
            /* Show debug */
            skView.showsPhysics = true
            skView.showsDrawCount = true
            skView.showsFPS = true
            print("Got here")
            
            /* Start game scene */
            skView.presentScene(scene)
        }
        
      
        
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
        
        button_level_6 = self.childNode(withName: "//button_level_6") as! MSButtonNode

        button_level_7 = self.childNode(withName: "//button_level_7") as! MSButtonNode

        button_level_8 = self.childNode(withName: "//button_level_8") as! MSButtonNode

        button_level_9 = self.childNode(withName: "//button_level_9") as! MSButtonNode
        
        button_level_10 = self.childNode(withName: "//button_level_10") as! MSButtonNode
        
    }
    
    func initializeStarReferences() {
        for i in 0..<10 {
            chapter_1_star_references.append(self.childNode(withName: "stars_level_\(i + 1)") as! SKReferenceNode)
            var star_object = chapter_1_star_references[i].childNode(withName: ".//star_background") as! LevelSelectStars
            star_object.initializeStars()
            //initialize the game where all of the star objects have no stars. Since the player has not defeated any of the levels yet.
            star_object.set_no_stars()
        }
    }
    
    func updateStarReferences() {
        print("__________Updating stars____________")
        for i in 0..<10 {
            chapter_1_star_references.append(self.childNode(withName: "stars_level_\(i + 1)") as! SKReferenceNode)
            var star_object = chapter_1_star_references[i].childNode(withName: ".//star_background") as! LevelSelectStars
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
    
    func setButtonCallbacks() {
        back_to_forest_button.selectedHandler = {
            self.load_forest()
        }
        
        button_level_1.selectedHandler = {
            //load level 1
            LevelSelect.current_level = 1
            self.loadLevel(level: 1)
            print("Going to level 1")
        }
        
        button_level_2.selectedHandler = {
            //load level 2
            LevelSelect.current_level = 2
            self.loadLevel(level: 2)
            print("Going to level 2")
        }
        
        button_level_3.selectedHandler = {
            //load level 3
            LevelSelect.current_level = 3
            self.loadLevel(level: 3)
            print("Going to level 3")
        }
        
        button_level_4.selectedHandler = {
            //load level 4
            LevelSelect.current_level = 4
            self.loadLevel(level: 4)
            print("Going to level 4")
        }
        
        button_level_5.selectedHandler = {
            //load level 5
            LevelSelect.current_level = 5
            self.loadLevel(level: 5)
            print("Going to level 5")
        }
        
        button_level_6.selectedHandler = {
            //load level 6
            LevelSelect.current_level = 6
            self.loadLevel(level: 6)
            print("Going to level 6")
        }
        
        button_level_7.selectedHandler = {
            //load level 7
            LevelSelect.current_level = 7
            self.loadLevel(level: 7)
            print("Going to level 7")
        }
        
        button_level_8.selectedHandler = {
            //load level 8
            LevelSelect.current_level = 8
            self.loadLevel(level: 8)
            print("Going to level 8")
        }
        
        button_level_9.selectedHandler = {
            //load level 9
            LevelSelect.current_level = 9
            self.loadLevel(level: 9)
            print("Going to level 9")
        }
        
        button_level_10.selectedHandler = {
            //load level 10
            LevelSelect.current_level = 10
            self.loadLevel(level: 10)
            print("Going to level 10")
        }
        
        button_next_chapter.selectedHandler =
            {
            //load next chapter
            self.current_chapter = 2
            self.loadLevelSelect(levelSelect: self.current_chapter)
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
    
    /* Make a Class method to load levels */
    class func level(_ levelNumber: Int) -> Level? {
        guard let scene = Level(fileNamed: "Level_\(levelNumber)") else {
            return nil
        }
        scene.scaleMode = .aspectFit
        return scene
    }
    
    /* Make a Class method to load level select menus */
    class func levelselect(_ levelNumber: Int) -> LevelSelect? {
        guard let scene = LevelSelect(fileNamed: "LevelSelect\(levelNumber)") else {
            return nil
        }
        scene.scaleMode = .aspectFit
        return scene
    }
    
}
