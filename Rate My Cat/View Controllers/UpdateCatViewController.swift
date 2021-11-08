//
//  UpdateCatViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 2/6/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UpdateCatViewController: UIViewController {
    
    @IBOutlet weak var updateCatLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        self.errorLabel.alpha = 0
        super.viewDidLoad()
        Utilities.styleOrangeButton(self.submitButton)
        Utilities.styleOrangeTextField(self.ageTextField)
        Utilities.styleOrangeTextField(self.nameTextField)
        var currentCat = Utilities.globalVariables.currenAccountCat
        let oldName = currentCat.getName()
        let oldAge = currentCat.getAge()
        nameTextField.text = oldName
        ageTextField.text = "\(oldAge)"
        let urls = URL(string: currentCat.getURL())!
        self.imageView.image = Utilities.globalVariables.currentAccountCatImage
        self.activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        return true
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        var currentCat = Utilities.globalVariables.currenAccountCat
        let oldName = currentCat.getName()
        let oldAge = currentCat.getAge()
        let newName = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let newAge = ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if newName != nil && newName != oldName && newAge != nil && newAge != "\(oldAge)"{
            print("updating both")
            updateBoth(name: newName, age: newAge!)
        }else if newName != nil && newName != oldName{
            print("updating name")
            updateName(name: newName)
        }else if newAge != nil && newAge != "\(oldAge)"{
            print("updating age")
            updateAge(age: newAge!)
        }else{
            var alert = UIAlertController(title: "Update Cat", message: "You've made no changes.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAct) in
                self.transitionToAccountScreen()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func updateName(name : String){
        let id : String = Utilities.globalVariables.currenAccountCat.getCID()
        db.collection("cats").document(id).updateData(["name" : name]) { (err) in
            if err != nil{
                self.showError(error: err!.localizedDescription)
                print(err?.localizedDescription)
            }else{
                Utilities.globalVariables.justAddedCat = true
                self.transitionToAccountScreen()
            }

        }
    }
    func updateAge(age : String){
        let id : String = Utilities.globalVariables.currenAccountCat.getCID()
        db.collection("cats").document(id).updateData(["age" : Int(age)!])
        self.navigationController?.popViewController(animated: false)
           db.collection("cats").document(id).updateData(["age" : Int(age)]) { (error) in
                    if error != nil{
                        self.showError(error: error!.localizedDescription)
                    }else{
                        Utilities.globalVariables.justAddedCat = true
                        self.transitionToAccountScreen()
                    }

                }
        
    }
    func updateBoth(name : String, age : String){
        let id : String = Utilities.globalVariables.currenAccountCat.getCID()
        let agg = Int(age)!
        db.collection("cats").document(id).updateData(["name" : name, "age" : agg]) { (error) in
            if error != nil{
                self.showError(error: error!.localizedDescription)
            }else{
                Utilities.globalVariables.justAddedCat = true
                self.transitionToAccountScreen()
            }
        }

    }
    func showError(error: String){
        self.errorLabel.alpha = 1
        self.errorLabel.text = error
    }
    
    
       func transitionToAccountScreen(){
           let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
           if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "AccountVC") as? AccountViewController {
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
