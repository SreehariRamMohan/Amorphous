//
//  Forest.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/10/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import SpriteKit
import GameplayKit

class Forest: SKScene {
    
    //create button variables
    var plant_button: MSButtonNode!
    var water_plants_button: MSButtonNode!
    var rescue_water_button: MSButtonNode!
    
     var num_water_bottles: Int = 3
    
    var forest_camera: SKCameraNode!
    
    
    override func didMove(to view: SKView) {
        initialize_buttons()
        button_action_callbacks()
        
        //Loop over all of the children recursively which have name water_bottle and only make the number of water bottles I have as visible
        var numBottlesShown = 0
        self.enumerateChildNodes(withName: "//water_bottle") {
            node, stop in
            let bottle = node as! SKSpriteNode
            // setting the bottle to be visible
            if(numBottlesShown < self.num_water_bottles) {
                //bottle.isHidden = false
                
                
            } else {
                bottle.isHidden = true
            }
            
            numBottlesShown += 1
        }
        
        forest_camera = self.childNode(withName: "forest_camera_node") as! SKCameraNode
        self.camera = forest_camera
    
        }

    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func initialize_buttons() {
        water_plants_button = self.childNode(withName: "//water_image") as! MSButtonNode
        
        plant_button = self.childNode(withName: "//plant_image") as! MSButtonNode
        
        rescue_water_button = self.childNode(withName: "//rescue_water_image") as! MSButtonNode
    }
    
    func button_action_callbacks() {
        plant_button.selectedHandler = {
            print("planting plants")
        }
        
        water_plants_button.selectedHandler = {
            print("watering plants")
        }
        
        rescue_water_button.selectedHandler = {
            print("rescuing water")
            self.loadLevelSelect()
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func loadLevelSelect() {
        /* Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* Load Game scene */
        guard let scene = LevelSelect(fileNamed: "LevelSelect") else {
            print("Could not load Forest with level 1")
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            let deltaX = previousLocation.x - location.x
            let deltaY = previousLocation.y - location.y
            
            print("here")
            
            let camPosX = forest_camera.position.x + 2*deltaX
            forest_camera.position.x = clamp(value: camPosX,lower: -220,upper: 220)
            let camPosY = forest_camera.position.y + 2*deltaY
            forest_camera.position.y = clamp(value: camPosY, lower: -300, upper: 300)
            
            
        }
    }

}
