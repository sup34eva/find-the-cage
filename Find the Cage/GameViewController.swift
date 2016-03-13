//
//  GameViewController.swift
//  Find the Cage
//
//  Copyright © 2016 Ascenceur. All rights reserved.
//

import UIKit

// Controleur pour la vue de jeu
class GameViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    // ID de l'image choisie (0 ou 1)
    var imageID: Int = 0
    // Flag de l'état courant de l'image (verrouillée ou pas)
    var isLocked: Bool = false
    // Timer utilisé pour mettre a jour l'affichage
    var timer: NSTimer? = nil
    // Timestamp de début de la partie
    var startTime: Double = 0

    // Elements l'affichage
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Selection alétoire de l'image
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
        // Démarage du timer
        timer = NSTimer(timeInterval: 0.1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)

        // Sauvegarde du timestamp courant
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }

    override func viewDidDisappear(animated: Bool) {
        // Supprime le timer lorsque la vue est quittée
        if timer != nil {
            timer!.invalidate()
        }
    }

    // Fonction appelée par le timer a chaque mise a jour
    func updateTimer() {
        // Calcule le temps écoulé depuis le début de la partie
        let currentTime = Float(NSDate.timeIntervalSinceReferenceDate() - startTime)

        // Vérifie que le label du timer est initialsé avant de le mettre a jour
        if timerLabel != nil {
            timerLabel.text = "Time: \(currentTime)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Appelé lors d'un clic sur l'image
    @IBAction func onTap(recognizer: UITapGestureRecognizer) {
        // Si l'image est verrouillée, ignore le clicl
        if isLocked {
            return
        }

        // Récupère la position du clic et vérifie si il se trouve sur Cage
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

    // Lorsque le joueur a cliqué sur Cage
    func win() {
        // Arrète le timer
        if timer != nil {
            timer!.invalidate()
        }

        // Calcule le score final
        let currentTime = Float(NSDate.timeIntervalSinceReferenceDate() - startTime)

        // Crée une boite de dialogue
        let alert = UIAlertController(title: "C'est gagné !", message: "Vous avez trouvé le Cage en \(currentTime) secondes.", preferredStyle: .Alert)

        // Crée une action permettant de valider
        let saveAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (_) in
            let nameField = alert.textFields![0] as UITextField

            // Sauvegarde le score, puis affiche l'écran de highscore
            Score.saveScore(Score(name: nameField.text!, time: currentTime))
            self.performSegueWithIdentifier("endGame", sender: nil)
        })

        // Ajoute un champ de texte a l'alerte pour entrer un nom
        alert.addTextFieldWithConfigurationHandler({ (field) in
            field.placeholder = "Nom"

            // Detecte les modifications du nom et active la sauvegarde si le nom n'est pas vide
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: field, queue: NSOperationQueue.mainQueue()) { (notification) in
                saveAction.enabled = field.text != ""
            }
        })

        // Ajoute le bouton de sauvegarde a l'alerte, et l'affiche
        alert.addAction(saveAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // Lorsque le joueur a cliqué a coté de Cage
    func lock() {
        // Verrouille le jeu
        isLocked = true

        // Réduit l'opacité de l'image pour signifier visuellement que le jeu est bloqué
        imageView.alpha = 0.4

        // Attends 2 secondes avant de dévérouiller
        performSelector("unlock", withObject: nil, afterDelay: 2)
    }

    // Déverrouille le jeu
    func unlock() {
        // Rétablit l'opacité de l'image a 100%
        imageView.alpha = 1

        // Déverrouille effectivement le jeu
        isLocked = false
    }
}
