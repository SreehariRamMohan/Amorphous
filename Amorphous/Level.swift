//
//  Level.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/10/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
class Level: SKScene {

    //a reference to the current player, value will be reassigned at the start of each Level
    var currentPlayer: Player!
    
    let cameraNode = SKCameraNode()
    
    var button_back_to_level_select: UIButton!

        
    override func didMove(to view: SKView) {
        //create a swipe down action, and link Level class to recieve the notification.
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        //create swipe up action
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view?.addGestureRecognizer(swipeUp)
        
        //create a swipe left action
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeft)
        
        //create a swipe right action and pass in respondToSwipeGesture to be called when a swipe is detected
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRight)
        
        //adds cameraNode to the scene's camera
        self.camera = cameraNode
        
        addBackToLevelUIButton()
    }
    
    func buttonAction(sender: UIButton!) {
        guard sender == button_back_to_level_select else { return }
        // This function is called when button_back_to_level_select is pressed
        self.loadLevelSelect()
        
    }
    
    func setPlayer(player: Player) {
        self.currentPlayer = player
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        
        if(currentPlayer != nil && currentPlayer?.position != nil) {
            cameraNode.position = currentPlayer.position
        }
        
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                currentPlayer.changeState()
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        let location = (touches.first as! UITouch).location(in: self.view)
        if location.x < (self.view?.bounds.size.width)!/2 {
            // left code: will be run when the touch is on the left side
            currentPlayer.applyLeftImpulse()
        } else {
            // right code: will be run when the touch is on the right side
            currentPlayer.applyRightImpulse()
        }
    }
    
    func loadLevelSelect() {
        button_back_to_level_select.isHidden = true
    
        /* Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* Load Game scene */
        guard let scene = LevelSelect(fileNamed: "LevelSelect") else {
            print("Could not go back and load level select")
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
    }
    
    func addBackToLevelUIButton() {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        btn.addTarget(self, action: #selector(Level.buttonAction), for: .touchUpInside)
        self.view?.addSubview(btn)
        button_back_to_level_select = btn
        let btnImage = UIImage(named: "button_back_to_level_select")
        button_back_to_level_select.setImage(btnImage , for: [])
        button_back_to_level_select.isHidden = false
    }
}
