//
//  Forest.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/10/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import SpriteKit
import GameplayKit

class Forest: SKScene {
    
    //create button variables
    var plant_button: MSButtonNode!
    var rescue_water_button: MSButtonNode!
    var background_of_forest: SKNode!
    var planting_instructions_label: SKNode!
    var watering_instructions_label: SKNode!
    var effects_node: SKEffectNode!
    var button_x: MSButtonNode!
    var forestDataManager: DataManager!
    static var num_water_bottles: Int!
    weak var buy_fragment: SKReferenceNode!
    
    var forest_camera: SKCameraNode!
    
    //boolean values
    var canScroll: Bool = true
    //a boolean flag variable to help differentiate between scrolling and touching so the placement of trees can be accurate
    var didScroll = false
    
    //arrays
    var arrayOfBottles: [SKSpriteNode] = []
    
    //boolean values for planting/watering
    var canPlant: Bool = false
    var canWater: Bool = false
    //type of tree to plant
    var typeOfTree: Int = -1
    //array to hold trees in the forest
    var tree_array: [Plant]!
    
    override func didMove(to view: SKView) {
        //initialize the data manager
        forestDataManager = DataManager()
        
        Forest.num_water_bottles = forestDataManager.getBottles().getNumberOfBottles()
        //get an array of our saved garden
        self.tree_array = forestDataManager.getTreesAsPlantObjectArray()
        
        //update the color of the trees based on how long ago they've been watered. If they've been watered a long time ago, make them turn brown. 
        
        updateTheHealthOfTrees(array: self.tree_array)
        
        //redraw the saved objects to the screen.
        drawSavedTrees(array: self.tree_array)
        
        initialize_buttons()
        button_action_callbacks()
        setDefaultButtonVisibilityState()
        
        
        //cap the maximum water you can have at any time to 10 water bottles
        if(Forest.num_water_bottles > 10) {
            Forest.num_water_bottles = 10
            forestDataManager.addBottleData(numBottles: Forest.num_water_bottles)
        }
        
        print(Forest.num_water_bottles)
        for i in 1...10 {
            var water_bottle: SKSpriteNode = self.childNode(withName: "//water_bottle_\(i)") as! SKSpriteNode
            water_bottle.isHidden = true
            if(i <= Forest.num_water_bottles) {
                water_bottle.isHidden = false
            } else {
                water_bottle.isHidden = true
            }
            self.arrayOfBottles.append(water_bottle)
        }
        
        
        forest_camera = self.childNode(withName: "forest_camera_node") as! SKCameraNode
        self.camera = forest_camera
    
        }

    override func update(_ currentTime: TimeInterval) {
        if(canPlant) {
            //show the can plant message, and hide the other buttons for the sake of convenience
            plant_button.isHidden = true
            rescue_water_button.isHidden = true
            planting_instructions_label.isHidden = false
        } else if(canWater) {
            //show the can watering message, and hide the other buttons for the sake of convenience
            self.plant_button.isHidden = true
            self.rescue_water_button.isHidden = true
            self.planting_instructions_label.isHidden = true
            self.watering_instructions_label.isHidden = false
        } else {
            //make sure that all of the other buttons are still able to be shown.
            planting_instructions_label.isHidden = true
            plant_button.isHidden = false
            rescue_water_button.isHidden = false
        }
    }
    
    func updateWaterBottles() {
        print("In update water bottles")
        //clear original given array and remove all of the showing bottles from the screen
        for i in 1...10 {
            var water_bottle: SKSpriteNode = self.childNode(withName: "//water_bottle_\(i)") as! SKSpriteNode
            water_bottle.isHidden = true
            if(i <= forestDataManager.getBottles().getNumberOfBottles()) {
                water_bottle.isHidden = false
            } else {
                water_bottle.isHidden = true
            }
        }
        print("Balance is \(forestDataManager.getBottles().getNumberOfBottles())")
        Forest.num_water_bottles = forestDataManager.getBottles().getNumberOfBottles()
        print(Forest.num_water_bottles)
    }
    
    func startPlantingProcess(type: Int) {
        //update the number of water bottles on the screen, taking into account the recent purchase of a new plant
        self.updateWaterBottles()
        self.canPlant = true
        self.typeOfTree = type
    }
    
    func updateTheHealthOfTrees(array: [Plant]) {
        
        let calendar = NSCalendar.current
        print("HI in update health of trees")
        for i in 0..<self.tree_array.count {
            //calculating the time in days between now and the last time the plant was watered to determine if the plant needs to be watered.
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: self.tree_array[i].getLastWateredDate())
            let date2 = calendar.startOfDay(for: Date())
            
            //let components = calendar.dateComponents([.day], from: date1, to: date2)
            let difference = date2.timeIntervalSince(date1)
            //converts the seconds to days
            print((difference / 86400))
            if(difference >= 1.0) {
                //it has been more than one day since the plant was watered and that is bad. The plant needs to go into a dying state until it is rewatered. 
                
                //depending on the original shape of the plant we need to choose a different dead tree form
                if(self.tree_array[i].getPlantType() == 1 || self.tree_array[i].getPlantType() == 3 || self.tree_array[i].getPlantType() == 4 || self.tree_array[i].getPlantType() == 5) {
                    self.tree_array[i].texture = SKTexture(imageNamed: "deadtree_short")
                } else {
                    self.tree_array[i].texture = SKTexture(imageNamed: "deadtree_tall")
                }
            } else {
                //the time difference is less than 1 day so we need to keep the original texture
                var type = self.tree_array[i].getPlantType()
                var texture = SKTexture(imageNamed: "tree_1")
                if(type == 1) {
                    // Make a texture from an image, a color, and size
                    texture = SKTexture(imageNamed: "tree_1")
                } else if(type == 2){
                    texture = SKTexture(imageNamed: "tree_2")
                } else if(type == 3) {
                    texture = SKTexture(imageNamed: "tree_3")
                } else if(type == 4) {
                    texture = SKTexture(imageNamed: "tree_4")
                } else if(type == 5) {
                    texture = SKTexture(imageNamed: "tree_5")
                } else if(type == 6) {
                    texture = SKTexture(imageNamed: "tree_6")
                }
                
                self.tree_array[i].texture = texture
            }
        }
    }

    
    func initialize_buttons() {
        
        plant_button = self.childNode(withName: "//plant_image") as! MSButtonNode
        
        rescue_water_button = self.childNode(withName: "//rescue_water_image") as! MSButtonNode
        
        background_of_forest = self.childNode(withName: "//forest_background")
        
        button_x = self.childNode(withName: "//button_x") as! MSButtonNode
        
        planting_instructions_label = self.childNode(withName: "//planting_instructions")!
        
        watering_instructions_label = self.childNode(withName: "//watering_instructions")!
        //as soon as this label it needs to be hidden until someone decides to water their plants.
        watering_instructions_label.isHidden = true
    }
    
    func button_action_callbacks() {
        plant_button.selectedHandler = { [weak self] in
            self?.launchBuyFragment()
            print("planting plants")
        }
        
        rescue_water_button.selectedHandler = { [weak self] in
            print("rescuing water")
            self?.loadLevelSelect()
        }
        
        button_x.selectedHandler = { [weak self] in
            print("Exiting the fragment")
            self?.destroyBuyFragment()
        }
    }
    
    func setDefaultButtonVisibilityState() {
        button_x.isHidden = true
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        didScroll = false
        
    }
    
    func drawSavedTrees(array: [Plant]) {
        
        for element in array {
            self.addChild(element)
            element.position = CGPoint(x: element.getX(), y: element.getY())
            print("added to screen")
        }
        
        
    }
    
    func plant(at: CGPoint) {
        var plant: Plant = Plant(type: typeOfTree, x_position: at.x, y_position: at.y, date_last_watered: Date())
        plant.position = at
        self.addChild(plant)
        self.canPlant = false
        tree_array.append(plant)
        forestDataManager.saveArrayOfTrees(array: self.tree_array)
        self.tree_array = forestDataManager.getTreesAsPlantObjectArray()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!didScroll) {
            //touch occurred
            if(self.canPlant) {
                let touch = touches.first!
                let location = touch.location(in: self)
                print(location)
                print("You are going to plant in this location")
                plant(at: location)
            }
            else if(self.canWater) {
                let touch = touches.first!
                let location = touch.location(in: self)
                print(location)
                self.canWater = false
                self.watering_instructions_label.isHidden = true
                if(self.forestDataManager.getBottles().getNumberOfBottles() <= 0) {
                    print("Not enough water to water the plants")
                    return
                }
                //check if they tapped on a plant
                //if they tapped on a plant decrement 1 from the amount of water they have
                for i in 0..<self.tree_array.count {
                    if(self.tree_array[i].contains(location)) {
                        print("Watering a plant I just touched")
                        self.tree_array[i].texture = SKTexture(imageNamed: "tree_1")
                        self.tree_array[i].setDateLastWatered(date: Date()) //set the date last watered to now, since I just watered the plant
                        //call update on the array of trees since our data has just changed!
                        updateTheHealthOfTrees(array: self.tree_array)
                        //need to clear the array in memory so that we don't end up with 2 exact same trees on screen one dead and one alive. This bug consumed many hours of my time!
                        forestDataManager.nukeTreeArray()
                        //save the new replenished tree to storage so that when we open the game again the tree shows up as healthy
                        forestDataManager.saveArrayOfTrees(array: self.tree_array)
                        self.tree_array = forestDataManager.getTreesAsPlantObjectArray()
                        
                        //subtract 1 from the number of bottles that the player has, since watering plants uses up 1 water
                        self.forestDataManager.addBottleData(numBottles: Int(self.forestDataManager.getBottles().getNumberOfBottles()) - Int(1))
                        Forest.num_water_bottles = self.forestDataManager.getBottles().getNumberOfBottles()
                        updateWaterBottles()
                        
                        //break out since we already touched the plant, this reduces time complexity
                        break
                    }
                }
                    
            }
        }
    }


    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func showXButton() {
        button_x.isHidden = false
    }
    
    func hideXButton() {
        button_x.isHidden = true
    }
    
    func loadLevelSelect() {
        /* Grab reference to our SpriteKit view */
        guard let skView = self.view as SKView! else {
            print("Could not get Skview")
            return
        }
        
        /* Load Game scene */
        guard let scene = LevelSelect(fileNamed: "LevelSelect") else {
            print("Could not load Forest with level 1")
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(canScroll) {
            for touch in touches {
                let location = touch.location(in: self)
                let previousLocation = touch.previousLocation(in: self)
                let deltaX = previousLocation.x - location.x
                let deltaY = previousLocation.y - location.y
                if(abs(deltaX) > 1 || abs(deltaY) > 1) {
                    didScroll = true
                }
                let camPosX = forest_camera.position.x + deltaX
                forest_camera.position.x = clamp(value: camPosX,lower: -220,upper: 220)
                let camPosY = forest_camera.position.y + deltaY
                forest_camera.position.y = clamp(value: camPosY, lower: -300, upper: 300)
            }
        }
    }
    
    func launchBuyFragment() {
        let path = Bundle.main.path(forResource: "BuyPlants", ofType: "sks")
        let fragment = SKReferenceNode(url: URL (fileURLWithPath: path!))
        fragment.position = CGPoint(x: forest_camera.position.x , y: forest_camera.position.y)
        self.buy_fragment = fragment
        //pass the reference to self to the buy fragment so we can trigger button events that have an effect on the forest scene, such as decreasing the amount of $ or bottles that we have or starting the planting process.
        let buyPage = fragment.childNode(withName: "//BuyPlants") as! BuyPlants
        buyPage.setParentReference(ref: self)
        
        addChild(fragment)
        addBlurEffect()
        showXButton()
    }
    
    func destroyBuyFragment() {
        buy_fragment.removeAllChildren()
        buy_fragment.removeFromParent()
        hideXButton()
        removeBlurEffect()
        self.canScroll = true
    }
    
    func addBlurEffect() {
        // Create an effects node with a gaussian blur filter
        self.effects_node = SKEffectNode()
        let filter = CIFilter(name: "CIGaussianBlur")
        // Set the blur amount. Adjust this to achieve the desired effect
        let blurAmount = 10.0
        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        effects_node.filter = filter
        effects_node.position = self.view!.center
        effects_node.blendMode = .alpha
        
        
        // Add the sprite to the effects node. Nodes added to the effects node
        // will be blurred
        //remove the forest background as a child of the main view, so we can make it a child of the effects_node, this way it will have the blur effect
        self.background_of_forest.removeFromParent()
        self.plant_button.removeFromParent()
        self.rescue_water_button.removeFromParent()
        
        //Add the forest background, and the forest buttons as a child of the effect_node so they will have the blur effect applied to them
        self.effects_node.addChild(self.background_of_forest)
        self.effects_node.addChild(self.plant_button)
        self.effects_node.addChild(self.rescue_water_button)
        
        
        //Loop over all of the children recursively which have name water_bottle and blur all of them by adding them as children to the effect_node
        self.enumerateChildNodes(withName: "//water_bottle") {
            node, stop in
            let bottle = node as! SKSpriteNode
            bottle.isHidden = true
            bottle.removeFromParent()
            //self.effects_node.addChild(bottle)
        }
        
        
        // Add the effects node to the scene
        self.addChild((effects_node)!)
        
        //disable the user from scrolling around the screen while it is blurred
        self.canScroll = false
    }
    func removeBlurEffect() {
        //remove all of the buttons and backgrounds from the effects node
        self.effects_node.removeAllChildren()
        //add all of the backgrounds and the buttons we removed from the parent view, so they will be displayed back on the screen, after being removed from the
        self.addChild(self.background_of_forest)
        self.forest_camera.addChild(self.plant_button)
        self.forest_camera.addChild(self.rescue_water_button)
        
        //placed again here to prevent a crash, in the unlikely event that bottles is greater than 10
        //cap the maximum water you can have at any time to 10 water bottles
        if(Forest.num_water_bottles > 10) {
            Forest.num_water_bottles = 10
            forestDataManager.addBottleData(numBottles: Forest.num_water_bottles)
        }
        
        for i in 0..<Forest.num_water_bottles {
            //self.forest_camera.addChild(arrayOfBottles[i])
            if(i < Forest.num_water_bottles) {
                arrayOfBottles[i].isHidden = false
            } else {
                arrayOfBottles[i].isHidden = true
            }
        }
        
        effects_node.shouldEnableEffects = false
        
        //allow the user to pan around the screen again
        self.canScroll = false

    }
    
    deinit {
        print("De init Forest page")
    }
    
    func initiateWaterProcess() {
        self.canWater = true
    }

}
