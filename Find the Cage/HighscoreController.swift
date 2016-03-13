//
//  HighscoreController.swift
//  Find the Cage
//
//  Copyright © 2016 Ascenceur. All rights reserved.
//

import UIKit

// Controlleur de la vue de Highscore
class HighscoreController: UITableViewController {
    var scores = [Score]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedScores = Score.loadScores() {
            scores += savedScores
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Retourne le nombre de sections de la table
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // Le compte est constant, il n'y a qu'une seule section
    }

    // Retourne le nombre de scores de la table
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }

    // Retourne une cellule de la table
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Récupère une cellule inutilisée
        let cell = tableView.dequeueReusableCellWithIdentifier("ScoreID", forIndexPath: indexPath)

        // Récupère le score demandé
        let score = scores[indexPath.row]

        // Initialise la cellule
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "\(score.time)s"

        // Retourne la vue initialisée
        return cell
    }
}
