//
//  DataManager.swift
//  Amorphous
//
//  Created by Sreehari Ram Mohan on 7/25/17.
//  Copyright © 2017 Sreehari Ram Mohan. All rights reserved.
//

import Foundation
import SpriteKit
class GameData: NSObject, NSCoding{

    var star_level_score: Int!
    var level: Int!
    
    init(level: Int, scoreForThatLevel: Int) {
        self.star_level_score = scoreForThatLevel
        self.level = level
    }
    
    required init(coder: NSCoder) {
        self.star_level_score = coder.decodeObject(forKey: "score") as! Int
        self.level = coder.decodeObject(forKey: "level") as! Int
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(self.star_level_score, forKey: "score")
        coder.encode(self.level, forKey: "level")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.star_level_score, forKey: "score")
        aCoder.encode(self.level, forKey: "level")
    }
    
    func getScore() -> Int {
        return star_level_score
    }
}

extension GameData: Comparable {
    static func < (lhs: GameData, rhs: GameData) -> Bool {
        if lhs.star_level_score != rhs.star_level_score {
            return lhs.star_level_score < rhs.star_level_score
        } else {
            //the two have the same star level score so their is no need to overwrite
            return false
        }
    }
}
