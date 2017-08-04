//
//  Level_23.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/26/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit

class Level_23: Level {
    
    //player variable
    var player: Player!
    var window: SKSpriteNode!
    var first = true
    
    override func didMove(to view: SKView) {
        //call did move in parent
        super.didMove(to: view)
        initialize_variables()
        print("did move of level 23")
        
        //level 23 has more obstacles, so we need to zoom the camera out in order for the player to be able to see them
        let zoomInAction = SKAction.scale(to: 2, duration: 0)
        cameraNode.run(zoomInAction)
        
        //play the correct sound
        playSound(nameOfFile: "Level_Music_23", type: "mp3")
    }
    
    
    func initialize_variables() {
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        print("reset the player")
        print("in level 23")
        
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
            var y = clamp(value: currentPlayer.position.y, lower: UIScreen.main.bounds.width/4, upper: 2*UIScreen.main.bounds.width - 180)
            let x = clamp(value: currentPlayer.position.x, lower: (UIScreen.main.bounds.height)/2 + 100 , upper: (8*(UIScreen.main.bounds.height/2) + 190))
            //clamp with level 1 dimensions in mind
            cameraNode.position.x = x
            cameraNode.position.y = y
        }
    }
    
    override func hintButtonPressed() {
        //prevent the player from spamming the hint button
        if(self.hasPressedHint) {
            return
        }
        //Pan the camera around the level to alert the player of what obstacles are to come
        //Pan the camera from where the player is currently located to the location of the window(for them to escape)
        
        window = self.childNode(withName: "//window") as! SKSpriteNode
        let windowPos: CGPoint = self.convert(CGPoint(x:0, y:0), from: window)
        let myPosition = self.player.position
        
        let moveAction = SKAction.move(to: CGPoint(x: reformX(x: windowPos.x), y: reformY(y: windowPos.y)), duration: 2)
        let moveAction2 = SKAction.move(to: CGPoint(x: reformX(x: myPosition.x), y: reformY(y: myPosition.y)), duration: 1)
        let reset = SKAction.run({
            self.hasPressedHint = false
        })
        let sequence = SKAction.sequence([moveAction, moveAction2, reset])
        
        cameraNode.run(sequence)
        
        self.hasPressedHint = true
    }
    
    func reformY(y: CGFloat) -> CGFloat {
        return clamp(value: y, lower: UIScreen.main.bounds.width/4, upper: 2*UIScreen.main.bounds.width - 180)
    }
    
    func reformX(x: CGFloat) -> CGFloat {
        return clamp(value: x, lower: (UIScreen.main.bounds.height)/2 + 100 , upper: (8*(UIScreen.main.bounds.height/2) + 190))
    }
}
