//
//  WaterBottleData.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/27/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
class WaterBottleData: NSObject, NSCoding{
    
    var bottle_balance: Int!
    
    init(bottle_balance: Int) {
        self.bottle_balance = bottle_balance
    }
    
    required init(coder: NSCoder) {
        self.bottle_balance = coder.decodeObject(forKey: "bottles") as! Int
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(self.bottle_balance, forKey: "bottles")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.bottle_balance, forKey: "bottles")
    }
    
    func getNumberOfBottles() -> Int {
        return bottle_balance
    }
}
