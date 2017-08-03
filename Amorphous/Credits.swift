//
//  Credits.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 8/3/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit

class Credits: SKScene {
    
    var back_to_forest: MSButtonNode!
    
    override func didMove(to view: SKView) {
        print("Inside didmove of credits screen.")
        back_to_forest = self.childNode(withName: "button_back_to_game") as! MSButtonNode
        back_to_forest.selectedHandler = { [weak self] in
            
            //go back to the Shop page
            
            /* Grab reference to our SpriteKit view */
            guard let skView = self?.view as SKView! else {
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
            
            scene.launchBuyFragment()
        }
    }
}
