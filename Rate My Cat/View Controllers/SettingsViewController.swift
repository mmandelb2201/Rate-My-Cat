//
//  SettingsViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 1/11/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingLabel: UILabel!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var togglePushNotifications: UIImageView!
    
    @IBOutlet weak var toggleNotificationsLabel: UILabel!
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    @IBOutlet weak var catImageView: UIImageView!
    
    @IBOutlet weak var buttonBarImage: UIImageView!
    
    @IBOutlet weak var termsOfService: UIButton!
    
    @IBOutlet weak var catButton: UIButton!
    
    @IBOutlet weak var welcomeButton: UIButton!
    
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet weak var updatePasswordButton: UIButton!
    
    override func viewDidLoad() {
        setUpElements()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func welcomeTap(_ sender: Any) {
        print("welcome tapped")
        Utilities.globalVariables.isFirstLaunch = true
        self.transitionToCatScreen()
    }
    
    @IBAction func termsTapped(_ sender: Any) {
        print("terms tapped")
        self.transitionToTermsViewController()
    }
    
    func setUpElements(){
        settingLabel.textColor = .black
        Utilities.styleOrangeButton(self.welcomeButton)
        Utilities.styleWhiteButton(self.deleteAccountButton)
        Utilities.styleOrangeButton(self.signOutButton)
        Utilities.styleWhiteButton(self.termsOfService)
        Utilities.styleOrangeButton(self.updatePasswordButton)
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        Utilities.globalVariables.accountViewCats.removeAll()
        Utilities.globalVariables.accountViewCatsImages.removeAll()
        Utilities.globalVariables.accountUsername = ""
        Utilities.globalVariables.numberOfAccountCatImagesDownloaded = 0
        self.transitionToCatScreen()
        
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let id = Auth.auth().currentUser?.uid
        
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            Auth.auth().currentUser?.delete(completion: { (y) in
                if y != nil{print("\(y?.localizedDescription)")}
                else{
                    db.collection("users").document(id!).delete { (error) in
                        if error == nil{
                            Auth.auth().currentUser?.delete(completion: { (err) in
                                if err != nil{
                                }else{print("\(err?.localizedDescription)")}
                            })
                            
                        }else{print("\(error?.localizedDescription)")}
                    }
                    self.transitionToSecondSignInScreen()
                }
            })
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    func transitionToSecondSignInScreen(){
        let secondSignInViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.signInSecondViewController) as? secondSignInViewController
        view.window?.rootViewController = secondSignInViewController
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToCatScreen(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CatViewController") as? CatViewController {
            self.present(viewController, animated: false, completion: nil)
            viewController.reloadInputViews()
        }
        
    }
    func transitionToCatViewController(){
        let catVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.catViewController) as? CatViewController
        view.window?.rootViewController = catVC
        view.window?.makeKeyAndVisible()
    }
    func transitionToTermsViewController(){
        let termsVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.termsViewController) as? TermsViewController
        view.window?.rootViewController = termsVC
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func updatePasswordTapped(_ sender: Any) {
        Utilities.globalVariables.sendToUpdatePassword = true
        transitionToLoginScreen()
    }
    
    func transitionToLoginScreen(){
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
