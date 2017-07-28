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
    
    var not_enough_water_label: SKNode!
    var balance_label: SKLabelNode!
    let cost_for_option_1: Int = 3
    let cost_for_option_2: Int = 5
    let cost_for_option_3: Int = 7
    let cost_for_option_4: Int = 8
    let cost_for_option_5: Int = 9
    let cost_for_option_6: Int = 10
    
    var assigned = false
    
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
        not_enough_water_label = self.childNode(withName: "//not_enough_water_label")!
        balance_label = self.childNode(withName: "//balance_label") as! SKLabelNode
        
        //hide the notification that the user doesn't have enough $ untilt they make an ilicit purchase.
        not_enough_water_label.isHidden = true
        balance_label.text! += String(Forest.num_water_bottles) + " water in bank"
        balance_label.isHidden = true
    }
    
    func setOptionButtonCallbacks() {
        option_1_button.selectedHandler = {
            print("Option button 1 pressed")
            
            if(Forest.num_water_bottles < self.cost_for_option_1) {
                self.not_enough_water_label.isHidden = false
                self.balance_label.isHidden = false
            } else {
                self.forestReference.startPlantingProcess(type: 1)
                
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                Forest.num_water_bottles -= self.cost_for_option_1
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
                
                
                //BELOW NOT WORKING WILL FIX
                self.forestReference.forestDataManager.addBottleData(numBottles: Forest.num_water_bottles)

            }
            

        }
        
        option_2_button.selectedHandler = {
            print("Option button 2 pressed")
            
            if(Forest.num_water_bottles < self.cost_for_option_2) {
                self.not_enough_water_label.isHidden = false
                self.balance_label.isHidden = false
            } else {
                self.forestReference.startPlantingProcess(type: 2)
                
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                Forest.num_water_bottles -= self.cost_for_option_2
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
            }
        }
        
        option_3_button.selectedHandler = {
            print("Option button 3 pressed")
            if(Forest.num_water_bottles < self.cost_for_option_3) {
                self.not_enough_water_label.isHidden = false
                self.balance_label.isHidden = false
            } else {
                self.forestReference.startPlantingProcess(type: 3)
                
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                Forest.num_water_bottles -= self.cost_for_option_3
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
            }
        }
        
        option_4_button.selectedHandler = {
            print("Option button 4 pressed")
            if(Forest.num_water_bottles < self.cost_for_option_4) {
                self.not_enough_water_label.isHidden = false
                self.balance_label.isHidden = false
            } else {
                self.forestReference.startPlantingProcess(type: 4)
                
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                Forest.num_water_bottles -= self.cost_for_option_4
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
            }
        }
        
        option_5_button.selectedHandler = {
            print("Option button 5 pressed")
            if(Forest.num_water_bottles < self.cost_for_option_5) {
                self.not_enough_water_label.isHidden = false
                self.balance_label.isHidden = false
            } else {
                self.forestReference.startPlantingProcess(type: 5)
                
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                Forest.num_water_bottles -= self.cost_for_option_5
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
            }
        }
        
        option_6_button.selectedHandler = {
            print("Option button 6 pressed")
            if(Forest.num_water_bottles < self.cost_for_option_6) {
                self.not_enough_water_label.isHidden = false
                self.balance_label.isHidden = false
            } else {
                self.forestReference.startPlantingProcess(type: 6)
                
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                Forest.num_water_bottles -= self.cost_for_option_6
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
            }
        }
    }
    
    func setForestReference(ref: SKScene) {
        self.forestReference = ref as! Forest
        print("Got the forest reference !")
        print(self.forestReference)
    }
}
