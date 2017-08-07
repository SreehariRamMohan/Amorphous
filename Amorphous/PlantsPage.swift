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
    
    weak var forestReference: Forest!
    
    let cost_for_option_1: Int = 3
    let cost_for_option_2: Int = 5
    let cost_for_option_3: Int = 7
    let cost_for_option_4: Int = 8
    let cost_for_option_5: Int = 9
    let cost_for_option_6: Int = 10
    
    var assigned = false
    
    var not_enough_water_label: SKLabelNode!
    
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
        
        not_enough_water_label = SKLabelNode()
        not_enough_water_label.zPosition = 12
        self.forestReference.addChild(not_enough_water_label)
        not_enough_water_label.fontName = "Gill Sans"
        not_enough_water_label.fontSize = 36
        not_enough_water_label.fontColor = UIColor.red
        not_enough_water_label.text = "Not enough water to buy!"
        not_enough_water_label.isHidden = true
    }
    
    func setOptionButtonCallbacks() {
        option_1_button.selectedHandler = {
            print("Option button 1 pressed")
            
            if(Forest.num_water_bottles < self.cost_for_option_1) {
                self.showBadBalance()
            } else {
                
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                self.forestReference.forestDataManager.addBottleData(numBottles: Int(self.forestReference.forestDataManager.getBottles().getNumberOfBottles()) - Int(self.cost_for_option_1))

                self.forestReference.startPlantingProcess(type: 1)
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
                
                //BELOW NOT WORKING WILL FIX
                //self.forestReference.forestDataManager.addBottleData(numBottles: Forest.num_water_bottles)
            }
            

        }
        
        option_2_button.selectedHandler = {
            print("Option button 2 pressed")
            
            if(Forest.num_water_bottles < self.cost_for_option_2) {
                self.showBadBalance()
            } else {
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                self.forestReference.forestDataManager.addBottleData(numBottles: Int(self.forestReference.forestDataManager.getBottles().getNumberOfBottles()) - Int(self.cost_for_option_2))
                
                self.forestReference.startPlantingProcess(type: 2)
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
            }
        }
        
        option_3_button.selectedHandler = {
            print("Option button 3 pressed")
            if(Forest.num_water_bottles < self.cost_for_option_3) {
                self.showBadBalance()
            } else {
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                self.forestReference.forestDataManager.addBottleData(numBottles: Int(self.forestReference.forestDataManager.getBottles().getNumberOfBottles()) - Int(self.cost_for_option_3))
                
                self.forestReference.startPlantingProcess(type: 3)
                
               
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
            }
        }
        
        option_4_button.selectedHandler = {
            print("Option button 4 pressed")
            if(Forest.num_water_bottles < self.cost_for_option_4) {
                self.showBadBalance()
            } else {
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                self.forestReference.forestDataManager.addBottleData(numBottles: Int(self.forestReference.forestDataManager.getBottles().getNumberOfBottles()) - Int(self.cost_for_option_4))
                
                self.forestReference.startPlantingProcess(type: 4)
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
            }
        }
        
        option_5_button.selectedHandler = {
            print("Option button 5 pressed")
            if(Forest.num_water_bottles < self.cost_for_option_5) {
                self.showBadBalance()
            } else {
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                self.forestReference.forestDataManager.addBottleData(numBottles: Int(self.forestReference.forestDataManager.getBottles().getNumberOfBottles()) - Int(self.cost_for_option_5))
                
                self.forestReference.startPlantingProcess(type: 5)
                
                //remove the buying screen after we have decided which plant we want to buy
                self.forestReference.destroyBuyFragment()
            }
        }
        
        option_6_button.selectedHandler = {
            print("Option button 6 pressed")
            if(Forest.num_water_bottles < self.cost_for_option_6) {
                self.showBadBalance()
            } else {
                //subtract the cost of the plant from the number of water bottles that the player has so we can update their remaining balance when we go back to the forest activity
                self.forestReference.forestDataManager.addBottleData(numBottles: Int(self.forestReference.forestDataManager.getBottles().getNumberOfBottles()) - Int(self.cost_for_option_6))
                
                self.forestReference.startPlantingProcess(type: 6)
                
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
    
    func showBadBalance() {
        let action1 = SKAction.run({
            self.not_enough_water_label.isHidden = false
            self.not_enough_water_label.zPosition = 12
        })
        let waitAction = SKAction.wait(forDuration: 1.25)
        let action2 = SKAction.run({
            self.not_enough_water_label.isHidden = true
        })
        let sequence = SKAction.sequence([action1, waitAction, action2])
        self.run(sequence)
        
    }
    
    deinit {
        print("De init PlantsPage page")
    }
}
