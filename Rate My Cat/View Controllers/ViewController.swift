//
//  ViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 12/25/19.
//  Copyright © 2019 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseCrashlytics

class ViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var startRatingButton: UIButton!
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        Utilities.globalVariables.accountViewCats.removeAll()
        Utilities.globalVariables.accountViewCatsImages.removeAll()
        Utilities.globalVariables.accountUsername = ""
        Utilities.globalVariables.videoIndex = 0
        Utilities.globalVariables.videos.removeAll()
        self.activityIndicator.startAnimating()
        super.viewDidLoad()
        if Utilities.globalVariables.isFirstLaunch == false {
            self.transitionToCatScreen()
        }else{
            self.transitionToCatScreen()
        }
        Firestore.firestore().collection("announcements").document("1").getDocument { (snapshot, err) in
            if err != nil{
                print(err?.localizedDescription)
            }else{
                let displayAnnouncement : Bool = snapshot?.get("displayAnnouncement") as! Bool
                if displayAnnouncement == true{
                    self.startRatingButton.alpha = 1
                }else{
                    //self.transitionToCatScreen()
                }
            }
        }
        
    }
    
    func display(url : String){
        let urled = URL(string: url)!
        imageView.downloadImage(from: urled, actv: self.activityIndicator, imgV: self.imageView, rmv: false, finished: {
            print("completed")
        })
    }
    
    func transitionToCatScreen(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
             if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CatViewController") as? CatViewController {
                 self.present(viewController, animated: true, completion: nil)
                 viewController.reloadInputViews()
             }
    }
    
    @IBAction func startRatingButtonTapped(_ sender: Any) {
        transitionToCatScreen()
    }
    
}

