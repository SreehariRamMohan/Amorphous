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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the BuyPlants fragment is created.
        plants_button = self.childNode(withName: "plants_button") as! MSButtonNode
        
        bottles_button = self.childNode(withName: "button_bottles") as! MSButtonNode
        
        states_button = self.childNode(withName: "button_states") as! MSButtonNode
        
        setButtonCallbacks()
    }
    
    func update() {
        //This will be called at the beginning of every frame from the Forest class.
        //You can allow every obstacle of the sponge type to have a certain behavior every tick from here
        
    }
    
    func setButtonCallbacks() {
        plants_button.selectedHandler = {
            self.launchPickPlants()
            print("going to plants page")
        }
        
        bottles_button.selectedHandler = {
            print("Going to buy bottles page")
        }
        
        states_button.selectedHandler = {
            print("Going to buy a new state of matter")
        }
        
    }
    
    func launchPickPlants() {
        let path = Bundle.main.path(forResource: "PlantsPage", ofType: "sks")
        let fragment = SKReferenceNode(url: URL (fileURLWithPath: path!))
        fragment.position = CGPoint(x:0 , y:0)
        fragment.setScale(0.5)
        print(fragment)
        print(fragment.children[0].frame.size)
        addChild(fragment)
    }
    
    
    
    
}
