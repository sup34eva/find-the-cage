//
//  GameViewController.swift
//  Find the Cage
//
//  Created by Supinfo on 15/02/16.
//  Copyright © 2016 Ascenceur. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var imageID: Int = 0
    var isLocked: Bool = false
    var timer: NSTimer? = nil
    var startTime: Double = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image: UIImage
        if arc4random_uniform(2) == 0 {
            image = UIImage(named: "photo1")!
        } else {
            image = UIImage(named: "photo2")!
            imageID = 1
        }

        imageView.image = image
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
        
        scrollView.contentSize = image.size
    }
    
    override func viewDidAppear(animated: Bool) {
        timer = NSTimer(timeInterval: 0.1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    override func viewDidDisappear(animated: Bool) {
        if timer != nil {
            timer!.invalidate()
        }
    }
    
    func updateTimer() {
        let currentTime = Float(NSDate.timeIntervalSinceReferenceDate() - startTime)
        if timerLabel != nil {
            timerLabel.text = "Time: \(currentTime)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onTap(recognizer: UITapGestureRecognizer) {
        if isLocked {
            return
        }
        
        let location = recognizer.locationInView(imageView)
        if  (
                imageID == 0 &&
                location.x >= 615 &&
                location.x <= 635 &&
                location.y >= 645 &&
                location.y <= 670
            ) || (
                imageID == 1 &&
                location.x >= 1140 &&
                location.x <= 1165 &&
                location.y >= 315 &&
                location.y <= 355
            ) {
            win()
        } else {
            lock()
        }
    }
    
    func win() {
        if timer != nil {
            timer!.invalidate()
        }
        
        let currentTime = Float(NSDate.timeIntervalSinceReferenceDate() - startTime)

        let alert = UIAlertController(title: "C'est gagné !", message: "Vous avez trouvé le Cage en \(currentTime) secondes.", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (_) in
            let nameField = alert.textFields![0] as UITextField

            Score.saveScore(Score(name: nameField.text!, time: currentTime))
            self.performSegueWithIdentifier("endGame", sender: nil)
        })
        
        alert.addTextFieldWithConfigurationHandler({ (field) in
            field.placeholder = "Nom"
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: field, queue: NSOperationQueue.mainQueue()) { (notification) in
                saveAction.enabled = field.text != ""
            }
        })
        
        alert.addAction(saveAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func lock() {
        isLocked = true
        
        imageView.alpha = 0.4
        
        performSelector("unlock", withObject: nil, afterDelay: 2)
    }
    
    func unlock() {
        imageView.alpha = 1
        
        isLocked = false
    }
}
