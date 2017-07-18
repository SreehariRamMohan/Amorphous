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
    var background_of_forest: SKNode!
    var effects_node: SKEffectNode!
    var button_x: MSButtonNode!
    var num_water_bottles: Int = 3
    var buy_fragment: SKReferenceNode!
    
    var forest_camera: SKCameraNode!
    
    //boolean values
    var canScroll: Bool = true
    
    //arrays
    var arrayOfBottles: [SKSpriteNode] = []
    
    
    override func didMove(to view: SKView) {
        initialize_buttons()
        button_action_callbacks()
        setDefaultButtonVisibilityState()
        
//Loop over all of the children recursively which contain the word water_bottle_ and only make the number of water bottles I have as visible
        var numBottlesShown = 0
        self.enumerateChildNodes(withName: "//*") {
            (node, stop) in
            
            if let name = node.name, name.contains("water_bottle_") {
                let bottle = node as! SKSpriteNode
                if(numBottlesShown < self.num_water_bottles) {
                    //making the bottle visible
                    bottle.isHidden = false
                } else {
                    //making the bottle invisible
                    bottle.isHidden = true
                }
                self.arrayOfBottles.append(bottle)
                numBottlesShown += 1
                
            }
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
        
        background_of_forest = self.childNode(withName: "//forest_background")
        
        button_x = self.childNode(withName: "//button_x") as! MSButtonNode
    }
    
    func button_action_callbacks() {
        plant_button.selectedHandler = {
            self.launchBuyFragment()
            print("planting plants")
        }
        
        water_plants_button.selectedHandler = {
            print("watering plants")
        }
        
        rescue_water_button.selectedHandler = {
            print("rescuing water")
            self.loadLevelSelect()
        }
        
        button_x.selectedHandler = {
            print("Exiting the fragment")
            self.destroyBuyFragment()
        }
    }
    
    func setDefaultButtonVisibilityState() {
        button_x.isHidden = true
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
    
    func showXButton() {
        button_x.isHidden = false
    }
    
    func hideXButton() {
        button_x.isHidden = true
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
        if(canScroll) {
            for touch in touches {
                let location = touch.location(in: self)
                let previousLocation = touch.previousLocation(in: self)
                let deltaX = previousLocation.x - location.x
                let deltaY = previousLocation.y - location.y
                let camPosX = forest_camera.position.x + 2*deltaX
                forest_camera.position.x = clamp(value: camPosX,lower: -220,upper: 220)
                let camPosY = forest_camera.position.y + 2*deltaY
                forest_camera.position.y = clamp(value: camPosY, lower: -300, upper: 300)
            }
        }
    }
    
    func launchBuyFragment() {
        let path = Bundle.main.path(forResource: "BuyPlants", ofType: "sks")
        let fragment = SKReferenceNode(url: URL (fileURLWithPath: path!))
        fragment.position = CGPoint(x: forest_camera.position.x , y: forest_camera.position.y)
        self.buy_fragment = fragment
        addChild(fragment)
        addBlurEffect()
        showXButton()
    }
    
    func destroyBuyFragment() {
        buy_fragment.removeAllChildren()
        buy_fragment.removeFromParent()
        hideXButton()
        removeBlurEffect()
        self.canScroll = true
    }
    
    func addBlurEffect() {
        // Create an effects node with a gaussian blur filter
        self.effects_node = SKEffectNode()
        let filter = CIFilter(name: "CIGaussianBlur")
        // Set the blur amount. Adjust this to achieve the desired effect
        let blurAmount = 10.0
        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        effects_node.filter = filter
        effects_node.position = self.view!.center
        effects_node.blendMode = .alpha
        
        
        // Add the sprite to the effects node. Nodes added to the effects node
        // will be blurred
        //remove the forest background as a child of the main view, so we can make it a child of the effects_node, this way it will have the blur effect
        self.background_of_forest.removeFromParent()
        self.plant_button.removeFromParent()
        self.water_plants_button.removeFromParent()
        self.rescue_water_button.removeFromParent()
        
        //Add the forest background, and the forest buttons as a child of the effect_node so they will have the blur effect applied to them
        self.effects_node.addChild(self.background_of_forest)
        self.effects_node.addChild(self.plant_button)
        self.effects_node.addChild(self.rescue_water_button)
        self.effects_node.addChild(self.water_plants_button)
        
        
        //Loop over all of the children recursively which have name water_bottle and blur all of them by adding them as children to the effect_node
        self.enumerateChildNodes(withName: "//water_bottle") {
            node, stop in
            let bottle = node as! SKSpriteNode
            bottle.isHidden = true
            bottle.removeFromParent()
            //self.effects_node.addChild(bottle)
        }
        
        
        // Add the effects node to the scene
        self.addChild((effects_node)!)
        
        //disable the user from scrolling around the screen while it is blurred
        self.canScroll = false
    }
    func removeBlurEffect() {
        //remove all of the buttons and backgrounds from the effects node
        self.effects_node.removeAllChildren()
        //add all of the backgrounds and the buttons we removed from the parent view, so they will be displayed back on the screen, after being removed from the
        self.addChild(self.background_of_forest)
        self.forest_camera.addChild(self.plant_button)
        self.forest_camera.addChild(self.rescue_water_button)
        self.forest_camera.addChild(self.water_plants_button)
        
        for i in 0..<self.num_water_bottles {
            //self.forest_camera.addChild(arrayOfBottles[i])
            if(i < self.num_water_bottles) {
                arrayOfBottles[i].isHidden = false
            } else {
                arrayOfBottles[i].isHidden = true
            }
        }
        
        effects_node.shouldEnableEffects = false
        
        //allow the user to pan around the screen again
        self.canScroll = false

    }

}
