//
//  Level_1.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/10/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit

class Level_9: Level {
    
    //player variable
    var player: Player!
    var window: SKSpriteNode!
    override func didMove(to view: SKView) {
        //call did move in parent
        super.didMove(to: view)
        initialize_variables()
    }
    
    
    func initialize_variables() {
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        print("reset the player in level 1")
        
        //add player to the world
        addChild(player)
    }
    
    override func updateCamera() {
        if(currentPlayer != nil && currentPlayer?.position != nil) {
            if(cameraNode.position.y < -2*UIScreen.main.bounds.width){
                //the player is far below the screen, display the restart button
                showRestartButton()
            }
            let y = clamp(value: currentPlayer.position.y, lower: 20, upper: UIScreen.main.bounds.width/2-10)
            let x = clamp(value: currentPlayer.position.x, lower: 0 , upper: 5*(UIScreen.main.bounds.width/2) + 165)
            //clamp with level 1 dimensions in mind
            cameraNode.position.x = x
            cameraNode.position.y = y
        }
    }
    
    override func hintButtonPressed() {
        //Pan the camera around the level to alert the player of what obstacles are to come
        //Pan the camera from where the player is currently located to the location of the window(for them to escape)
        
        window = self.childNode(withName: "//window") as! SKSpriteNode
        let windowPos: CGPoint = self.convert(CGPoint(x:0, y:0), from: window)
        let myPosition = self.position
        
        let moveAction = SKAction.move(to: CGPoint(x: windowPos.x, y: myPosition.y), duration: 5)
        let moveAction2 = SKAction.move(to: CGPoint(x: myPosition.x, y: myPosition.y), duration: 5)
        let sequence = SKAction.sequence([moveAction, moveAction2])
        
        cameraNode.run(sequence)
    }
}