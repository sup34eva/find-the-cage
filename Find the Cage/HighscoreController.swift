//
//  HighscoreController.swift
//  Find the Cage
//
//  Created by Supinfo on 13/03/16.
//  Copyright © 2016 Ascenceur. All rights reserved.
//

import UIKit

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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ScoreID", forIndexPath: indexPath)
        let score = scores[indexPath.row]
        
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "\(score.time)s"
        
        return cell
    }
}
