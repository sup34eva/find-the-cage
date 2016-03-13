//
//  ReplaceSegue.swift
//  Find the Cage
//
//  Created by Supinfo on 13/03/16.
//  Copyright © 2016 Ascenceur. All rights reserved.
//

import UIKit

@objc(ReplaceSegue)
class ReplaceSegue : UIStoryboardSegue {
    override func perform() {
        let src = self.sourceViewController
        let dest = self.destinationViewController
        let nav = src.navigationController!
        
        nav.popToRootViewControllerAnimated(false)
        nav.pushViewController(dest, animated: true)
    }
}