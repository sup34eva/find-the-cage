//
//  Score.swift
//  Find the Cage
//
//  Created by Supinfo on 13/03/16.
//  Copyright © 2016 Ascenceur. All rights reserved.
//

import Foundation

class Score: NSObject, NSCoding {
    var name: String = ""
    var time: Float = 0
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("highscores")
    
    init(name: String, time: Float) {
        self.name = name
        self.time = time
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        time = aDecoder.decodeFloatForKey("time")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeFloat(time, forKey: "time")
    }
    
    static func saveScore(score: Score) {
        var scores: [Score] = []
        if let savedScores = loadScores() {
            scores = savedScores
        }
        
        scores.append(score)
        let newScores = Array(scores.sort({ $0.time < $1.time }).prefix(10))
        
        let success = NSKeyedArchiver.archiveRootObject(newScores, toFile: Score.ArchiveURL.path!)
        if !success {
            print("Failed to save score...")
        }
    }
    
    static func loadScores() -> [Score]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Score.ArchiveURL.path!) as? [Score]
    }
}