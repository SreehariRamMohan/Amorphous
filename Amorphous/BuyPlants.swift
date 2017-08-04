//
//  BuyPlants.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/18/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit

class BuyPlants: SKSpriteNode, SKPhysicsContactDelegate {
    var plants_button: MSButtonNode!
    var bottles_button: MSButtonNode!
    var states_button: MSButtonNode!
    var water_plants_button: MSButtonNode!
    var button_credits: MSButtonNode!
    weak var parentRef: Forest!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the BuyPlants fragment is created.
        plants_button = self.childNode(withName: "//plants_button") as! MSButtonNode
        
        water_plants_button = self.childNode(withName: "//water_plants") as! MSButtonNode
        
        button_credits = self.childNode(withName: "//button_credits") as! MSButtonNode
        
        
        //These buttons will come soon in a future update!
        //bottles_button = self.childNode(withName: "button_bottles") as! MSButtonNode
        
        //states_button = self.childNode(withName: "button_states") as! MSButtonNode
        
        setButtonCallbacks()
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Forest class.
        //You can allow every obstacle of the sponge type to have a certain behavior every tick from here
        
    }
    
    func setButtonCallbacks() {
        plants_button.selectedHandler = { [weak self] in
            self?.launchPickPlants()
        }
        
        water_plants_button.selectedHandler = { [weak self] in
            //start the watering process in the forest class
            self?.parentRef.initiateWaterProcess()
            //destroy the buy fragment to let the user tap a plant to water it
            self?.parentRef.destroyBuyFragment()
        }
        
        button_credits.selectedHandler = { [weak self] in
            self?.launchCreditsScreen()
        }
        
//        bottles_button.selectedHandler = { [weak self] in
//            print("Going to buy bottles page")
//        }
//        
//        states_button.selectedHandler = { [weak self] in
//            print("Going to buy a new state of matter")
//        }
        
    }
    
    func launchPickPlants() {
        let path = Bundle.main.path(forResource: "PlantsPage", ofType: "sks")
        let fragment = SKReferenceNode(url: URL (fileURLWithPath: path!))
        fragment.position = CGPoint(x:0 , y:0)
        fragment.setScale(0.5)
        let plantsPage = fragment.childNode(withName: "//PlantsPage") as! PlantsPage
        plantsPage.setForestReference(ref: parentRef)
        plantsPage.initializeBuyPlantsButtons()
        plantsPage.setOptionButtonCallbacks()
        addChild(fragment)
    }
    
    func setParentReference(ref: SKScene) {
        self.parentRef = ref as! Forest
    }
    
    func launchCreditsScreen() {
        let skView = self.parentRef.view as SKView!
        guard let scene = Credits(fileNamed:"Credits") as Credits! else { return }
        scene.scaleMode = .aspectFill
        skView?.presentScene(scene)
    }
    
    deinit {
        
        
    }
}
