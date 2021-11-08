//
//  LoginViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 12/25/19.
//  Copyright © 2019 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var accounView: UIButton!
    
    @IBOutlet weak var catButton: UIButton!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var catImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var videoButton: UIButton!
    
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        setUpElements()
        print("stup: \(Utilities.globalVariables.sendToUpdatePassword)")
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        if Utilities.globalVariables.sendToUpdatePassword == true {
            let alert = UIAlertController(title: "Update Password", message: "Login to your account again to change your password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (UIAct) in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func setUpElements(){
        self.loginLabel.textColor = .black
        Utilities.styleOrangeTextField(self.emailTextField)
        Utilities.styleOrangeTextField(self.passwordTextField)
        Utilities.styleOrangeButton(self.submitButton)
        self.errorLabel.alpha = 0
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil{
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }else{
                if Utilities.globalVariables.sendToUpdatePassword == false {
                    self.transitionToAccountScreen()
                }else{
                    Utilities.globalVariables.sendToUpdatePassword = false
                    self.transitionToUpdatePasswordScreen()
                }
            }
        }
        
    }
    
    @IBAction func accountButtonTapped(_ sender: Any) {
    }
    func transitionToAccountScreen(){
        let accountViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.accountViewController) as? AccountViewController
        view.window?.rootViewController = accountViewController
        view.window?.makeKeyAndVisible()
    }
    func transitionToUpdatePasswordScreen(){
        let updatePasswordVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.updatePasswordViewController) as? updatePasswordViewController
        view.window?.rootViewController = updatePasswordVC
        view.window?.makeKeyAndVisible()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
    }
}
