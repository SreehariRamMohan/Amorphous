//
//  Level_4.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/15/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit

class Level_10: Level {
    
    //player variable
    var player: Player!
    var window: SKSpriteNode!
    var first = true
    
    
    override func didMove(to view: SKView) {
        //call did move in parent
        super.didMove(to: view)
        initialize_variables()
        print("did move of level 10")
        
        //level 3 has more obstacles, so we need to zoom the camera out in order for the player to be able to see them
        let zoomInAction = SKAction.scale(to: 2, duration: 0)
        cameraNode.run(zoomInAction)
        
        //play the correct sound
        playSound(nameOfFile: "Level_Music_10", type: "mp3")
    }
    
    
    func initialize_variables() {
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        print("reset the player")
        print("in level 10")
        
        //add player to the world
        addChild(player)
        
        player.position.x = -UIScreen.main.bounds.width/3
        
    }
    
    override func updateCamera() {
        if(currentPlayer != nil && currentPlayer?.position != nil) {
            if(currentPlayer.position.y < -2*UIScreen.main.bounds.width){
                //the player is far below the screen, display the restart button
                showRestartButton()
            }
            
            //will figure out the clamp values later
            
//            let y = clamp(value: currentPlayer.position.y, lower: UIScreen.main.bounds.width/4, upper: UIScreen.main.bounds.width/2 - 180)
//            let x = clamp(value: currentPlayer.position.x, lower: (UIScreen.main.bounds.height)/2 + 100 , upper: (7*(UIScreen.main.bounds.height/2) + 190))
            //clamp with level 1 dimensions in mind
            
            
            cameraNode.position.x = currentPlayer.position.x
            cameraNode.position.y = currentPlayer.position.y
        }
    }
    
    override func hintButtonPressed() {
        //Pan the camera around the level to alert the player of what obstacles are to come
        //Pan the camera from where the player is currently located to the location of the window(for them to escape)
        window = self.childNode(withName: "//window") as! SKSpriteNode
        let windowPos: CGPoint = self.convert(CGPoint(x:0, y:0), from: window)
        let myPosition = self.position
        
        let moveAction = SKAction.move(to: CGPoint(x: windowPos.x, y: windowPos.y), duration: 3)
        let moveAction2 = SKAction.move(to: CGPoint(x: myPosition.x, y: myPosition.y), duration: 3)
        let sequence = SKAction.sequence([moveAction, moveAction2])
        
        cameraNode.run(sequence)
    }
}
