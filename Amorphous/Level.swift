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
    
    //labels for Level superclass
    var button_back_to_level_select: UIButton!
    var button_restart_level: UIButton!
    var you_lose_label: UILabel!
    var next_level_label: UILabel!
    var button_next_level: UIButton!
    var button_hint: UIButton!
    
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
    
    
    
    //boolean values
    var windowHasCracked: Bool = false
    var canShift: Bool = true
    var canMove: Bool = true
    
    
        
    override func didMove(to view: SKView) {
        
        initializeCriticalGameVariables()
        
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
        addChild(cameraNode)
        
        //add a back_to_level_select, restart button, you_lose_label, yout_beat_level_label, next_level_button, and hint button to the scene without having it be moved by camera
        addBackToLevelUIButton()
        addRestartButton()
        addYouLoseLabel()
        addYouBeatLevelLabel()
        addNextLevelButton()
        addHintButton()
        
        //Have the world notify Level.swift to give contact information
        physicsWorld.contactDelegate = self
    }
    
    func initializeCriticalGameVariables() {
        windowHasCracked = false
        canMove = true
        canShift = true
    }
    
    func buttonLoadLevelSelect(sender: UIButton!) {
        guard sender == button_back_to_level_select else { return }
        // This function is called when button_back_to_level_select is pressed
        self.loadLevelSelect()
        self.isHidden = true
        
    }
    
    func setPlayer(player: Player) {
        self.currentPlayer = player
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        
        //update the camera position to follow the main character
        updateCamera()
                
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
                if(!canShift) {
                    return
                }
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!canMove) {
            return
        }
        let location = (touches.first as! UITouch).location(in: self.view)
        if location.x < (self.view?.bounds.size.width)!/2 {
            // left code: will be run when the touch is on the left side
            currentPlayer.applyLeftImpulse()
        } else {
            // right code: will be run when the touch is on the right side
            currentPlayer.applyRightImpulse()
        }
    }
    
    func loadLevelSelect() {
        //hide back to level select button immedietly.
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
        
        /* Start level select and hide buttons and labels that don't belong in level select*/
        hideYouLoseLabel()
        hideRestartButton()
        hideNextLevelButton()
        hideYouBeatLevelLabel()
        hideHintButton()
        
        //Remove the hint button and level select button from the superview so they won't be shown in the level select scene
        button_hint.removeFromSuperview()
        button_back_to_level_select.removeFromSuperview()
        
        skView.presentScene(scene)
    }
    
    func addBackToLevelUIButton() {
        /*
        This code creates the rectangular button with back to level select as an image 
        
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        btn.addTarget(self, action: #selector(Level.buttonLoadLevelSelect), for: .touchUpInside)
        self.view?.addSubview(btn)
        button_back_to_level_select = btn
        let btnImage = UIImage(named: "button_back_to_level_select")
        button_back_to_level_select.setImage(btnImage , for: [])
        
        //show back to level select button as soon as its added
        button_back_to_level_select.isHidden = false
        */
        
        //This code creates a circular button that allows the user to go back to level select
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 20, y: 10 , width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = .blue
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(Level.buttonLoadLevelSelect), for: .touchUpInside)
        button.isHidden = false
        button_back_to_level_select = button
        self.view?.addSubview(button)
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
    
    func addYouBeatLevelLabel() {
        let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.width/2 - 100, y: UIScreen.main.bounds.height/2 - 25, width: 400, height: 100))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "Congrats you beat level " + String(LevelSelect.current_level)
        label.font = label.font.withSize(40)
        label.layer.backgroundColor = UIColor(red: 246/255, green: 255/255, blue: 0/255, alpha: 1.0).cgColor
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        self.view?.addSubview(label)
        label.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2 - 30)
        next_level_label = label
        next_level_label.isHidden = true
    }
    
    func addNextLevelButton() {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - 175, y: UIScreen.main.bounds.height/2 + 100, width: 400, height: 60))
        btn.addTarget(self, action: #selector(Level.gotToNextLevel), for: .touchUpInside)
        self.view?.addSubview(btn)
        btn.setTitle("Click to travel Onward", for: [])
        btn.titleLabel?.font = UIFont.init(name: "Helvetica", size:40)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.red
        btn.sizeToFit()

        button_next_level = btn
        button_next_level.isHidden = true
    }
    
    func addHintButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 80, y: 10 , width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = .red
        button.setTitle("Hint", for: .normal)
        button.addTarget(self, action: #selector(hintButtonPressed), for: .touchUpInside)
        button_hint = button
        button.isHidden = false
        self.view?.addSubview(button)
    }
    
    func hintButtonPressed() {
        print("leave to children to implement")
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
        guard let scene = Level(fileNamed: "Level_" + String(LevelSelect.current_level)) else {
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
        
        //after the player loses we don't want them to be able to move or shift to a different state!
        canMove = false
        canShift = false
    }
    
    func setYouLoseText(deathBy: String) {
        self.you_lose_label.text = deathBy
    }
    
    func showYouBeatLevelLabel() {
        self.next_level_label.isHidden = false
    }
    
    func hideYouBeatLevelLabel() {
        self.next_level_label.isHidden = true
    }
    
    func showNextLevelButton() {
        self.button_next_level.isHidden = false
    }
    
    func hideNextLevelButton() {
        self.button_next_level.isHidden = true
    }
    
    func hideLabelsAndButtons() {
        hideNextLevelButton()
        hideYouBeatLevelLabel()
    }
    
    func hideHintButton() {
        button_hint.isHidden = true
    }
    
    func showHintButton() {
        button_hint.isHidden = false
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
            var bodyAction: SKAction?
            bodyAction = SKAction(named: "SpongeSuck")
            water.run(bodyAction!)
            currentPlayer.setMass(mass: 0.95*currentPlayer.getMass())
            /* Create a CLOSURE to safely execute water shrinking after the physics engine has finished rendering the frame so the code doesn't crash */
            let scalePhysicsBody = SKAction.run({
                /* Scale the currentPlayer.physics body in the scene */
                //reset the physics body after scaling main character down
                let currSize = self.currentPlayer.texture!.size()
                let currXSize = currSize.width * self.currentPlayer.xScale
                let currYSize = currSize.height * self.currentPlayer.yScale
                let newSize: CGSize = CGSize(width: currXSize, height: currYSize)
                self.currentPlayer.physicsBody = SKPhysicsBody(texture: self.currentPlayer.texture!,size: newSize)
                
                //reset the bitmasks for the player
                self.currentPlayer.physicsBody?.friction = CGFloat(CollisionManager.WATER_DROPLET_FRICTION_VALUE)
                self.currentPlayer.physicsBody?.categoryBitMask = UInt32(self.WATER_CATEGORY_BITMASK)
                self.currentPlayer.physicsBody?.contactTestBitMask = UInt32(self.WATER_CONTACT_BITMASK)
                self.currentPlayer.physicsBody?.collisionBitMask = UInt32(self.WATER_COLLISION_BITMASK)
            })
            self.run(scalePhysicsBody)
            
        }
        
        if(contactA.categoryBitMask == UInt32(CollisionManager.WINDOW_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.WINDOW_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK)) {
            /* Load the Window Crack animation so the player can escape and finish level 1!*/
            var iceCube: SKSpriteNode!
            if(contactA.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK)) {
                iceCube = nodeA
            } else {
                iceCube = nodeB
            }
            if(!windowHasCracked) {
                var windowSprite: SKSpriteNode  = self.childNode(withName:"//window") as! SKSpriteNode
                windowSprite.physicsBody?.collisionBitMask = 0
                self.physicsBody?.collisionBitMask = 0
                iceCube.physicsBody?.isDynamic = false
                
                //convert the point (0,0) from the window frame of reference to the scene frame of  reference
                let windowPos: CGPoint = self.convert(CGPoint(x:0, y:0), from: windowSprite)
                let moveAction = SKAction.move(to: windowPos, duration: 0.5)
                let shatter = SKAction(named: "WindowCrack")!
                
                iceCube.run(moveAction)
                windowSprite.run(shatter)
                windowHasCracked = true
                
                //stop the player from changing state & moving after they are inside the window
                canMove = false
                canShift = false
            } else {
                var windowSprite: SKSpriteNode  = self.childNode(withName:"//window") as! SKSpriteNode
                windowSprite.physicsBody?.collisionBitMask = 0
                self.physicsBody?.collisionBitMask = 0
                iceCube.physicsBody?.isDynamic = false
                
                //convert the point (0,0) from the window frame of reference to the scene frame of  reference
                let windowPos: CGPoint = self.convert(CGPoint(x:0, y:0), from: windowSprite)
                let moveAction = SKAction.move(to: windowPos, duration: 0.5)
                iceCube.run(moveAction)
            }
            
            //Display a message to the player telling them that they completed the level
            self.showYouBeatLevelLabel()
            self.showNextLevelButton()
            
        }
        
        if(contactA.categoryBitMask == UInt32(CollisionManager.SPIKE_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.SPIKE_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK)) {
            print("contact with spikes")
            showYouLoseLabel()
            setYouLoseText(deathBy: "Killed by Spikes")
            showRestartButton()
        }
        
        if(contactA.categoryBitMask == UInt32(CollisionManager.FAN_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(GAS_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.FAN_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(GAS_CATEGORY_BITMASK)) {
            print("contact between gas and fan")
            showYouLoseLabel()
            setYouLoseText(deathBy: "Killed by a fan")
            showRestartButton()
        }
        
        if(contactA.categoryBitMask == UInt32(CollisionManager.OIL_RIGHT_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.OIL_RIGHT_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK) ||
            contactA.categoryBitMask == UInt32(CollisionManager.OIL_RIGHT_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.OIL_RIGHT_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK)
            ) {
            print("contact between RIGHT oil and ice or water")
            var ice_or_water: SKSpriteNode!
            if(contactA.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK)) {
                ice_or_water = nodeA
            } else if(contactB.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK)){
                ice_or_water = nodeB
            }
            if(contactA.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK)) {
                ice_or_water = nodeA
            } else if(contactB.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK)){
                ice_or_water = nodeB
            }
            
            ice_or_water.physicsBody?.applyImpulse(CGVector(dx: CollisionManager.OIL_RIGHT_IMPULSE_FORCE, dy: 0))
        }
        
        if(contactA.categoryBitMask == UInt32(CollisionManager.OIL_LEFT_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.OIL_LEFT_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK) ||
            contactA.categoryBitMask == UInt32(CollisionManager.OIL_LEFT_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.OIL_LEFT_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK)) {
            print("contact between LEFT oil and ice or water")
            var ice_or_water: SKSpriteNode!
            if(contactA.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK)) {
                ice_or_water = nodeA
            } else if(contactB.categoryBitMask == UInt32(ICE_CATEGORY_BITMASK)){
                ice_or_water = nodeB
            }
            if(contactA.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK)) {
                ice_or_water = nodeA
            } else if(contactB.categoryBitMask == UInt32(WATER_CATEGORY_BITMASK)){
                ice_or_water = nodeB
            }
            
            ice_or_water.physicsBody?.applyImpulse(CGVector(dx: CollisionManager.OIL_LEFT_IMPULSE_FORCE, dy: 0))
        }
        
        
        
        
    }
    
    func updateCamera() {
        
    }
    
    func gotToNextLevel() {
        LevelSelect.current_level += 1
        print("loading level " + String(LevelSelect.current_level))
        self.loadLevel(level: LevelSelect.current_level)
        
        //make sure to hide any created buttons/labels that are not needed at the start of the level here.
        hideLabelsAndButtons()
    }
    
    func loadLevel(level: Int) {
        /* Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* Load Game scene */
        guard let scene = LevelSelect.level(level) else {
            print("Could not load GameScene with level " + String(level))
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
    
    /* Make a Class method to level */
    class func level(_ levelNumber: Int) -> Level? {
        guard let scene = Level(fileNamed: "Level_\(levelNumber)") else {
            return nil
        }
        scene.scaleMode = .aspectFit
        return scene
    }

}

func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}
