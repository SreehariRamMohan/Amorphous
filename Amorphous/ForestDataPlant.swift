//
//  ForestData.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/28/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import Foundation
import Foundation
import SpriteKit
class ForestDataItem: NSObject, NSCoding{
    
    var x: CGFloat!
    var y: CGFloat!
    var plant_type: Int!
    
    
    init(plant_type: Int, x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
        self.plant_type = plant_type
    }
    
    required init(coder: NSCoder) {
        self.x = coder.decodeObject(forKey: "x") as! CGFloat
        self.y = coder.decodeObject(forKey: "y") as! CGFloat
        self.plant_type = coder.decodeObject(forKey: "plant_type") as! Int
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(self.x, forKey: "x")
        coder.encode(self.y, forKey: "y")
        coder.encode(self.plant_type, forKey: "plant_type")

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.x, forKey: "x")
        aCoder.encode(self.y, forKey: "y")
        aCoder.encode(self.plant_type, forKey: "plant_type")
    }
    
    func getX() -> CGFloat {
        return x
    }
    
    func getY() -> CGFloat {
        return y
    }
    
    func getPlantType() -> Int {
        return plant_type
    }
}
