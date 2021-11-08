//
//  NewCatViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 12/25/19.
//  Copyright © 2019 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage
import UIImageCropper

class NewCatViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var addNewCatLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var catButton: UIButton!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pickImageButton: UIButton!
    
    @IBOutlet weak var petTypePicker: UIPickerView!
    
    @IBOutlet weak var catIconImageView: UIImageView!
    
    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet weak var whatTypeLabel: UILabel!
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var picker = UIImagePickerController()
    var isModerator = false
    var numCats : Int = 0
    let db = Firestore.firestore()
    private let cropper = UIImageCropper(cropRatio: 18/25)
    let petTypes : [String] = ["Choose One","Cat", "Dog", "Bird", "Fish", "Horse", "Ferret", "Rabbit", "Snake", "Other"]
    var selectedPetType : String = "Choose One"
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        print("loeaded")
        /*  if let filePath = Bundle.main.path(forResource: "finalPI", ofType: "png"), let standardImage = UIImage(contentsOfFile: filePath) {
         if standardImage == nil{print("there was an error getting the image")}
         else{self.imageView.image = standardImage}
         }*/
        view.backgroundColor = .white
        setUpElements()
        super.viewDidLoad()
        //setup the cropper
        cropper.delegate = self
        //cropper.cropRatio = 2/3 //(can be set during runtime or in init)
        cropper.cropButtonText = "Crop" // this can be localized if needed (as well as the cancelButtonText
        // Do any additional setup after loading the view.
        petTypePicker.delegate = self
        petTypePicker.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return petTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.selectedPetType = petTypes[row]
        print(self.selectedPetType)
        return petTypes[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        return true
    }
    
    var catName : String = ""
    var age : Int = 0
    var ref = DatabaseReference.init()
    
    
    func setUpElements(){
        addNewCatLabel.textColor = .black
        errorLabel.alpha = 0
        self.nameTextField.returnKeyType = .done
        Utilities.styleOrangeTextField(self.nameTextField)
        Utilities.styleOrangeTextField(self.ageTextField)
        Utilities.styleWhiteButton(self.pickImageButton)
        Utilities.styleOrangeButton(self.submitButton)
        self.imageView.layer.borderWidth = 2
        self.imageView.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        self.submitButton.isUserInteractionEnabled = true
    }
    
    var hasPickedImage : Bool = false
    var imageUrl : String = ""
    
    @IBAction func pickImageTapped(_ sender: Any) {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == .authorized) {
            print("authorized")
            // Access has been granted.
            self.grabImage()
        }
        
        else if (status == .denied) {
            print("denied")
            // Access has been denied.
            var alert = UIAlertController(title: "Photo Library Access", message: "Rate My Pets needs photo library access to add a picture of your pet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Open Settings", style: UIAlertAction.Style.default, handler: { (UIAct) in
                if let url = URL(string:UIApplication.openSettingsURLString)
                
                { if UIApplication.shared.canOpenURL(url)
                
                { UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
                }
                
                }
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        else if (status == .notDetermined) {
            print("not determined")
            PHPhotoLibrary.requestAuthorization { (statusTwo) in
                if statusTwo == .authorized {
                    self.grabImage()
                }
            }
            
        }
        
        else if (status == .restricted) {
            print("restricted")
            PHPhotoLibrary.requestAuthorization { (statusTwo) in
                if statusTwo == .authorized {
                    self.grabImage()
                }
            }
            // Restricted access - normally won't happen.
        }
        // No crash
    }
    func grabImage(){
        DispatchQueue.main.async(execute: {
            self.cropper.picker = self.picker
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.popoverPresentationController?.sourceView = self.view
            alertController.popoverPresentationController?.sourceRect = CGRect(origin: self.view.center, size: CGSize.zero)
            
            self.cropper.cancelButtonText = "Cancel"
            
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: {
            })
        })
        
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        print("submit button tapped")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let catName = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let age = ageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let error = validateFields(nn: catName)
        if  error != nil{
            errorLabel.text = error
            self.errorLabel.alpha = 1
        }else{
            let user = Auth.auth().currentUser
            let uid = user?.uid
            let catImage = imageView.image
            let catImageData = jpegImage(image: catImage!, maxSize: 1500000, minSize: 200000, times: 10)
            if imageView.image == nil{
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Please add a picture of your cat"
                print("no image")
            }else if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Please fill in all fields"
                print("fill in all fields")
            }else if self.selectedPetType == "Choose One"{
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Please select the type of animal that you are adding"
                print("select animal type")
            }else{
                if catName != "" || age != ""{
                    let data = catImageData!
                    self.db.collection("users").document(uid!).getDocument { (snapshot, error) in
                        if error == nil{
                            let numberOfCats : Int = snapshot?.get("numberOfCats") as! Int
                            let temp = numberOfCats + 1
                            var rif : DocumentReference? = nil
                            rif = self.db.collection("cats").addDocument(data: ["name" :catName,"id":uid!,"age" : Int(age)!,"numberOfRatings":0,"averageRating": "0","numberOfReports":0,"parentID" : user?.uid, "numberOfLikes" : 0, "numberOfDislikes" : 0, "deviceTokenID" : Utilities.globalVariables.deviceTokenID, "type" : self.selectedPetType]) { err in
                                if let err = err{
                                    self.errorLabel.alpha = 1
                                    self.errorLabel.text = err.localizedDescription
                                    return
                                }else{
                                    print("added cat ok")
                                    let timp = rif!.documentID
                                    
                                    let storageRef = Storage.storage().reference().child("catImages").child("\(timp)")
                                    storageRef.putData(data, metadata: nil) { (metadata, error) in
                                        if error != nil{
                                            self.errorLabel.alpha = 1
                                            self.errorLabel.text = error as? String
                                            return
                                        }else{
                                            storageRef.downloadURL { (url, error) in
                                                let downloadURL = url
                                                print(downloadURL!.absoluteString)
                                                self.db.collection("cats").document(timp).updateData(["id" : rif!.documentID, "url" : downloadURL!.absoluteString]) { (errer) in
                                                    if errer == nil{
                                                        print("got to the end")
                                                        self.db.collection("users").document(uid!).updateData(["numberOfCats" : temp])
                                                        Utilities.globalVariables.justAddedCat = true
                                                        self.transitionAccountScreen()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            self.numCats = temp
                            
                        }
                        
                    }
                    navigationController?.popViewController(animated: true)
                    dismiss(animated: true, completion: nil)
                }
                else{
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = "Please fill in all fields"}
            }
        }
    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        print("submit button tapped")
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let catName = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let age = ageTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let error = validateFields(nn: catName)
        if  error != nil{
            errorLabel.text = error
            self.errorLabel.alpha = 1
        }else{
            let user = Auth.auth().currentUser
            let uid = user?.uid
            let catImage = imageView.image
            let catImageData = jpegImage(image: catImage!, maxSize: 1500000, minSize: 200000, times: 10)
            if imageView.image == nil{
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Please add a picture of your cat"
                print("no image")
            }else if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Please fill in all fields"
                print("fill in all fields")
            }else if self.selectedPetType == "Choose One"{
                self.errorLabel.alpha = 1
                self.errorLabel.text = "Please select the type of animal that you are adding"
                print("select animal type")
            }else{
                if catName != "" || age != ""{
                    let data = catImageData!
                    self.db.collection("users").document(uid!).getDocument { (snapshot, error) in
                        if error == nil{
                            let numberOfCats : Int = snapshot?.get("numberOfCats") as! Int
                            let temp = numberOfCats + 1
                            var rif : DocumentReference? = nil
                            rif = self.db.collection("cats").addDocument(data: ["name" :catName,"id":uid!,"age" : Int(age)!,"numberOfRatings":0,"averageRating": "0","numberOfReports":0,"parentID" : user?.uid, "numberOfLikes" : 0, "numberOfDislikes" : 0, "deviceTokenID" : Utilities.globalVariables.deviceTokenID, "type" : self.selectedPetType]) { err in
                                if let err = err{
                                    self.errorLabel.alpha = 1
                                    self.errorLabel.text = err.localizedDescription
                                    return
                                }else{
                                    print("added cat ok")
                                    let timp = rif!.documentID
                                    
                                    let storageRef = Storage.storage().reference().child("catImages").child("\(timp)")
                                    storageRef.putData(data, metadata: nil) { (metadata, error) in
                                        if error != nil{
                                            self.errorLabel.alpha = 1
                                            self.errorLabel.text = error as? String
                                            return
                                        }else{
                                            storageRef.downloadURL { (url, error) in
                                                let downloadURL = url
                                                print(downloadURL!.absoluteString)
                                                self.db.collection("cats").document(timp).updateData(["id" : rif!.documentID, "url" : downloadURL!.absoluteString]) { (errer) in
                                                    if errer == nil{
                                                        print("got to the end")
                                                        self.db.collection("users").document(uid!).updateData(["numberOfCats" : temp])
                                                        self.transitionAccountScreen()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            self.numCats = temp
                            
                        }
                        
                    }
                    navigationController?.popViewController(animated: true)
                    dismiss(animated: true, completion: nil)
                }
                else{
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = "Please fill in all fields"}
            }
        }
    }
    
    func jpegImage(image: UIImage, maxSize: Int, minSize: Int, times: Int) -> Data? {
        
        var maxQuality: CGFloat = 1.0
        var minQuality: CGFloat = 0.0
        var bestData: Data?
        for _ in 1...times {
            let thisQuality = (maxQuality + minQuality) / 2
            guard let data = image.jpegData(compressionQuality: thisQuality) else { return nil }
            let thisSize = data.count
            if thisSize > maxSize {
                maxQuality = thisQuality
            } else {
                minQuality = thisQuality
                bestData = data
                if thisSize > minSize {
                    return bestData
                }
            }
        }
        
        return bestData
    }
    
    func validateFields(nn: String) -> String?{
        if self.selectedPetType == "Choose One"{
            return "Please select the type of animal that you are adding"
        }else if nn.count > 12 {
            return "Please enter a name that is less than 12 characters"
        }else if self.imageView.image == nil{
            return "Please select an image"
        }else if age < 0 {
            return "Please enter a real age"
        }else{return nil}
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
    }
    
    func transitionAccountScreen(){
        let accountViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.accountViewController) as? AccountViewController
        accountViewController?.viewDidLoad()
        view.window?.rootViewController = accountViewController
        view.window?.makeKeyAndVisible()
    }
    
}


extension NewCatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let tempRect = CGRect(x: 0, y: 0, width: 90, height: 160)
            
            
        }
    }
    
    func cropImage(image: UIImage, toRect: CGRect) -> UIImage? {
        // Cropping is available trhough CGGraphics
        let cgImage :CGImage! = image.cgImage
        let croppedCGImage: CGImage! = cgImage.cropping(to: toRect)
        
        return UIImage(cgImage: croppedCGImage)
    }
}

extension NewCatViewController: UIImageCropperProtocol {
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        print("crop button pressed")
        imageView.image = croppedImage
    }
    
    func didCancel() {
        print("cancel button pressed")
        self.dismiss(animated: false, completion: nil)
    }
}


