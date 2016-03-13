//
//  ReplaceSegue.swift
//  Find the Cage
//
//  Copyright © 2016 Ascenceur. All rights reserved.
//

import UIKit

// Transition customisée pour remplacer la vue actuelle dans la pile de navigation
@objc(ReplaceSegue)
class ReplaceSegue : UIStoryboardSegue {
    override func perform() {
        let src = self.sourceViewController
        let dest = self.destinationViewController
        let nav = src.navigationController!

        // Retourne a la vue initiale sans transition
        nav.popToRootViewControllerAnimated(false)

        // Ajoute la nouvelle vue a la pile
        nav.pushViewController(dest, animated: true)
    }
}
