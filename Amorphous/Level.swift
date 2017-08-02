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
    var createdSpringJoint: Bool = false
    
    //counts the number of water pools the player is touching
    var touchingWater: Int = 0
    
    //Water dependent Constants
    static let VISCOSITY: CGFloat = 6 //Increase to make the water "thicker/stickier," creating more friction.
    static let BUOYANCY: CGFloat = 0.4 //Slightly increase to make the object "float up faster," more buoyant.
    static let OFFSET: CGFloat = 60 //Increase to make the object float to the surface higher.
    
    //This is a reference to our water pool, so we can apply boyancy later on
    var water: SKSpriteNode!
    var ceiling: SKSpriteNode!
    
    var counter: Double!
    var timer = Timer()
    var timerLabel: UILabel!
    
    var Level_Summary_Fragment: SKReferenceNode!
    
    //goals for levels
    var goals: [(Double, Double, Double)] = [(0.6, 3, 4), (3.1, 5.1, 7.5),(6.1, 8, 10),(13.7, 15, 18),(6.8, 9.5, 11),(8.3, 9.7, 10.7),(12, 15.4, 19.6),(12.3, 14.2, 16.3),(16.5, 19.2, 22.3),(11.3, 12.7, 13.5),(16.8, 17.2, 18.5),(12.8, 14.3, 15),(14.5, 16, 18),(21, 22.9, 25),(27, 29, 30.5),(14.8, 15.4, 16),(29, 30.6, 31),(4.4, 9.3, 10.2),(30, 32, 33),(28.5, 29.3, 31),(10.6, 11.5, 12),(15.1, 16.3, 17.4),(30, 36, 39),(30, 30.5, 33),(55, 57, 62),(999, 999, 999), (999, 999, 999)]
    //this is the number of stars the user has received latest. This is a number from 0(for no stars) to 3(all stars), these values are then put into the array.
    static var starsReceived: [Int] = []
    static var dataManager: DataManager!
    
    //flame constants to determine when to melt ice
    var timeTouchingFlameAsIce: NSDate!
    var endTimeTouchingFlame: NSDate!
    var canTransform: Int = 0

    //boolean variables for the platform object. 
    var hasPassedHorizontalReference: Bool = false
    var hasPassedVerticalReference: Bool = false
    
    //boolean variables for the water bottles earned
    var hasAlreadyAddedToWaterBottleTotal: Bool = false
    
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
        
        //add a back_to_level_select, restart button, you_lose_label, yout_beat_level_label, stopwatch, next_level_button, and hint button to the scene without having it be moved by camera
        addBackToLevelUIButton()
        addRestartButton()
        addYouLoseLabel()
        addYouBeatLevelLabel()
        addNextLevelButton()
        addHintButton()
        addStopwatch()
        
        //Have the world notify Level.swift to get contact information
        physicsWorld.contactDelegate = self
        
        //initialize the variable ceiling
        self.ceiling = self.childNode(withName: "//ceiling") as! SKSpriteNode
        
        
        //set a callback to update so that updateTimer is called every 1/10 second
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateStopwatch), userInfo: nil, repeats: true)
        
        //This code can reverse gravity. Maybe make an antigravity obstacle later on???
        //self.physicsWorld.gravity = CGVector(dx: 0, dy: 9.8)
        
        //create a new Data Manager
        Level.dataManager = DataManager()
        for element in Level.dataManager.getScores() {
            Level.starsReceived.append(element.getScore())
            print("Here")
            print(element.getScore())
        }
    }
    
    func saveStarData() {
        for i in 0..<25 {
            Level.dataManager.addNewStar(level:(i+1), newScore: Level.starsReceived[i])
        }
    }
    
    func initializeCriticalGameVariables() {
        windowHasCracked = false
        canMove = true
        canShift = true
        ceiling = self.childNode(withName: "ceiling") as! SKSpriteNode
        //get the current time in seconds, to use as a stopwatch later to time the player
        self.counter = 0
    }
    
    func buttonLoadLevelSelect(sender: UIButton!) {
        //save the game before we go to the next level
        self.saveStarData()
        
        guard sender == button_back_to_level_select else { return }
        // This function is called when button_back_to_level_select is pressed
        button_back_to_level_select.removeFromSuperview()
        self.loadLevelSelect()
        
        //invalidate the timer to prevent memory leaks
        timer.invalidate()
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
            if(currentPlayer.getMass() < 0.5) {
                setYouLoseText(deathBy: "Death by mass loss from sponge ;(")
                showYouLoseLabel()
            }
        }
        
        //Loop over all of the children recursively which have name Sponge and call their update functions.
        self.enumerateChildNodes(withName: "//Sponge") {
            [weak self] node, stop in
            let Sponge = node as! Sponge
            // calling the sponge's update functions
            Sponge.update()
        }
        
        //Loop over all of the horizontal platforms and call their update methods to allow them to move.
        self.enumerateChildNodes(withName: "//horizontal_platform") {
            [weak self] node, stop in
            let platform = node as! HorizontalMovingPlatform
            if(!(self?.hasPassedHorizontalReference)!) {
                platform.passParentReference(parent: self!)
            }
            platform.update()
        }
        self.hasPassedHorizontalReference = true
        
        //Loop over all of the vertical platforms and call their update methods to allow them to move
        self.enumerateChildNodes(withName: "//vertical_platform"){
            [weak self] node, stop in
            let platform = node as! VerticalMovingPlatform
            if(!(self?.hasPassedVerticalReference)!) {
                platform.passParentReference(parent: self!)
            }
            platform.update()
        }
        self.hasPassedVerticalReference = true
        
        //Loop over all of the FallingBlock sprites, and if they are directly above the current player, then drop them down to the ground!
        self.enumerateChildNodes(withName: "//falling_block_sprite") {
            [weak self] node, stop in
            let BlockSprite = node as! FallingBlock
            
            //create a spring joint to the ceiling
            if(!(self?.createdSpringJoint)!) {
                let spring = SKPhysicsJointSpring.joint(withBodyA: BlockSprite.physicsBody!,
                                                        bodyB: (self?.ceiling.physicsBody!)!,
                                                        anchorA: BlockSprite.convert(CGPoint(x: 0, y: 0), to: self!),
                                                        anchorB: CGPoint(x: BlockSprite.convert(CGPoint(x: 0, y: 0), to: self!).x, y: (self?.ceiling.position.y)!))
                print(self?.ceiling.position)
                spring.frequency = 0.5
                spring.damping = 0.01
                self?.scene?.physicsWorld.add(spring)
            }
            
            else if(abs(BlockSprite.convert(CGPoint(x: 0,y: 0), to: self!).x-(self?.currentPlayer.position.x)!) < 8 ){
                // calling the Block's fall functions
                BlockSprite.fall()
            }
        }
        self.createdSpringJoint = true
        
        
        
        if(self.touchingWater > 0) {
            //let water = self.childNode(withName: "//Water") as! SKSpriteNode
            let water = self.water
            //apply boyant force when we are touching water
            let rate: CGFloat = 0.01; //Controls rate of applied motion. You shouldn't really need to touch this.
            let position = self.convert(CGPoint(x: 0, y: 0), from: water!)
            let posY = position.y
            let part1 = posY+Level.OFFSET
            let part2 = part1+(water?.size.height)!/2.0
            let part3 = self.currentPlayer.position.y
            let part4 = part3-self.currentPlayer.size.height/2.0
            let disp = (part2 - part4) * Level.BUOYANCY
            let targetPos = CGPoint(x: self.currentPlayer.position.x, y: self.currentPlayer.position.y+disp)
            let targetVel = CGPoint(x: (targetPos.x-self.currentPlayer.position.x)/(1.0/60.0), y: (targetPos.y-self.currentPlayer.position.y)/(1.0/60.0))
            let relVel: CGVector = CGVector(dx:targetVel.x-self.currentPlayer.physicsBody!.velocity.dx*Level.VISCOSITY, dy:targetVel.y-self.currentPlayer.physicsBody!.velocity.dy*Level.VISCOSITY);
            self.currentPlayer.physicsBody?.velocity=CGVector(dx:(self.currentPlayer.physicsBody?.velocity.dx)!+relVel.dx*rate, dy:(self.currentPlayer.physicsBody?.velocity.dy)!+relVel.dy*rate);
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                if(canMove && canShift) {
                    currentPlayer.applyRightImpulse()
                }
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                if(!canShift) {
                    return
                }
                if(canMove && canShift) {
                    currentPlayer.changeState()
                }
                self.touchingWater = 0
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                currentPlayer.applyLeftImpulse()
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
        
        var scene: SKScene!
        
        //Go back to the current chapter the player is currently in when they press the back button, not the first chapter.
        if(LevelSelect.current_chapter == 1) {
            /* Load Game scene */
            scene = LevelSelect(fileNamed: "LevelSelect")
        } else if(LevelSelect.current_chapter == 2) {
            /* Load Game scene */
            scene = LevelSelect2(fileNamed: "LevelSelect2")
        } else if(LevelSelect.current_chapter == 3) {
            /* Load Game scene */
            scene = LevelSelect3(fileNamed: "LevelSelect3")
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
        removeButtons()
        
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
    
    func addStopwatch() {
        self.timerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.timerLabel.center = CGPoint(x: UIScreen.main.bounds.width/2, y: 50)
        self.timerLabel.textAlignment = .center
        self.timerLabel.text = String(self.counter)
        self.timerLabel.textColor = UIColor.white
        self.timerLabel.font = timerLabel.font.withSize(25)
        self.timerLabel.layer.cornerRadius = timerLabel.frame.width/2
        self.timerLabel.layer.backgroundColor = UIColor(red: 0/255, green: 159/255, blue: 184/255, alpha: 1.0).cgColor
        self.view?.addSubview(timerLabel)
    
    }
    
    func updateStopwatch() {
        if(canMove && canShift) {
            counter? += 0.1
            timerLabel.text = String(self.counter.format(f: ".1"))
            updateStopwatchBackground()
        } else {
            timer.invalidate()
        }
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
        
        //remove the timer to prevent memory leaks
        timer.invalidate()
        
        //remove all current buttons, to prevent the build-up of buttons in the scene
        removeButtons()
        
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
            
            currentPlayer.setMass(mass: 0.99*currentPlayer.getMass())
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
            
            //Player has beaten the level
            
            launchLevelSummaryFragment()
            
            //Display a message to the player telling them that they completed the level
            //self.showYouBeatLevelLabel()
            //self.showNextLevelButton()
            
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
        
        if(contactA.categoryBitMask == UInt32(CollisionManager.WATER_POOL_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.WATER_POOL_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK)) {
            self.touchingWater += 1
            if(contactA.categoryBitMask == UInt32(CollisionManager.WATER_POOL_CATEGORY_BITMASK) ) {
                self.water = nodeA
            } else if(contactB.categoryBitMask == UInt32(CollisionManager.WATER_POOL_CATEGORY_BITMASK)){
                self.water = nodeB
            }
        }
        
        if(contactA.categoryBitMask == UInt32(CollisionManager.FALLING_BLOCK_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.FALLING_BLOCK_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK)) {
            print("BLOCK COLLISON")
            showYouLoseLabel()
            setYouLoseText(deathBy: "Smashed by a falling block")
            showRestartButton()
        }
        
        if(contactA.categoryBitMask == UInt32(CollisionManager.FLAME_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(CollisionManager.WATER_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.FLAME_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(CollisionManager.WATER_CATEGORY_BITMASK) || contactA.categoryBitMask == UInt32(CollisionManager.FLAME_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.FLAME_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK)) {
            
            if(self.canTransform != 0) {
                //this check makes sure that ice can't directly go to gas after it has touched fire. It needs to wait at least < 2 seconds(130 times into this method) before it can make the jump from ice -> water -> gas
                self.canTransform -= 1
            }
            
            var sprite: Player!
            
            if(self.canTransform == 0) { //makes sure that we aren't directly switching from ice -> gas, we need to wait in water for at least 130 frames!
                if(contactA.categoryBitMask == UInt32(CollisionManager.WATER_CATEGORY_BITMASK)) {
                    //node A is water
                    sprite = nodeA as! Player
                    sprite.changeState(rawValue: 3)
                } else if(contactB.categoryBitMask == UInt32(CollisionManager.WATER_CATEGORY_BITMASK)) {
                    //node B is water
                    sprite = nodeB as! Player
                    sprite.changeState(rawValue: 3)
                }
            }
            
            if(contactA.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK)) {
                //node A is ice
                //start the timer for when we are touching the flame as ice, note if this time is greater than 2 seconds we will transfer to gas
                //if this time is less than 2 seconds then the ice will simply melt into water
                self.timeTouchingFlameAsIce = NSDate()
            } else if(contactB.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK)) {
                //node B is ice
                self.timeTouchingFlameAsIce = NSDate()
            }
            
            
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        /* Physics contact delegate implementation */
        /* Get references to the bodies involved in the collision */
        let contactA:SKPhysicsBody = contact.bodyA
        let contactB:SKPhysicsBody = contact.bodyB
        /* Get references to the physics body parent SKSpriteNode */
        let nodeA = contactA.node as! SKSpriteNode
        let nodeB = contactB.node as! SKSpriteNode
        /* Check the physics bodies category bitmasks to determine their name */
        if(contactA.categoryBitMask == UInt32(CollisionManager.WATER_POOL_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.WATER_POOL_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK)) {
            self.touchingWater -= 1
        }
        
        if(contactA.categoryBitMask == UInt32(CollisionManager.FLAME_CATEGORY_BITMASK) && contactB.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK) || contactB.categoryBitMask == UInt32(CollisionManager.FLAME_CATEGORY_BITMASK) && contactA.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK)) {
            self.endTimeTouchingFlame = NSDate()
            let timeInterval: Double = self.endTimeTouchingFlame.timeIntervalSince(self.timeTouchingFlameAsIce as Date)
            var sprite: Player!
            
            //assigns the sprite variable to the node which is ice
            if(contactA.categoryBitMask == UInt32(CollisionManager.ICE_CATEGORY_BITMASK)) {
                sprite = nodeA as! Player
            } else {
                sprite = nodeB as! Player
            }
            
            //if the ice has been on the fire for less than 1.5 sec then change it to water, but if it has been on the flame for more than 1.5 sec change it to gas.
            if(timeInterval < 1) {
                sprite.changeState(rawValue: 2)
                print(timeInterval)
                self.canTransform = 130
                
            } else {
                sprite.changeState(rawValue: 3)
                print(timeInterval)
            }
        }
        
        
    }

    func updateCamera() {
        
    }
    
    func gotToNextLevel() {
        //save the game before we go to the next level
        self.saveStarData()
        
        LevelSelect.current_level += 1
        print("loading level " + String(LevelSelect.current_level))
        self.loadLevel(level: LevelSelect.current_level)
        //make sure to remove any created buttons/labels that are not needed at the start of the level here.
        //This prevents the build-up of excessive buttons that are not needed by the sytem.
        removeButtons()
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
    
    //This is a function that each level will override to set the time constraints differently!
    func updateStopwatchBackground() {
        if(self.counter < Double(self.goals[LevelSelect.current_level-1].0)) {
            timerLabel.layer.backgroundColor = UIColor(red: 12/255, green: 183/255, blue: 15/255, alpha: 1.0).cgColor
        } else if(self.counter < Double(self.goals[LevelSelect.current_level-1].1)) {
            timerLabel.layer.backgroundColor = UIColor(red: 239/255, green: 232/255, blue: 11/255, alpha: 1.0).cgColor
        } else if(self.counter < Double(self.goals[LevelSelect.current_level-1].2)) {
            timerLabel.layer.backgroundColor = UIColor(red: 229/255, green: 55/255, blue: 55/255, alpha: 1.0).cgColor
        } else {
            timerLabel.layer.backgroundColor = UIColor(red: 48/255, green: 3/255, blue: 3/255, alpha: 1.0).cgColor
        }
        
    }
    
    func removeButtons() {
        button_hint.removeFromSuperview()
        timerLabel.removeFromSuperview()
        button_back_to_level_select.removeFromSuperview()
        print(self.view?.subviews.contains(button_hint))
        print(self.view?.subviews.contains(timerLabel))
        print(self.view?.subviews.contains(button_back_to_level_select))
    }
    
    /* Make a Class method to level */
    class func level(_ levelNumber: Int) -> Level? {
        guard let scene = Level(fileNamed: "Level_\(levelNumber)") else {
            return nil
        }
        scene.scaleMode = .aspectFit
        return scene
    }
    
    func launchLevelSummaryFragment() {
        
        //to make sure that this method isn't called more than once and subseauently, the players water bottle count goes up by 2-3 for each level.
        if(!hasAlreadyAddedToWaterBottleTotal) {
            //Increase our num water bottles since we succesfully completed the level!
            Level.dataManager.addBottleData(numBottles: Int(Level.dataManager.getBottles().getNumberOfBottles()) + Int(1))
            self.hasAlreadyAddedToWaterBottleTotal = true
        }
        
        
        //intentionally delay the summary screen fromt showing until the break window animation has finished
        let delay = SKAction.wait(forDuration: 2.9)
        self.run(delay) {
            //remove the timer so it doesn't block some text
            self.timerLabel.removeFromSuperview()
            //remove the hint button, we don't need it because we already completed the level.
            self.button_hint.removeFromSuperview()
            print("Launched the summary page")
            let path = Bundle.main.path(forResource: "LevelSummary", ofType: "sks")
            let fragment = SKReferenceNode(url: URL (fileURLWithPath: path!))
            print(fragment.children)
            //give the fragment a reference to Superclass, this is vitally important or the level summary fragment will crash!
            let levelSummary = fragment.childNode(withName: "//LevelSummary") as! LevelSummary
            //setup the level summary, this initializes and sets callbacks to buttons and variables
            levelSummary.setup()
            levelSummary.setParentReference(parentReference: self)
            levelSummary.populateWithInformation()
            //set the level summary fragment view to the center of the screen!
            fragment.position = CGPoint(x: 0, y: 0)
            self.Level_Summary_Fragment = fragment
            print("Fragment position is")
            print(fragment.position.x)
            print(fragment.position.y)
            self.cameraNode.addChild(fragment)
        }
    }
    
    func destroyLevelSummaryFragment() {
        Level_Summary_Fragment.removeFromParent()
    }
    
    func getTimerLabel() -> UILabel {
        print(self.timerLabel)
        return self.timerLabel
    }
    
    deinit {
        print("De init Forest page")
        //remove all SKActions to help free up some memory
        self.removeAllActions()
        self.view?.gestureRecognizers?.removeAll()
        self.timer.invalidate()
    }
    
}

func clamp<T: Comparable>(value: T, lower: T, upper: T) -> T {
    return min(max(value, lower), upper)
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
