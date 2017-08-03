//
//  Level_9.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/21/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
class Level_1: Level {
    
    //player variable
    var player: Player!
    var window: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        //call did move in parent
        super.didMove(to: view)
        initialize_variables()
        
        //play the correct sound
        playSound(nameOfFile: "Level_Music_1", type: "mp3")
    }
    
    
    func initialize_variables() {
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        print("reset the player in level 1")
        
        //add player to the world
        addChild(player)
        
        //this is an introductory level so we need to make the state ice so it is easier to move
        player.changeState(rawValue: 1)
    }
    
    override func updateCamera() {
        if(currentPlayer != nil && currentPlayer?.position != nil) {
            if(currentPlayer.position.y < -2*UIScreen.main.bounds.width){
                //the player is far below the screen, display the restart button
                showRestartButton()
            }
            let y = clamp(value: currentPlayer.position.y, lower: 20, upper: UIScreen.main.bounds.width/2-10)
            let x = clamp(value: currentPlayer.position.x, lower: 20 , upper: 1*(UIScreen.main.bounds.width/3))
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
        let myPosition = self.position
        
        let moveAction = SKAction.move(to: CGPoint(x: reformX(x: windowPos.x), y: reformY(y: windowPos.y)), duration: 1)
        let moveAction2 = SKAction.move(to: CGPoint(x: reformX(x: myPosition.x), y: reformY(y: myPosition.y)), duration: 1)
        let reset = SKAction.run({
            self.hasPressedHint = false
        })
        let sequence = SKAction.sequence([moveAction, moveAction2, reset])
        
        cameraNode.run(sequence)
        
        self.hasPressedHint = true
    }
    
    func reformY(y: CGFloat) -> CGFloat {
        return clamp(value: y, lower: 20, upper: UIScreen.main.bounds.width/2-10)

    }
    
    func reformX(x: CGFloat) -> CGFloat {
        return clamp(value: x, lower: 20 , upper: 1*(UIScreen.main.bounds.width/3))
    }
    
    deinit {
        print("De init Forest page")
        //remove all actions from this level to free up memory
        self.removeAllActions()
    }
}
