//
//  GameViewController.swift
//  Find the Cage
//
//  Created by Supinfo on 15/02/16.
//  Copyright © 2016 Ascenceur. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var isLocked: Bool = false
    var timer: NSTimer? = nil
    var startTime: Double = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image: UIImage = UIImage(named: "photo1")!

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
        if  location.x >= 615 &&
            location.x <= 635 &&
            location.y >= 645 &&
            location.y <= 670 {
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
        
        let alert = UIAlertController(title: "C'est gagné !", message: "Vous avez trouvé le Cage en \(currentTime) secondes.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }))
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
