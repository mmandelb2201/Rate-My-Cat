//
//  SignUpViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 12/25/19.
//  Copyright © 2019 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signUpButton: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var catCopyImageView: UIImageView!
    
    @IBOutlet weak var selectBoxLablel: UILabel!
    
    @IBOutlet weak var termsOfServiceButton: UIButton!
    
    @IBOutlet weak var checkBox: UIButton!
    
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var catButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var backButtoin: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
   
    @IBOutlet weak var backButton: UIButton!
    
    var isPremium : Bool = false
    var isCheckBoxSelected : Bool = false
    var selectedImage : UIImage = UIImage()
    var unselectedImage : UIImage = UIImage()
   
    override func viewDidLoad() {
        self.selectedImage = UIImage(named: "checkBoxSelected")!
        self.unselectedImage = UIImage(named: "checkBoxUnselected")!
        view.backgroundColor = .white
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    func setUpElements(){
        self.selectBoxLablel.textColor = .black
        self.signUpButton.textColor = .black
        errorLabel.alpha = 0
        Utilities.styleOrangeTextField(self.usernameTextField)
        Utilities.styleOrangeTextField(self.emailTextField)
        Utilities.styleOrangeTextField(self.passwordTextField)
        Utilities.styleWhiteButton(self.submitButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func validateFields() -> String? {
        if self.isCheckBoxSelected == false{
            return "Please select the check box to agree to our terms of use"
        }
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.count < 6{
            return "Please make your password is at least 7 characters"
        }
        let usered = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if usered!.count > 11{
            return "Username cannot be more than 10 characters"
        }
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let charset = CharacterSet(charactersIn: "@")
        if email.rangeOfCharacter(from: charset) == nil{return "Please add a real email"}
        let charsett = CharacterSet(charactersIn: ".")
        if email.rangeOfCharacter(from: charsett) == nil{return "Please add a real email"}
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        //validate fields
        let error = validateFields()
        
        if error != nil{
                showError(error!)
        }else{
            let userName = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                //check for errors
                if err != nil{
                    self.showError(err!.localizedDescription)
                }else{
                    print("username: \(userName)")
                    print("uid \(result!.user.uid)")
                    let db = Firestore.firestore()
                    /*db.collection("users").document(result!.user.uid).setData(["username" : userName,"uid" : result!.user.uid,"hasCat" : false, "catImageURL" : "nothing"]) */
                    db.collection("users").document(result!.user.uid).setData(["username" : userName,"uid" : result!.user.uid,"hasCat" : false, "catImageURL" : "nothing","isMod" : false,"numberOfCats":0,"isPremium":false,"numberOfMeanReports":0,"numberOfNameReports":0,"numberOfImageReports":0]) { (error) in
                        if error == nil{
                            self.transitionToNewScreen()
                        }  
                    }
                }
            }
            // Handle Errors here.

        }
        //create user
        //transition to home screen
        
    }
    func createUser(usr : String, id : String){
        let db = Database.database().reference()
        db.child("users").child(id).setValue(["username" : usr])
        db.child("users").child(id).setValue(["uid" : id])

    }
    
    @IBAction func checkBoxTapped(_ sender: Any) {
        self.toggleCheckBox()
    }
    
    func toggleCheckBox(){
        if self.isCheckBoxSelected == true{self.isCheckBoxSelected = false
            self.checkBox.setImage(self.unselectedImage, for: .normal)
        }
        else{self.isCheckBoxSelected = true
            self.checkBox.setImage(self.selectedImage, for: .normal)
        }
        print("\(self.isCheckBoxSelected)")
    }
    
    func showError(_ message:String){
        errorLabel.alpha = 1
        errorLabel.text = message}
    func transitionToAccountScreen(){
       let accountViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.accountViewController) as? AccountViewController
        accountViewController?.viewDidLoad()
        view.window?.rootViewController = accountViewController
        view.window?.makeKeyAndVisible()
    }
    func transitionToNewScreen(){
        let accountViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.newCatViewController) as? NewCatViewController
         accountViewController?.viewDidLoad()
         view.window?.rootViewController = accountViewController
         view.window?.makeKeyAndVisible()
     }
}
