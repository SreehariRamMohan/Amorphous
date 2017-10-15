//
//  DataManager.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/25/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//
import Foundation
import SpriteKit
class DataManager {
    var scores:Array<GameData> = []
    var bottles: WaterBottleData!
    var forest_trees: Array<ForestDataItem> = []
    
    init() {
        // load existing high scores or set up an empty array
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as String
        var path = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("GameData.plist")
        let fileManager = FileManager.default
        
        // check if file exists
        if !fileManager.fileExists(atPath: path.absoluteString) {
            // create an empty file if it doesn't exist
            if let bundle = Bundle.main.path(forResource: "GameData", ofType: "plist") {
                    do{
                        try fileManager.copyItem(atPath: bundle, toPath: path.absoluteString)
                    }
                    catch {
                        print("Failed")
                    }
            }
        } else {
            //if the file path doesn't exist let's create an array full of 0's and initialize tha to scores
        
        }
        do {
        let rawData = try Data(contentsOf: path)
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
            let scoreArray: Any? = NSKeyedUnarchiver.unarchiveObject(with: rawData)
            self.scores = scoreArray as? [GameData] ?? [];
        } catch {
            
        }
        
        if(scores == nil || scores.count == 0) {
            //if the array we got back is empty or nil then we need to initialize a new one full of 0's since this is the first time the user is logging in
            for i in 0..<Level.NUMBER_OF_TOTAL_LEVELS {
                print("RUNNING")
                scores.append(GameData(level: i + 1, scoreForThatLevel: 0))
            }
        }
        
        //////////////////////////////////////SAVING FOR WATERBOTTLES BELOW////////////////////////////////////////////////
        
        
        path = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("WaterBottles.plist")
        // check if file exists
        if !fileManager.fileExists(atPath: path.absoluteString) {
            // create an empty file if it doesn't exist
            if let bundle = Bundle.main.path(forResource: "WaterBottles", ofType: "plist") {
                do{
                    try fileManager.copyItem(atPath: bundle, toPath: path.absoluteString)
                }
                catch {
                    print("Failed")
                }
            }
        } else {
            //if the file path doesn't exist let's create an array full of 0's and initialize tha to scores
            
        }
        do {
            let rawData = try Data(contentsOf: path)
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
            let bottlesRAW: Any? = NSKeyedUnarchiver.unarchiveObject(with: rawData)
            self.bottles = bottlesRAW as? WaterBottleData ?? nil;
            
            //the first time we run the code we will get nil, so lets assign the value of nil to 3 which is the default starting value
            
        } catch {
            
        }
        
        if(self.bottles == nil) {
            self.bottles = WaterBottleData(bottle_balance: 3)
        }
        
        
        //////////////////////////////////////SAVING FOR FOREST TREES BELOW////////////////////////////////////////////////

        path = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("ForestTrees.plist")
        
        // check if file exists
        if !fileManager.fileExists(atPath: path.absoluteString) {
            // create an empty file if it doesn't exist
            if let bundle = Bundle.main.path(forResource: "ForestTrees", ofType: "plist") {
                do{
                    try fileManager.copyItem(atPath: bundle, toPath: path.absoluteString)
                }
                catch {
                    print("Failed")
                }
            }
        } else {
            //if the file path doesn't exist let's create an array full of 0's and initialize tha to scores
            
        }
        do {
            let rawData = try Data(contentsOf: path)
            // do we get serialized data back from the attempted path?
            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
            let trees: Any? = NSKeyedUnarchiver.unarchiveObject(with: rawData)
            self.forest_trees = trees as? [ForestDataItem] ?? [];
        } catch {
            
        }
        
        if(self.forest_trees.count == 0) {
            print("EMPTY SINCE THIS IS THE FIRST TIME")
        }
        
        
    }
    
    
    
    func save() {
        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
        let saveData = NSKeyedArchiver.archivedData(withRootObject: self.scores)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array;
        let documentsDirectory = paths[0] as! String;
        let path = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("GameData.plist")
        do {
            try saveData.write(to: path)
        } catch {
            
        }
    }
    
    func saveBottles() {
        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
        let saveData = NSKeyedArchiver.archivedData(withRootObject: self.bottles)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array;
        let documentsDirectory = paths[0] as! String;
        let path = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("WaterBottles.plist")
        do {
            try saveData.write(to: path)
        } catch {
            
        }

    }
    
    func saveTrees() {
        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
        let saveData = NSKeyedArchiver.archivedData(withRootObject: self.forest_trees)
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as Array;
        let documentsDirectory = paths[0] as! String;
        let path = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("ForestTrees.plist")
        do {
            try saveData.write(to: path)
        } catch {
            
        }
    }
    
    // a simple function to add a new high score, to be called from your game logic
    // note that this doesn't sort or filter the scores in any way
    func addNewStar(level: Int, newScore:Int) {
        
        let newHighScore = GameData(level: level, scoreForThatLevel: newScore)
        if(self.scores[level-1] > newHighScore) {
            //do nothing since the existing score in our records is greater than the one we want to write. We don't want to save a lower score. We only want to keep a record of the highest score
        } else {
            //new score we are writing is higher than the existing one, so we do indeed want to write to storage.
            self.scores[level-1] = newHighScore
            self.save();
        }
    }
    
    func addBottleData(numBottles: Int) {
        let bottle = WaterBottleData(bottle_balance: numBottles)
        self.bottles = bottle
        self.saveBottles()
    }
    
    func saveArrayOfTrees(array: [Plant]) {
        for element in array {
            self.forest_trees.append(ForestDataItem(plant_type: element.getPlantType(), x: element.getX(), y: element.getY(), date_last_watered: element.getLastWateredDate()))
        }
        self.saveTrees()
    }
    
    func nukeTreeArray() {
        self.forest_trees.removeAll()
    }
    
    func getScores() -> [GameData] {
        print("Returning game data array")
        return scores
    }
    
    func getBottles() -> WaterBottleData {
        print("Returning bottle data from data manager")
        return self.bottles
    }
    
    func getTreesAsPlantObjectArray() -> [Plant] {
        print("Returning an array of PLANT's No need to convert")
        var arr: [Plant] = []
        for element in self.forest_trees {
            arr.append(Plant(type: element.getPlantType(), x_position: element.getX(), y_position: element.getY(), date_last_watered: element.getDateLastWatered()))
        }
        return arr
    }
    
    func getTreesAsForestDataObjectArray() -> [ForestDataItem] {
        return self.forest_trees
    }
}
