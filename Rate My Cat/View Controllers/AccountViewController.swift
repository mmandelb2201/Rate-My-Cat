//
//  AccountViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 12/25/19.
//  Copyright © 2019 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage

class AccountViewController: UIViewController {
    
    let db = Firestore.firestore()
    var hasKitty : Bool!
    var username : String!
    var cats : [cat] = []
    var index : Int = 0
    var numberOfCats : Int = 0
    
    @IBOutlet weak var accountNameTextField: UILabel!
    
    @IBOutlet weak var goBackButton: UIButton!
    
    @IBOutlet var menuSwipeOpener: UISwipeGestureRecognizer!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var updateCatButton: UIButton!
    
    @IBOutlet weak var buttonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var deleteWidth: NSLayoutConstraint!
    
    @IBOutlet weak var addWidth: NSLayoutConstraint!
    
    @IBOutlet weak var settingsWidth: NSLayoutConstraint!
    
    @IBOutlet weak var leadingC: NSLayoutConstraint!
    
    @IBOutlet weak var trailingC: NSLayoutConstraint!
    
    @IBOutlet weak var noInternetView: UIView!
    
    @IBOutlet weak var noInternetImageView: UIImageView!
    
    @IBOutlet weak var pleaseCheckInternetLabel: UILabel!
    
    @IBOutlet weak var noInternetX: NSLayoutConstraint!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var noInternetY: NSLayoutConstraint!
    
    @IBOutlet var currentView: UIView!
    
    @IBOutlet weak var sideView: UIView!
    
    @IBOutlet weak var sideBarButton: UIButton!
    
    @IBOutlet weak var starRatingImageView: UIImageView!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var deleteCatButton: UIButton!
    
    @IBOutlet weak var myCatTextField: UITextField!
    
    @IBOutlet weak var numberOfRatingsTextField: UILabel!
    
    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addACatButton: UIButton!
    
    @IBOutlet var swipeUp: UISwipeGestureRecognizer!
    
    @IBOutlet weak var catButton: UIButton!
        
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let storage = Storage.storage()
    var isPremium : Bool = false
    var displayCatS : Bool = true
    let stockURL : String = "https://firebasestorage.googleapis.com/v0/b/rate-my-cat-1c93c.appspot.com/o/Stock%20Images%2Fw.png?alt=media&token=dad6881c-7b2a-49f0-bff0-a9ccad86051d"
    var sideMenuIsVisisble : Bool = true
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
            
        }
    }
    
    override func viewDidLoad() {
        setUpElements()
        super.viewDidLoad()
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value) { (snapshot) in
            if snapshot.value as? Bool ?? false {
                print("connected")
            }else{
                print("not connected")
                if Utilities.globalVariables.accountViewCats.count > 0 && Utilities.globalVariables.accountViewCatsImages.count > 0 && Utilities.globalVariables.accountUsername != "" && Utilities.globalVariables.accountViewCats.count == Utilities.globalVariables.accountViewCatsImages.count {
                    self.displayCat()
                }else{
                    self.showNoInternet()
                }
            }
        }
        let storage = Storage.storage()
        let user = Auth.auth().currentUser
        self.activityIndicator.startAnimating()
        self.activityIndicator.alpha = 1
        if Utilities.globalVariables.accountViewCats.count == 0 || Utilities.globalVariables.accountViewCatsImages.count == 0 || Utilities.globalVariables.accountUsername == ""{
            Utilities.globalVariables.accountViewCats.removeAll()
            Utilities.globalVariables.accountViewCatsImages.removeAll()
            Utilities.globalVariables.numberOfAccountCatImagesDownloaded = 0
            Utilities.globalVariables.accountUsername = ""
            db.collection("users").document(user!.uid).getDocument { (document, error) in
                if let document = document{
                    let isPremium : Bool = document.get("isPremium") as! Bool
                    self.numberOfCats = document.get("numberOfCats") as! Int
                    let property = document.get("username")
                    self.accountNameTextField.text = property as? String
                    self.accountNameTextField.alpha = 1
                    Utilities.globalVariables.accountUsername = (property as? String)!
                    var hasK = document.get("hasCat") as! Bool
                    if hasK || self.numberOfCats > 0{
                        self.imageView.alpha = 0
                        Firestore.firestore().collection("cats").whereField("parentID", isEqualTo: user?.uid as Any).order(by: "name").getDocuments { (snapshots, err) in
                            if err == nil{
                                Utilities.globalVariables.accountViewCats.removeAll()
                                var x = 1
                                print("found - \(snapshots!.documents.count)")
                                if snapshots!.documents.count == 0 {
                                    Utilities.globalVariables.accountViewCats.removeAll()
                                    Utilities.globalVariables.accountViewCatsImages.removeAll()
                                    Utilities.globalVariables.numberOfAccountCatImagesDownloaded = 0
                                    self.numberOfCats = 0
                                    hasK = false
                                    self.displayCat()
                                }
                                var amountOfCats = snapshots!.documents.count
                                for doc in snapshots!.documents{
                                    let age = doc.get("age")
                                    let name = doc.get("name")
                                    let avgr = doc.get("averageRating")
                                    let nar = doc.get("numberOfRatings")
                                    let iurl = doc.get("url")
                                    let idd = doc.get("id")
                                    let ph = doc.get("parentID")
                                    let al = doc.get("numberOfLikes")
                                    let ad = doc.get("numberOfDislikes")
                                    let dID = doc.get("deviceTokenID")
                                    print("\(name as! String)")
                                    if age != nil && name != nil && avgr != nil && nar != nil && iurl != nil && idd != nil && ph != nil && al != nil && ad != nil {
                                        let temp : cat = cat(ag: age as! Int, nm: name as! String, avr: avgr as! String, nor: nar as! Int, url: iurl as! String, id: idd as! String, pd: ph as! String, aol: al as! Int, aod: ad as! Int, downloadPrior: true)
                                        let tumper = dID
                                        if tumper == nil || tumper as? String == "" || tumper as? String != Messaging.messaging().fcmToken as? String {
                                            Firestore.firestore().collection("cats").document(idd as! String).updateData(["deviceTokenID" : Messaging.messaging().fcmToken]) { (rorr) in
                                                if rorr != nil{
                                                    print(rorr?.localizedDescription)
                                                }
                                            }
                                        }
                                        let tempImgRef = storage.reference(forURL: iurl as! String)
                                        tempImgRef.getData(maxSize: 1 * 1920 * 1920) { (tempData, tempError) in
                                            if let tempError = tempError{
                                                print(tempError.localizedDescription)
                                            }else{
                                                print("count: \(Utilities.globalVariables.accountViewCats.count) amt: \(amountOfCats)")
                                                if Utilities.globalVariables.accountViewCats.count < amountOfCats {
                                                    print("adding cat to account array")
                                                    Utilities.globalVariables.accountViewCats.append(temp)
                                                    Utilities.globalVariables.accountViewCatsImages.append(UIImage(data: tempData!)!)
                                                    var upper = 1
                                                    if self.numberOfCats < 5 {
                                                        upper = self.numberOfCats
                                                    }else{
                                                        upper = 5
                                                    }
                                                    print("igd: \(Utilities.globalVariables.numberOfAccountCatImagesDownloaded) upper: \(upper)")
                                                    if Utilities.globalVariables.accountViewCatsImages.count == upper{
                                                        self.activityIndicator.alpha = 0
                                                        self.displayCat()
                                                    }
                                                }
                                            }
                                        }
                                    }else{
                                        amountOfCats = amountOfCats - 1
                                    }
                                    x = x + 1
                                }
                            }
                            else{
                                print("initial: \(err?.localizedDescription)")
                            }
                        }
                        if self.numberOfCats > 2 && isPremium == false{
                        }
                    }else if self.numberOfCats == 0{
                        self.displayCat()
                    }
                }
            }
        }else{
            self.displayCat()
            self.accountNameTextField.text = Utilities.globalVariables.accountUsername
            self.accountNameTextField.alpha = 1
        }
    }
    func isUnique(cat: cat, cats : [cat]) -> Bool {
        let c = cat.getCID()
        var x = 0
        while x < cats.count {
            if cats[x].getCID() == c {
                return false
            }
            let temp = cats.count - 1
            if x == temp {
                return true
            }
            x = x + 1
        }
        return true
    }
    
    func setUpElements(){
        if Utilities.globalVariables.justAddedCat == true{
            self.reload()
            Utilities.globalVariables.justAddedCat = false
        }
        if self.updateCatButton != nil {
            print("update cat button != nil")
            let buttonHeight = self.updateCatButton.frame.height
            let buttonWidth = self.updateCatButton.frame.width
            self.updateCatButton.imageView?.contentMode = .scaleAspectFit
            self.addACatButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            self.addACatButton.imageView?.contentMode = .scaleAspectFit
            self.deleteCatButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            self.deleteCatButton.imageView?.contentMode = .scaleAspectFit
            self.settingsButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            self.settingsButton.imageView?.contentMode = .scaleAspectFit
        }
        if self.refreshButton != nil{
            Utilities.styleOrangeButton(self.refreshButton)
        }
        if self.noInternetY != nil{
            self.noInternetX.constant = 500
        }
        if self.imageView != nil && self.myCatTextField != nil && self.numberOfRatingsTextField != nil && self.previousButton != nil && self.nextButton != nil {
            self.imageView.alpha = 0
            self.myCatTextField.alpha = 0
            self.numberOfRatingsTextField.alpha = 0
            self.previousButton.alpha = 0
            self.nextButton.alpha = 0
        }
        Utilities.globalVariables.justCameFromAccountView = true
        sideMenuIsVisisble = true
        if leadingC?.constant != nil{
            leadingC.constant = 400}
        if trailingC?.constant != nil{
            trailingC.constant = -250}
        if sideView?.backgroundColor != nil{
            self.sideView.backgroundColor = UIColor(patternImage: UIImage(named: "settingsBarTexture.png")!)
        }
        sideMenuIsVisisble = false
        view.backgroundColor = .white
        /*self.deleteCatButton.imageView?.contentMode = .scaleAspectFit
         self.updateCatButton.imageView?.contentMode = .scaleAspectFit
         self.addACatButton.imageView?.contentMode = .scaleAspectFit
         self.settingsButton.imageView?.contentMode = .scaleAspectFit*/
        self.deleteCatButton.frame.size = CGSize(width: 244, height: 36)
        self.updateCatButton.frame.size = CGSize(width: 244, height: 36)
        self.addACatButton.frame.size = CGSize(width: 244, height: 36)
        self.settingsButton.frame.size = CGSize(width: 244, height: 36)
    }
    func showNoInternet(){
        Utilities.globalVariables.accountViewCatsImages.removeAll()
        Utilities.globalVariables.accountViewCats.removeAll()
        Utilities.globalVariables.numberOfAccountCatImagesDownloaded = 0
        self.imageView.alpha = 0
        self.nextButton.alpha = 0
        self.myCatTextField.alpha = 0
        self.nextButton.isUserInteractionEnabled = false
        self.previousButton.alpha = 0
        self.previousButton.isUserInteractionEnabled = false
        self.starRatingImageView.alpha = 0
        self.numberOfRatingsTextField.alpha = 0
        self.noInternetView.alpha = 1
        self.noInternetX.constant = 0
        self.sideBarButton.alpha = 0
        self.sideBarButton.isUserInteractionEnabled = false
        self.menuSwipeOpener.isEnabled = false
        self.activityIndicator.alpha = 0
    }
    
    func displayCat(){
        self.activityIndicator.stopAnimating()
        self.activityIndicator.alpha = 0
        self.numberOfRatingsTextField.textColor = .black
        self.myCatTextField.textColor = .black
        print("i: \(Utilities.globalVariables.accountIndex) t: \(Utilities.globalVariables.accountViewCats.count)")
        if Utilities.globalVariables.accountIndex < Utilities.globalVariables.accountViewCats.count{
            if Utilities.globalVariables.accountViewCats.count > 0{
                self.previousButton.alpha = 1
                self.previousButton.isHidden = false
                self.nextButton.alpha = 1
                self.nextButton.isHidden = false
                self.nextButton.isUserInteractionEnabled = true
                self.previousButton.isUserInteractionEnabled = true
                self.imageView.image = nil
            }
            self.imageView.image = nil
            self.myCatTextField.text = "\(Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex].getName()), \(Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex].getAge())"
            var temp = Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex].getAvgRatingAsInt()
            Utilities.globalVariables.currenAccountCat = Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex]
            Utilities.globalVariables.currentAccountCatImage = Utilities.globalVariables.accountViewCatsImages[Utilities.globalVariables.accountIndex]
            let avgrAsNs : NSString = temp as NSString
            let avgrAsF = avgrAsNs.integerValue
            let likes = Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex].getLikes()
            let dislikes = Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex].getDislikes()
            self.starRatingImageView.image = getStar(L: likes, D: dislikes)
            self.numberOfRatingsTextField.text = "Number Of Ratings: \(likes + dislikes)"
            let catURL = Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex].getURL()
            let urled = URL(string: catURL)
            self.imageView.image = nil
            self.imageView.image = Utilities.globalVariables.accountViewCatsImages[Utilities.globalVariables.accountIndex]
            self.imageView.alpha = 1
            self.myCatTextField.alpha = 1
            self.numberOfRatingsTextField.alpha = 1
            self.previousButton.alpha = 1
            self.nextButton.alpha = 1
        }
        else if Utilities.globalVariables.accountViewCats.count == 0{
            print("number of cats is turning out to be zero")
            self.myCatTextField.text = "My Cat"
            //self.imageView.image = self.standardImage
            let urler = URL(string: self.stockURL)
            self.imageView.downloadImage(from: urler!, actv: self.activityIndicator,imgV: self.imageView, rmv: false, finished: {
            })
            self.numberOfRatingsTextField.text = "Number Of Ratings:"
            self.nextButton.alpha = 0
            self.previousButton.alpha = 0
            self.imageView.alpha = 1
            self.myCatTextField.alpha = 1
            self.nextButton.isUserInteractionEnabled = false
            self.previousButton.isUserInteractionEnabled = false
            
        }
        var yimp = Utilities.globalVariables.accountIndex + 1
        if Utilities.globalVariables.accountViewCats.count > 0{
            print("Utilities.globalVariables.accountViewCats.count > 0")}
        if Utilities.globalVariables.accountViewCats.count == 1{
            print("Utilities.globalVariables.accountViewCats.count == 1")
            self.nextButton.alpha = 0
            self.previousButton.alpha = 0
            self.nextButton.isHidden = true
            self.previousButton.isHidden = true
        }else if Utilities.globalVariables.accountViewCats.count > 0 && Utilities.globalVariables.accountIndex == 0{
            print("Utilities.globalVariables.accountViewCats.count > 0 && Utilities.globalVariables.accountIndex == 0")
            self.previousButton.alpha = 0
            self.nextButton.alpha = 1
            self.nextButton.isHidden = false
            self.previousButton.isHidden = true
        }else if yimp == Utilities.globalVariables.accountViewCats.count{
            print("yimp == Utilities.globalVariables.accountViewCats.count")
            self.nextButton.alpha = 0
            self.previousButton.alpha = 1
            self.nextButton.isHidden = true
            self.previousButton.isHidden = false
        }else{
            print("else")
            self.nextButton.alpha = 1
            self.previousButton.alpha = 1
            self.nextButton.isHidden = false
            self.previousButton.isHidden = false
        }
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
    
    func transitionToNewCatScreen(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "NewVC") as? NewCatViewController {
            self.present(viewController, animated: false, completion: nil)
            viewController.reloadInputViews()
        }
        
    }
    
    func transitionToUpdateCatScreen(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "UpdateVC") as? UpdateCatViewController {
            self.present(viewController, animated: false, completion: nil)
            viewController.reloadInputViews()
        }
        
    }
    @IBAction func addACatTapped(_ sender: Any) {
        if self.numberOfCats < 4 {
            self.transitionToNewCatScreen()
        }else{
            var alert = UIAlertController(title: "Add A Pet", message: "You may only add up to 3 pets", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("too many cats")
        }
    }
    
    @IBAction func updateCatTapped(_ sender: Any) {
        if Utilities.globalVariables.accountViewCats.count == 0{
            var alert = UIAlertController(title: "Update Pet", message: "You have no pets to Update. Press the Add A Cat button to add you first pet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            if self.numberOfCats < 4{
            alert.addAction(UIAlertAction(title: "Add A Pet", style: UIAlertAction.Style.default, handler: { (UIAct) in
                self.transitionToNewCatScreen()
            }))
            }
            self.present(alert, animated: true, completion: nil)
        }else{
            self.transitionToUpdateCatScreen()
        }
    }
    
    @IBAction func deleteCatButtonTapped(_ sender: Any) {
        if Utilities.globalVariables.accountViewCats.count == 0{
            var alert = UIAlertController(title: "Delete Pet", message: "You have no pets to delete. Press the Add A Pet button to add your first pet.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Add A Pet", style: UIAlertAction.Style.default, handler: { (UIAct) in
                self.transitionToNewCatScreen()
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            var alert = UIAlertController(title: "Delete Pet", message: "Are you sure you want to delete \(Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex].getName())?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (UIAct) in
                let id = Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex].getCID()
                let parent = Utilities.globalVariables.accountViewCats[Utilities.globalVariables.accountIndex].getPID()
                self.numberOfCats = self.numberOfCats - 1
                Firestore.firestore().collection("users").document(parent).updateData(["numberOfCats" : self.numberOfCats])
                Firestore.firestore().collection("cats").document(id).delete { (err) in
                    if err != nil{
                        print("delete button error: \(err?.localizedDescription)")
                    }
                    self.reload()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getStar(L: Int, D: Int) -> UIImage{
        if L + D != 0{
            var lD : Float = Float(L)
            var dD : Float = Float(D)
            var percentL : Float = Float((lD/(lD+dD))*100)
            if percentL < 15 {return UIImage(named: "oneStarCenter")!}
            else if percentL >= 15 && percentL < 45 {return UIImage(named: "twoStarCenter")!}
            else if percentL >= 45 && percentL < 70 {return UIImage(named: "threeStarCenter")!}
            else if percentL >= 70 && percentL < 75 {return UIImage(named: "fourStarCenter")!}
            else {return UIImage(named: "fiveStarCenter")!}
        }else{return UIImage(named: "zeroStarCetner")!}
    }
    
    func reload(){
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value) { (snapshot) in
            if snapshot.value as? Bool ?? false {
                print("connected")
            }else{
                print("not connected")
                if Utilities.globalVariables.accountViewCats.count > 0 && Utilities.globalVariables.accountViewCatsImages.count > 0 && Utilities.globalVariables.accountUsername != "" && Utilities.globalVariables.accountViewCats.count == Utilities.globalVariables.accountViewCatsImages.count {
                    self.displayCat()
                }else{
                    self.showNoInternet()
                }
            }
        }
        if self.activityIndicator != nil && self.imageView != nil && self.nextButton != nil && self.previousButton != nil && self.starRatingImageView != nil && self.numberOfRatingsTextField != nil && self.noInternetView != nil && self.sideBarButton != nil && self.menuSwipeOpener != nil{
            self.activityIndicator.isHidden = false
            self.activityIndicator.alpha = 1
            self.activityIndicator.startAnimating()
            self.imageView.alpha = 0
            self.nextButton.alpha = 1
            self.previousButton.alpha = 1
            self.starRatingImageView.alpha = 1
            self.numberOfRatingsTextField.alpha = 1
            self.noInternetView.alpha = 0
            self.noInternetX.constant = 500
            self.sideBarButton.alpha = 1
            self.sideBarButton.isUserInteractionEnabled = true
            self.menuSwipeOpener.isEnabled = true
        }
        let user = Auth.auth().currentUser
        let storage = Storage.storage()
        Utilities.globalVariables.accountViewCatsImages.removeAll()
        Utilities.globalVariables.accountViewCats.removeAll()
        Utilities.globalVariables.numberOfAccountCatImagesDownloaded = 0
        Firestore.firestore().collection("cats").whereField("parentID", isEqualTo: user?.uid).order(by: "name").getDocuments { (snapshots, err) in
            if err == nil{
                var x = 1
                var amountOfCats = snapshots!.documents.count
                for doc in snapshots!.documents{
                    let age = doc.get("age")
                    let name = doc.get("name")
                    let avgr = doc.get("averageRating")
                    let nar = doc.get("numberOfRatings")
                    let iurl = doc.get("url")
                    let idd = doc.get("id")
                    let pn = doc.get("parentID")
                    let al = doc.get("numberOfLikes")
                    let ad = doc.get("numberOfDislikes")
                    if age == nil || name == nil || avgr == nil || nar == nil || iurl == nil || idd == nil || pn == nil || al == nil || ad == nil {
                        print("cat was empty")
                    }else{
                        let temp : cat = cat(ag: age as! Int, nm: name as! String, avr: avgr as! String, nor: nar as! Int, url: iurl as! String, id: idd as! String, pd: pn as! String, aol: al as! Int, aod: ad as! Int, downloadPrior: true)
                        let tempImgRef = storage.reference(forURL: iurl as! String)
                        tempImgRef.getData(maxSize: 1 * 1920 * 1920) { (tempData, tempError) in
                            if let tempError = tempError{
                                print(tempError.localizedDescription)
                            }else{
                                print("count: \(Utilities.globalVariables.accountViewCats.count) amt: \(amountOfCats)")
                                if Utilities.globalVariables.accountViewCats.count < amountOfCats {
                                    print("adding cat to account array")
                                    Utilities.globalVariables.accountViewCats.append(temp)
                                    Utilities.globalVariables.accountViewCatsImages.append(UIImage(data: tempData!)!)
                                    var upper = 1
                                    if self.numberOfCats < 5 {
                                        upper = self.numberOfCats
                                    }else{
                                        upper = 5
                                    }
                                    print("igd: \(Utilities.globalVariables.numberOfAccountCatImagesDownloaded) upper: \(upper)")
                                    if Utilities.globalVariables.accountIndex < (self.numberOfCats - 1){
                                        print("showing next button")
                                        self.nextButton.alpha = 1
                                        self.nextButton.isHidden = false
                                        self.nextButton.isUserInteractionEnabled = true
                                    }
                                    if Utilities.globalVariables.accountViewCatsImages.count == upper{
                                        self.activityIndicator.alpha = 0
                                        self.displayCat()
                                    }
                                    if Utilities.globalVariables.accountIndex >= upper && (Utilities.globalVariables.accountViewCatsImages.count - 1) == Utilities.globalVariables.accountIndex{
                                        print("showing reloaded image")
                                        self.activityIndicator.alpha = 0
                                        self.displayCat()
                                        //self.imageView.image = UIImage(data: tempData!)!
                                    }
                                }
                            }
                        }
                        print("x: \(x) snapshots.doc: \(snapshots?.documents.count)")
                    }
                    x = x + 1
                }
                if snapshots!.documents.count == 0 {
                    self.displayCat()
                }
            }else{print("reload error: \(err?.localizedDescription)")}
        }
    }
    
    @IBAction func accountButtonTapped(_ sender: Any) {
    }
    
    @IBAction func swipeReload(_ sender: Any) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.reload()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let temp = Utilities.globalVariables.accountIndex + 1
        if temp < Utilities.globalVariables.accountViewCats.count {
            let temp = Utilities.globalVariables.accountIndex + 1
            Utilities.globalVariables.accountIndex = temp
            print("numb: \(self.numberOfCats) index: \(Utilities.globalVariables.accountIndex)")
            self.displayCat()
            
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: Any) {
        let temp = Utilities.globalVariables.accountIndex - 1
        if temp >= 0{
            self.imageView.image = nil
            Utilities.globalVariables.accountIndex = temp
            print("numb: \(self.numberOfCats) index: \(Utilities.globalVariables.accountIndex)")
            self.displayCat()
        }
    }    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        print("tapped")
    }
    
    @IBAction func menuSwiped(_ sender: Any) {
        if leadingC.constant == 400{
            leadingC.constant = -5
            trailingC.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { (animationCOmplete) in
                //print("side view animation complete")
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        self.reload()
    }
    
    @IBAction func swoped(_ sender: Any) {
        if leadingC.constant == 400{
            self.transitionToCatScreen()
        }else{
            leadingC.constant = 400
            trailingC.constant = -250
            //sideBarButton.alpha = 0
            sideMenuIsVisisble = true
            let buttonHeight = self.updateCatButton.frame.height
            let buttonWidth = self.updateCatButton.frame.width
            self.updateCatButton.imageView?.contentMode = .scaleAspectFit
            self.addACatButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            self.addACatButton.imageView?.contentMode = .scaleAspectFit
            self.deleteCatButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            self.deleteCatButton.imageView?.contentMode = .scaleAspectFit
            self.settingsButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            self.settingsButton.imageView?.contentMode = .scaleAspectFit
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { (animationCOmplete) in
                //print("side view animation complete")
            }
        }
    }
    
    @IBAction func sideBarTapped(_ sender: Any) {
        if leadingC.constant == -5{
            leadingC.constant = 400
            trailingC.constant = -250
            //sideBarButton.alpha = 0
            sideMenuIsVisisble = true
            let buttonHeight = self.updateCatButton.frame.height
            let buttonWidth = self.updateCatButton.frame.width
            self.updateCatButton.imageView?.contentMode = .scaleAspectFit
            self.addACatButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            self.addACatButton.imageView?.contentMode = .scaleAspectFit
            self.deleteCatButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            self.deleteCatButton.imageView?.contentMode = .scaleAspectFit
            self.settingsButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
            self.settingsButton.imageView?.contentMode = .scaleAspectFit

            
        }else if leadingC.constant == 400{
            leadingC.constant = -5
            trailingC.constant = 0
            // sideBarButton.alpha = 1
            sideMenuIsVisisble = false
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { (animationCOmplete) in
            //print("side view animation complete")
        }
    }
}

extension UIImageView{
    
    
    func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) ->()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL, actv:UIActivityIndicatorView, imgV : UIImageView, rmv : Bool, finished: @escaping () -> Void){
        actv.isHidden = false
        imgV.alpha = 0
        actv.startAnimating()
        getData(from: url){
            data, response, error in
            guard let data = data, error == nil else{print("picture error:\(error?.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                Utilities.globalVariables.imageAspectRatio = Float((UIImage(data: data)?.size.height)!)/Float((UIImage(data: data)?.size.width)!)
                actv.isHidden = true
                imgV.alpha = 1
                actv.stopAnimating()
                finished()
            }
        }
    }
}

