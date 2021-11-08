//
//  updatePasswordViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 6/9/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class updatePasswordViewController: UIViewController {

    @IBOutlet weak var navBarImageView: UIImageView!
    
    @IBOutlet weak var catButton: UIButton!
    
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var updatePasswordLabel: UILabel!
    
    @IBOutlet weak var catIconImageView: UIImageView!
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet var swipeBackRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        Utilities.styleOrangeButton(self.submitButton)
        Utilities.styleBlackTextField(self.newPasswordTextField)
        Utilities.styleBlackTextField(self.repeatPasswordTextField)
        self.errorLabel.alpha = 0
        self.errorLabel.textColor = .red
    }
    func validatePassword(newPass : String, repeatNewPass : String) -> String {
        if newPass != repeatNewPass {
            return "Passwords must match"
        }
        else if newPass.count < 6 {
            return "New password must be at least 6 characters long"
        }
        else {
            return ""
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        newPasswordTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        textFieldShouldReturn(self.newPasswordTextField)
        textFieldShouldReturn(self.repeatPasswordTextField)
        let errorMaybe = validatePassword(newPass: self.newPasswordTextField.text ?? "", repeatNewPass: self.repeatPasswordTextField.text ?? "")
        if errorMaybe != "" {
            showError(error: errorMaybe)
        }else{
            Auth.auth().currentUser?.updatePassword(to: self.newPasswordTextField.text ?? "", completion: { (err) in
                if err != nil {
                    self.showError(error: err?.localizedDescription ?? "There was an error updating your password. Please try again later")
                }else{
                    let alert = UIAlertController(title: "Update Password", message: "Your password was successfully updated", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (UIAct) in
                        self.transitionToAccountViewController()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        
    }
    
    func showError(error : String){
        self.errorLabel.alpha = 1
        self.errorLabel.text = error
    }
    
    func transitionToAccountViewController(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
             if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AccountVC") as? ReportViewController {
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
