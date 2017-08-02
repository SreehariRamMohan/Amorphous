//
//  Level_8.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/21/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit

class Level_24: Level {
    
    //player variable
    var player: Player!
    var window: SKSpriteNode!
    var first = true
    
    override func didMove(to view: SKView) {
        //call did move in parent
        super.didMove(to: view)
        initialize_variables()
        print("did move of level 8")
        
        //level 8 has more obstacles, so we need to zoom the camera out in order for the player to be able to see them
        let zoomInAction = SKAction.scale(to: 2, duration: 0)
        cameraNode.run(zoomInAction)
    }
    
    
    func initialize_variables() {
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        print("reset the player")
        print("in level 8")
        
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
            let y = clamp(value: currentPlayer.position.y, lower: UIScreen.main.bounds.width/4, upper: 2*UIScreen.main.bounds.width - 180)
            let x = clamp(value: currentPlayer.position.x, lower: (UIScreen.main.bounds.height)/2 + 100 , upper: (7*(UIScreen.main.bounds.height/2) + 190))
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
        
        let moveAction = SKAction.move(to: CGPoint(x: windowPos.x - 430, y: UIScreen.main.bounds.width/4), duration: 5)
        let moveAction2 = SKAction.move(to: CGPoint(x: myPosition.x + 300, y:  UIScreen.main.bounds.width/4), duration: 5)
        let sequence = SKAction.sequence([moveAction, moveAction2])
        
        cameraNode.run(sequence)
    }
}
