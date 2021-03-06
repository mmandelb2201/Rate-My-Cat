//
//  secondSignInViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 1/4/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import UIKit

class secondSignInViewController: UIViewController {
    
    @IBOutlet weak var orSwipeTextFIeld: UILabel!
    
    @IBOutlet weak var pleaseSignInLabel: UILabel!
    
    @IBOutlet weak var catButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var videoButton: UIButton!
    
    func setUpElements(){
        self.orSwipeTextFIeld.textColor = .black
        self.pleaseSignInLabel.textColor = .black
        Utilities.styleOrangeButton(self.signUpButton)
        Utilities.styleWhiteButton(self.loginButton)
    }
    
    override func viewDidLoad() {
        setUpElements()
        Utilities.globalVariables.sendToUpdatePassword = false
        view.backgroundColor = .white
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func transitionToSignUp(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpViewController {
                self.present(viewController, animated: true, completion: nil)
                viewController.reloadInputViews()
        }
    }
    func transitionToCatScreen(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CatViewController") as? CatViewController {
                self.present(viewController, animated: true, completion: nil)
                viewController.reloadInputViews()
        }
    }
    func transitionToLogin(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
                self.present(viewController, animated: true, completion: nil)
                viewController.reloadInputViews()
        }
    }
    
    @IBAction func swipedRight(_ sender: Any) {
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
    }
    

}
