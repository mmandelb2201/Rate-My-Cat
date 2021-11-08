//
//  ForgotPasswordViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 6/11/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var navBarTexture: UIImageView!
    
    @IBOutlet weak var catButton: UIButton!
    
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var catIconImageView: UIImageView!
    
    @IBOutlet weak var pleaseEnterLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet var swipeBack: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements() {
        Utilities.styleOrangeButton(self.submitButton)
        Utilities.styleBlackTextField(self.emailTextField)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        textFieldShouldReturn(self.emailTextField)
        if self.emailTextField.text == nil {
            self.errorLabel.text = "Please enter your email in the text field"
        }else{
            let email = self.emailTextField.text ?? ""
            Auth.auth().sendPasswordReset(withEmail: email) { (err) in
                if err != nil {
                    self.errorLabel.text = err?.localizedDescription
                }else{
                    let alert = UIAlertController(title: "Forgot Password", message: "The email was successfully sent", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (UIAct) in
                        self.transitionToLogin()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    func transitionToLogin(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController {
            self.present(viewController, animated: true, completion: nil)
            viewController.reloadInputViews()
        }
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
