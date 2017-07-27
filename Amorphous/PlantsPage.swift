//
//  PlantsPage.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/18/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import Foundation
import SpriteKit
import GameplayKit

class PlantsPage: SKSpriteNode {
    
    var option_1_button: MSButtonNode!
    var option_2_button: MSButtonNode!
    var option_3_button: MSButtonNode!
    var option_4_button: MSButtonNode!
    var option_5_button: MSButtonNode!
    var option_6_button: MSButtonNode!
    
    var forestReference: Forest!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //this will be called when the PlantPage fragment is created.
        
        print("Created a plant page with stuff in it")
        
    }
    
    func initializeBuyPlantsButtons() {
        print("I am starting to initialize")
        option_1_button = self.childNode(withName: "//option_1") as! MSButtonNode
        option_2_button = self.childNode(withName: "//option_2") as! MSButtonNode
        option_3_button = self.childNode(withName: "//option_3") as! MSButtonNode
        option_4_button = self.childNode(withName: "//option_4") as! MSButtonNode
        option_5_button = self.childNode(withName: "//option_5") as! MSButtonNode
        option_6_button = self.childNode(withName: "//option_6") as! MSButtonNode
    }
    
    func setOptionButtonCallbacks() {
        option_1_button.selectedHandler = {
            print("Option button 1 pressed")
            self.forestReference.startPlantingProcess()
            //remove the buying screen after we have decided which plant we want to buy
            self.forestReference.destroyBuyFragment()
        }
        
        option_2_button.selectedHandler = {
            print("Option button 2 pressed")
        }
        
        option_3_button.selectedHandler = {
            print("Option button 3 pressed")
        }
        
        option_4_button.selectedHandler = {
            print("Option button 4 pressed")
        }
        
        option_5_button.selectedHandler = {
            print("Option button 5 pressed")
        }
        
        option_6_button.selectedHandler = {
            print("Option button 6 pressed")
        }
    }
    
    func setForestReference(ref: SKScene) {
        self.forestReference = ref as! Forest
        print("Got the forest reference !")
        print(self.forestReference)
    }
}
