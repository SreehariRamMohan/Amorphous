//
//  Level_17.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/25/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
class Level_17: Level {
    //player variable
    var player: Player!
    var window: SKSpriteNode!
    var first = true
    
    override func didMove(to view: SKView) {
        //call did move in parent
        super.didMove(to: view)
        initialize_variables()
        print("did move of level 17")
        
        //level 17 has more obstacles which fall from the ceiling, so we need to zoom the camera out in order for the player to be able to see them
        let zoomInAction = SKAction.scale(to: 3, duration: 0)
        cameraNode.run(zoomInAction)
        
        //play the correct sound
        playSound(nameOfFile: "Level_Music_17", type: "mp3")
    }
    
    
    func initialize_variables() {
        //create player object
        player = Player()
        
        //tell Level who the player is
        self.setPlayer(player: player)
        
        print("reset the player")
        print("in level 17")
        
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
            let y = clamp(value: currentPlayer.position.y, lower: UIScreen.main.bounds.width/3, upper: UIScreen.main.bounds.width-10)
            let x = clamp(value: currentPlayer.position.x, lower: 3*UIScreen.main.bounds.height/2, upper: 23*(UIScreen.main.bounds.width/3))
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
        return clamp(value: y, lower: UIScreen.main.bounds.width/3, upper: UIScreen.main.bounds.width-10)
    }
    
    func reformX(x: CGFloat) -> CGFloat {
        return clamp(value: x, lower: UIScreen.main.bounds.height/4 , upper: 22*(UIScreen.main.bounds.width/3))
    }
}
