//
//  Level_2.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/13/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit

class Level_2: Level {
    
    //player variable
    var player: Player!
    var window: SKSpriteNode!
    var first = true
    
    override func didMove(to view: SKView) {
        //call did move in parent
        super.didMove(to: view)
        initialize_variables()
        print("did move of level 2")
    }
    
    
    func initialize_variables() {
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        print("reset the player")
        print("in level 2")
        
        //add player to the world
        addChild(player)
        
        player.position.x = -UIScreen.main.bounds.width/3
    }
    
    override func updateCamera() {
        if(currentPlayer != nil && currentPlayer?.position != nil) {
            if(cameraNode.position.y < -2*UIScreen.main.bounds.width){
                //the player is far below the screen, display the restart button
                showRestartButton()
            }
            let y = clamp(value: currentPlayer.position.y, lower: 20, upper: UIScreen.main.bounds.width/2-10)
            
            var x = currentPlayer.position.x
            if( LevelSelect.current_level == 1) {
                //clamp with level 1 dimensions in mind
                x = clamp(value: currentPlayer.position.x, lower: 0 , upper: 5*(UIScreen.main.bounds.width/2) + 165)
                
            } else {
                //add other if statements here to customize for the other levels
                x = currentPlayer.position.x
            }
            cameraNode.position.x = x
            cameraNode.position.y = y
        }
    
    }
    
    override func hintButtonPressed() {
        //Pan the camera around the level to alert the player of what obstacles are to come
        //Pan the camera from where the player is currently located to the location of the window(for them to escape)
        
        window = self.childNode(withName: "//window") as! SKSpriteNode
        let windowPos: CGPoint = self.convert(CGPoint(x:0, y:0), from: window)
        let moveAction = SKAction.move(to: windowPos, duration: 5)
        let moveAction2 = SKAction.move(to: player.position, duration: 5)
        let sequence = SKAction.sequence([moveAction, moveAction2])
        
        cameraNode.run(sequence)
    }
}
