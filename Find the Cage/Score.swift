//
//  Score.swift
//  Find the Cage
//
//  Copyright © 2016 Ascenceur. All rights reserved.
//

import Foundation

// Représente un score dans les sauvegardes
class Score: NSObject, NSCoding {
    // Le nom du joueur
    var name: String = ""
    // Le temps écoulé durant la partie
    var time: Float = 0

    // L'emplacement de la sauvegarde
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("highscores")

    // Initialiseur simple
    init(name: String, time: Float) {
        self.name = name
        self.time = time
    }

    // Initialiser utilisé pour la déserialization
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        time = aDecoder.decodeFloatForKey("time")
    }

    // Fonction de sérialization
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeFloat(time, forKey: "time")
    }

    // Sauvegarde un score
    static func saveScore(score: Score) {
        // Récupère la liste des scores actuels
        var scores: [Score] = []
        if let savedScores = loadScores() {
            scores = savedScores
        }

        // Ajoute le nouveau score
        scores.append(score)
        // Trie les scores selon leur temps et ne garde que les 10 premiers
        let newScores = Array(scores.sort({ $0.time < $1.time }).prefix(10))

        // Sauvegarde la nouvelle liste des scores
        let success = NSKeyedArchiver.archiveRootObject(newScores, toFile: Score.ArchiveURL.path!)
        if !success {
            print("Failed to save score...")
        }
    }

    // Charge la liste des scores
    static func loadScores() -> [Score]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Score.ArchiveURL.path!) as? [Score]
    }
}
