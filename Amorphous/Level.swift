//
//  Level.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/10/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
class Level: SKScene, SKPhysicsContactDelegate {

    //a reference to the current player, value will be reassigned at the start of each Level
    var currentPlayer: Player!
    
    let cameraNode = SKCameraNode()
    
    var button_back_to_level_select: UIButton!
    var button_restart_level: UIButton!
    var you_lose_label: UILabel!
    
    //Bitmask Constants for the Player
    let ICE_COLLISION_BITMASK = CollisionManager.ICE_COLLISION_BITMASK
    let ICE_CONTACT_BITMASK = CollisionManager.ICE_CONTACT_BITMASK
    let ICE_CATEGORY_BITMASK = CollisionManager.ICE_CATEGORY_BITMASK
    
    let WATER_COLLISION_BITMASK = CollisionManager.WATER_COLLISION_BITMASK
    let WATER_CONTACT_BITMASK = CollisionManager.WATER_CONTACT_BITMASK
    let WATER_CATEGORY_BITMASK = CollisionManager.WATER_CATEGORY_BITMASK
    
    let GAS_COLLISION_BITMASK = CollisionManager.GAS_COLLISION_BITMASK
    let GAS_CONTACT_BITMASK = CollisionManager.GAS_CONTACT_BITMASK
    let GAS_CATEGORY_BITMASK = CollisionManager.GAS_CATEGORY_BITMASK

    //Obstacle/Object Bitmask Constants
    let SPONGE_CATEGORY_BITMASK = CollisionManager.SPONGE_CATEGORY_BITMASK
    let SPONGE_COLLISION_BITMASK = CollisionManager.SPONGE_COLLISION_BITMASK
    let SPONGE_CONTACT_BITMASK = CollisionManager.SPONGE_CONTACT_BITMASK
    
        
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
        
        //add a back_to_level_select, restart button, and the you_lose_label to the scene without having it be moved by camera
        addBackToLevelUIButton()
        addRestartButton()
        addYouLoseLabel()
        
        //Have the world notify Level.swift to give contact information
        physicsWorld.contactDelegate = self
    }
    
    func buttonLoadLevelSelect(sender: UIButton!) {
        guard sender == button_back_to_level_select else { return }
        // This function is called when button_back_to_level_select is pressed
        self.loadLevelSelect()
        
    }
    
    func setPlayer(player: Player) {
        self.currentPlayer = player
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        
        if(currentPlayer != nil && currentPlayer?.position != nil) {
            if(cameraNode.position.y < -2*UIScreen.main.bounds.width){
                //the player is far below the screen, display the restart button
                showRestartButton()
            }
            cameraNode.position.x = currentPlayer.position.x
            cameraNode.position.y = currentPlayer.position.y + 95
        }
        
        if(currentPlayer != nil) {
            //call the current player update method
            currentPlayer.update()
            //check if the current player is dead if their mass is less than 0.01
            if(currentPlayer.getMass() < 0.01) {
                setYouLoseText(deathBy: "Death by mass loss from sponge ;(")
                showYouLoseLabel()
            }
        }
        
        //Loop over all of the children recursively which have name Sponge and call their update functions.
        self.enumerateChildNodes(withName: "//Sponge") {
            node, stop in
            let Sponge = node as! Sponge
            // calling the sponge's update functions
            Sponge.update()
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
                currentPlayer.jump()
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
        
        /* Start game scene and hide the back_to_level_select button*/
        button_back_to_level_select.isHidden = true
        hideYouLoseLabel()
        hideRestartButton()
    
        skView.presentScene(scene)
    }
    
    func addBackToLevelUIButton() {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        btn.addTarget(self, action: #selector(Level.buttonLoadLevelSelect), for: .touchUpInside)
        self.view?.addSubview(btn)
        button_back_to_level_select = btn
        let btnImage = UIImage(named: "button_back_to_level_select")
        button_back_to_level_select.setImage(btnImage , for: [])
        button_back_to_level_select.isHidden = false
    }
    
    func addRestartButton() {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 25, width: 200, height: 50))
        btn.addTarget(self, action: #selector(Level.buttonRestartLevel), for: .touchUpInside)
        self.view?.addSubview(btn)
        button_restart_level = btn
        let btnImage = UIImage(named: "button_restart_level")
        button_restart_level.setImage(btnImage , for: [])
        button_restart_level.isHidden = true
    }
    
    func addYouLoseLabel() {
        let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 25, width: 200, height: 50))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "This is the default text when the Label is initialized"
        label.layer.backgroundColor = UIColor(red: 61/255, green: 83/255, blue: 255/255, alpha: 1.0).cgColor
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        self.view?.addSubview(label)
        label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 30)
        you_lose_label = label
        you_lose_label.isHidden = true
    }
    
    
    
    func buttonRestartLevel(sender: UIButton!) {
        button_back_to_level_select.isHidden = true
        guard sender == button_restart_level else { return }
        // This function is called when button_back_to_level_select is pressed
        print("restarting level")
        guard let skView = self.view as SKView! else{
            print("Could not get Skview")
            return
        }
        button_restart_level.isHidden = true
        guard let scene = Level(fileNamed: "Level_" + String(currentPlayer.getCurrentLevel())) else {
            return
        }
        scene.scaleMode = .aspectFit
        
        //hide the restart button and the you_lose_label text
        button_restart_level.isHidden = true
        you_lose_label.isHidden = true
        
        skView.presentScene(scene)
    }
    
    func showRestartButton() {
        self.button_restart_level.isHidden = false
    }
    
    func hideRestartButton() {
        self.button_restart_level.isHidden = true
    }
    
    func hideYouLoseLabel() {
        self.you_lose_label.isHidden = true
    }
    
    func showYouLoseLabel() {
        self.you_lose_label.isHidden = false
        showRestartButton()
    }
    
    func setYouLoseText(deathBy: String) {
        self.you_lose_label.text = deathBy
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Physics contact delegate implementation */
        /* Get references to the bodies involved in the collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        /* Get references to the physics body parent SKSpriteNode */
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        /* Check the physics bodies category bitmasks to determine their name */
        if(contactA.categoryBitMask == UInt32(SPONGE_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(SPONGE_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK)) {
            
            var water: SKSpriteNode!
            if(contactA.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK)) {
                water = nodeA
            } else {
                water = nodeB
            }
            print("contact between sponge and water")
            var bodyAction: SKAction?
            bodyAction = SKAction(named: "SpongeSuck")
            water.run(bodyAction!)
            currentPlayer.setMass(mass: 0.95*currentPlayer.getMass())
            
        }
        
        
    }
}
