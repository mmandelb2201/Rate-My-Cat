//
//  CatViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 12/25/19.
//  Copyright © 2019 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import AVKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import UserNotifications

class CatViewController: UIViewController{
    
    @IBOutlet weak var catButton: UIButton!
    
    @IBOutlet weak var menuBackgroundImage: UIImageView!
    
    @IBOutlet weak var cuteOrNoHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cuteOrNoWidth: NSLayoutConstraint!
    
    @IBOutlet weak var nextIntroButton: UIButton!
    
    @IBOutlet weak var startRatingButton: UIButton!
    
    @IBOutlet weak var cuteOrNo: UIImageView!
    
    @IBOutlet weak var noInternetX: NSLayoutConstraint!
    
    @IBOutlet weak var noInternetY: NSLayoutConstraint!
    
    @IBOutlet weak var catImageView: UIImageView!
    
    @IBOutlet weak var noInternetView: UIView!
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var noInternetImage: UIImageView!
    
    @IBOutlet weak var pleaseCheckInternetLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var dislikeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var likeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stackViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var nextCatImageView: UIImageView!
    
    @IBOutlet weak var nextCatHeight: NSLayoutConstraint!
    
    @IBOutlet weak var nextCatWidth: NSLayoutConstraint!
    
    @IBOutlet weak var nextCatX: NSLayoutConstraint!
    
    @IBOutlet weak var nextCatY: NSLayoutConstraint!
    
    @IBOutlet weak var nextView: UIView!
    
    @IBOutlet weak var nextViewX: NSLayoutConstraint!
    
    @IBOutlet weak var introArrowBottom: NSLayoutConstraint!
    
    @IBOutlet weak var nextViewY: NSLayoutConstraint!
    
    @IBOutlet weak var introLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var cuteOrNoY: NSLayoutConstraint!
    
    @IBOutlet var closeMenuTapRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var catNameTextField: UILabel!
    
    @IBOutlet weak var catAgeTextField: UILabel!
    
    @IBOutlet weak var catStack: UIStackView!
    
    @IBOutlet weak var starRating: UIImageView!
    
    @IBOutlet var refreshPullDownRecognizer: UISwipeGestureRecognizer!
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var catStackBottom: NSLayoutConstraint!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dislikeButton: UIButton!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var cardWidth: NSLayoutConstraint!
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var introLabel: UILabel!
    
    @IBOutlet weak var navBarTexture: UIImageView!
    
    @IBOutlet weak var catStackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var introView: UIView!
    
    @IBOutlet weak var introArrow: UIImageView!
    
    @IBOutlet weak var videoButton: UIButton!
    
    @IBOutlet weak var catStackLeading: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    var uids : [String] = []
    let db = Firestore.firestore()
    var wereDone : Bool = false
    var usedNumbers : [Int] = []
    var isReloading = false
    var sortingType : Int = 0
    var isMenuOpen : Bool = false
    var oldPoint : CGPoint = CGPoint(x: 0, y: 0)
    var isModerator : Bool = false
    var screenSizeRatio : Float = 1
    var catImages : [UIImage] = []
    var introAnimationIndex : Int = 0
    let animTwo = UIViewPropertyAnimator(duration: 2, curve: .linear)
    var one : Float = 15
    var two: Float = 45
    var three : Float = 82
    var four : Float = 86
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        Utilities.globalVariables.sendToUpdatePassword = false
        let connectRef = Database.database().reference(withPath: ".info/connected")
        connectRef.observe(.value) { (snapshot) in
            if snapshot.value as? Bool ?? false {
                print("connected")
                self.card.alpha = 1
                self.likeButton.alpha = 1
                self.dislikeButton.alpha = 1
                self.activityIndicator.alpha = 1
                self.noInternetX.constant = 500
                self.noInternetY.constant = -100
                self.noInternetView.alpha = 0
            }else{
                print("not connected")
                self.showNoInternet()
            }
        }
        print("I: \(Utilities.globalVariables.catViewCatImages.count) NI: \(Utilities.globalVariables.catViewCats.count)")
        let storage = Storage.storage()
        self.card.transform = CGAffineTransform(rotationAngle: 0)
        self.card.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 60)
        self.catNameTextField.isHidden = true
        self.catAgeTextField.isHidden = true
        view.backgroundColor = .white
        let backgroundImage = UIImage(named: "menuBorder")
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        db.collection("meta").document("starRating").getDocument { (snap, err) in
            if err == nil{
                self.one = snap?.get("one") as! Float
                self.two = snap?.get("two") as! Float
                self.three = snap?.get("three") as! Float
                self.four = snap?.get("four") as! Float
            }else{
                print(err?.localizedDescription)
            }
        }
        if Auth.auth().currentUser != nil{
            db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (snap, err) in
                if err == nil{
                    let temp = snap?.get("isMod") as! Bool
                    if temp == true{
                        self.isModerator = true
                    }else{
                        self.isModerator = false
                    }
                }
            }
        }else{
        }
        db.collection("cats").getDocuments { (snapshots, err) in
            if err == nil{
                var i = 0
                if Utilities.globalVariables.catViewCats.count == 0 || Utilities.globalVariables.catViewCatImages.count == 0{
                    print("resetting")
                    Utilities.globalVariables.catViewCats.removeAll()
                    Utilities.globalVariables.catViewIndex = 0
                    Utilities.globalVariables.catViewCatImages.removeAll()
                    var randNumbers : [Int] = []
                    var z = 0
                    print("number of cats showing: \(snapshots!.documents.count)")
                    while z < snapshots!.documents.count{
                        randNumbers.append(z)
                        if z == (snapshots!.documents.count - 1){
                            randNumbers.shuffle()
                            while i < randNumbers.count{
                                let document : QueryDocumentSnapshot = (snapshots?.documents[randNumbers[i]])!
                                let numberOfLikes = document.get("numberOfLikes")
                                if numberOfLikes != nil{
                                    let age = document.get("age") as? Int
                                    let name = document.get("name") as? String
                                    let avgr = document.get("averageRating") as? String
                                    let nar = document.get("numberOfRatings") as? Int
                                    let iurl = document.get("url") as? String
                                    let idd = document.get("id") as? String
                                    /*print("\(name as! String) id: ")
                                     print("--------------------------")*/
                                    let pidd = document.get("parentID")
                                    let al = document.get("numberOfLikes") as? Int
                                    let ad = document.get("numberOfDislikes") as? Int
                                    if age == nil || name == nil || avgr == nil || nar == nil || iurl == nil || idd == nil || pidd == nil || al == nil || ad == nil {
                                        print("cat was nil")
                                    }else{
                                        let temp : cat = cat(ag: age!, nm: name!, avr: avgr!, nor: nar!, url: iurl! , id: idd!, pd: pidd as! String, aol: al!, aod: ad!, downloadPrior: false)
                                        if self.viewIfLoaded?.window != nil {
                                            let tempRef = storage.reference(forURL: iurl!)
                                            tempRef.getData(maxSize: 1 * 1920 * 1920) { (data, dataError) in
                                                if let dataError = dataError {
                                                    print("\(name as! String) id: \(idd)")
                                                    print("downloading image shit--------------------------")
                                                    print(" downloading error: \(dataError.localizedDescription)")
                                                }else{
                                                    Utilities.globalVariables.catViewCats.append(temp)
                                                    Utilities.globalVariables.catViewCatImages.append(UIImage(data: data!)!)
                                                    if Utilities.globalVariables.catViewCatImages.count == 5{
                                                        self.displayCat(kats: Utilities.globalVariables.catViewCats, ind: Utilities.globalVariables.catViewIndex, isReal: false)
                                                    }else{
                                                        let idd = document.get("id") as! String
                                                        let name = document.get("name")
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                i = i + 1
                            }
                        }
                        z += 1
                    }
                }
                else if Utilities.globalVariables.catViewCatImages.count < Utilities.globalVariables.catViewCats.count{
                    print("going from halfway")
                    var i = Utilities.globalVariables.catViewCatImages.count
                    while i < Utilities.globalVariables.catViewCats.count {
                        let tempURL = Utilities.globalVariables.catViewCats[i].getURL()
                        let tempRef = storage.reference(forURL: tempURL)
                        tempRef.getData(maxSize: 1 * 1920 * 1920) { (data, dataError) in
                            if let dataError = dataError {
                                print(dataError.localizedDescription)
                            }else{
                                Utilities.globalVariables.catViewCatImages.append(UIImage(data: data!)!)
                            }
                        }
                        i = i + 1
                    }
                }else{
                    print("haha: \(Utilities.globalVariables.catViewCats.count)")
                    self.displayCat(kats: Utilities.globalVariables.catViewCats, ind: Utilities.globalVariables.catViewIndex, isReal: false)
                    Utilities.globalVariables.justCameFromAccountView = false
                }
                
                
            }
        }
    }
    func imageIsEmpty(_ image: UIImage) -> Bool {
        guard let cgImage = image.cgImage,
            let dataProvider = cgImage.dataProvider else
        {
            return true
        }
        
        let pixelData = dataProvider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let imageWidth = Int(image.size.width)
        let imageHeight = Int(image.size.height)
        for x in 0..<imageWidth {
            for y in 0..<imageHeight {
                let pixelIndex = ((imageWidth * y) + x) * 4
                let r = data[pixelIndex]
                let g = data[pixelIndex + 1]
                let b = data[pixelIndex + 2]
                let a = data[pixelIndex + 3]
                if a != 0 {
                    if r != 0 || g != 0 || b != 0 {
                        return false
                    }
                }
            }
        }
        
        return true
    }
    
    func introAnimation() {
        self.introView.alpha = 1
        self.introLabel.alpha = 1
        self.nextIntroButton.alpha = 1
        self.nextIntroButton.isUserInteractionEnabled = true
        self.skipButton.setTitleColor(.black, for: .normal)
        self.likeButton.isUserInteractionEnabled = false
        self.dislikeButton.isUserInteractionEnabled = false
        self.catButton.isUserInteractionEnabled = false
        self.accountButton.isUserInteractionEnabled = false
        self.menuButton.isUserInteractionEnabled = false
        self.panGestureRecognizer.isEnabled = false
        self.introLabelTop.constant = 50
        self.startRatingButton.alpha = 0
        self.activityIndicator.alpha = 0
        self.startRatingButton.isUserInteractionEnabled = false
        self.introLabel.layer.borderWidth = 2
        self.introLabel.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        self.introLabel.layer.cornerRadius = 25
        self.introLabel.layer.backgroundColor = CGColor.init(srgbRed: 255, green: 255, blue: 255, alpha: 1)
        print("before if statements: \(self.introAnimationIndex)")
        if self.introAnimationIndex == 0 {
            self.introArrowBottom.isActive = true
            self.introArrowBottom.constant = 0
            self.introLabel.text = "Welcome To Rate My Pets\nWhere you can rate pets as cute or not"
            self.card.alpha = 0.6
            self.nextView.alpha = 0
            self.navBarTexture.alpha = 0.6
            self.catButton.alpha = 0.6
            self.likeButton.alpha = 0.6
            self.dislikeButton.alpha = 0.6
            self.accountButton.alpha = 0.6
            self.activityIndicator.alpha = 0
            self.introArrow.transform = CGAffineTransform(rotationAngle: 0.785)
            var resetPoint = self.introArrow.center
            UIView.animateKeyframes(withDuration: 2, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    self.introArrow.transform = CGAffineTransform(translationX: 0, y: -15).rotated(by: 0.785)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1) {
                    self.introArrow.transform = CGAffineTransform(translationX: 0, y: 15).rotated(by: 0.785)                }
            }) { (completed) in
                
            }
        }
        if self.introAnimationIndex == 1{
            self.introArrow.layer.removeAllAnimations()
            self.cuteOrNoY.constant = -90
            print("Animation Two")
            self.card.alpha = 1
            self.cuteOrNo.alpha = 0
            self.introLabel.text = "Swipe right to rate the current pet cute and left to rate not cute"
            let cuteImage = UIImage(named: "cuteT")
            let nopeImage = UIImage(named: "nopeT")
            UIView.animateKeyframes(withDuration: 8, delay: 0.0, options: [.repeat, .calculationModeLinear], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 2, animations: {
                    self.introArrow.transform = CGAffineTransform(translationX: 100, y: 0 ).rotated(by: 0.785)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 2, animations: {
                    self.card.transform = CGAffineTransform(translationX: 100, y: 0).rotated(by: 0.21)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 2, animations: {
                    self.cuteOrNo.image = cuteImage
                })
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 4, animations: {
                    self.card.transform = CGAffineTransform(translationX: -100, y: 0).rotated(by: -0.21)
                    self.introArrow.transform = CGAffineTransform(translationX: -100, y: 0 ).rotated(by: 0.785)
                    self.cuteOrNo.image = nopeImage
                })
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 4, animations: {
                    self.introArrow.transform = CGAffineTransform(translationX: -100, y: 0 ).rotated(by: 0.785)
                })
                UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 4, animations: {
                    self.cuteOrNo.image = nopeImage
                })
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 2, animations: {
                    self.card.transform = CGAffineTransform(translationX: 0, y: 0).rotated(by: 0)
                    self.introArrow.transform = CGAffineTransform(translationX: 0, y: 0 ).rotated(by: 0.785)
                    self.cuteOrNo.image = cuteImage
                })
            }) { (completed) in
                //Completion of whole animation sequence
            }
        }
        if self.introAnimationIndex == 2{
            self.card.layer.removeAllAnimations()
            self.introArrow.layer.removeAllAnimations()
            self.cuteOrNo.alpha = 0
            self.catNameTextField.alpha = 0.6
            self.catAgeTextField.alpha = 0.6
            self.catImageView.alpha = 0.6
            self.menuButton.alpha = 0.6
            self.introArrow.center = self.catStack.center
            self.introArrow.center.x = self.introArrow.center.x - (self.card.frame.width / 4)
            self.introArrow.center.y = self.introArrow.center.y + (self.card.frame.height / 10)
            self.introLabel.text = "Each pet is given a rating of 1-5\n stars based on\n how many users like the cat"
            UIView.animateKeyframes(withDuration: 2, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    self.introArrow.transform = CGAffineTransform(translationX: 0, y: -15).rotated(by: 0.785)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1) {
                    self.introArrow.transform = CGAffineTransform(translationX: 0, y: 6).rotated(by: 0.785)                }
            }) { (completed) in
                
            }
        }
        if self.introAnimationIndex == 3 {
            self.card.layer.removeAllAnimations()
            self.introArrow.layer.removeAllAnimations()
            self.cuteOrNo.alpha = 0
            self.catNameTextField.alpha = 0.6
            self.catAgeTextField.alpha = 0.6
            self.catImageView.alpha = 0.6
            self.starRating.alpha = 0.6
            self.menuButton.alpha = 1
            self.introArrow.center.x = self.menuButton.center.x
            self.introArrow.center.y = self.introArrow.center.y + (self.catStack.frame.height / 5)
            self.introLabel.text = "If a pet's name or image is inappropriate, press the three dots to report the pet"
            UIView.animateKeyframes(withDuration: 2, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    self.introArrow.transform = CGAffineTransform(translationX: 0, y: -15).rotated(by: 0.785)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1) {
                    self.introArrow.transform = CGAffineTransform(translationX: 0, y: 6).rotated(by: 0.785)
                }
            }) { (completed) in
                
            }
        }
        if self.introAnimationIndex == 4 {
            self.card.layer.removeAllAnimations()
            self.introArrow.layer.removeAllAnimations()
            self.startRatingButton.alpha = 1
            self.accountButton.alpha = 1
            self.startRatingButton.isUserInteractionEnabled = true
            self.nextIntroButton.isUserInteractionEnabled = false
            self.nextIntroButton.alpha = 0
            self.skipButton.isUserInteractionEnabled = false
            self.skipButton.alpha = 0
            self.cuteOrNo.alpha = 0
            self.introArrow.center.x = self.accountButton.center.x - (self.accountButton.frame.width / 2)
            self.introArrow.center.y = self.accountButton.center.y - (self.accountButton.frame.height)
            self.introLabel.text = "To add your own pet, press the account button and create an account"
            UIView.animateKeyframes(withDuration: 2, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    self.introArrow.transform = CGAffineTransform(translationX: 0, y: -15).rotated(by: 0.785)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 1) {
                    self.introArrow.transform = CGAffineTransform(translationX: 0, y: 6).rotated(by: 0.785)
                }
            }) { (completed) in
                
            }
        }
    }

    func finishAnimating() {
        self.animTwo.stopAnimation(false)
        self.introView.alpha = 0
        self.likeButton.isUserInteractionEnabled = true
        self.dislikeButton.isUserInteractionEnabled = true
        self.catButton.isUserInteractionEnabled = true
        self.accountButton.isUserInteractionEnabled = true
        self.panGestureRecognizer.isEnabled = true
        self.menuButton.isUserInteractionEnabled = true
        self.card.alpha = 1
        self.nextView.alpha = 1
        self.navBarTexture.alpha = 1
        self.catButton.alpha = 1
        self.likeButton.alpha = 1
        self.dislikeButton.alpha = 1
        self.accountButton.alpha = 1
        self.catNameTextField.alpha = 1
        self.catAgeTextField.alpha = 1
        self.catImageView.alpha = 1
        self.starRating.alpha = 1
        self.menuButton.alpha = 1
        self.cuteOrNoY.constant = -140
        self.introArrow.layer.removeAllAnimations()
        self.card.layer.removeAllAnimations()
        if activityIndicator.isAnimating == true{
            self.activityIndicator.alpha = 1
        }else{
            self.activityIndicator.alpha = 0
        }
    }
    
    @IBAction func nextIntroButtonTapped(_ sender: Any) {
        self.introAnimationIndex += 1
        print("self.introAnimationIndex: \(self.introAnimationIndex)")
        if self.introAnimationIndex == 1{
            let difference = -1 * ((self.card.frame.height / 2) - self.introArrowBottom.constant)
            UIView.animate(withDuration: 0.3, animations: {
                self.introArrowBottom.constant = self.card.frame.height / 2
            }) { finished in
                self.introAnimation()
            }
        }
        if self.introAnimationIndex == 2 {
            self.introAnimation()
        }
        if self.introAnimationIndex == 3 {
            self.introAnimation()
        }
        if self.introAnimationIndex == 4 {
            self.introAnimation()
        }
        if self.introAnimationIndex > 4 {
            self.finishAnimating()
        }
    }
    
    @IBAction func skipIntroButtonTapped(_ sender: Any) {
        self.card.transform = CGAffineTransform(rotationAngle: 0)
        self.card.center = self.nextView.center
        self.cuteOrNo.alpha = 0
        self.introAnimationIndex = -1
        self.finishAnimating()
    }
    
    func setUpElements(){
        self.introView.alpha = 0
        self.startRatingButton.alpha = 0
        let screenHeight = CGFloat(UIScreen.main.bounds.height)
        let screenWidth = CGFloat(UIScreen.main.bounds.width)
        print("before: \(screenHeight)")
        //adjust storyboard to screen size
        self.screenSizeRatio = Float(screenHeight/812)
        self.cardHeight.constant = ((screenHeight/812) * cardHeight.constant)
        self.cardWidth.constant = ((screenWidth/375) * cardWidth.constant)
        self.cuteOrNoWidth.constant = ((screenHeight/812) * cuteOrNoWidth.constant)
        self.cuteOrNoHeight.constant = ((screenHeight/812) * cuteOrNoHeight.constant)
        self.catStackBottom.constant = ((screenHeight/812) * catStackBottom.constant)
        self.catStackLeading.constant = CGFloat((powf((1/screenSizeRatio), 2.6) * 28))
        self.catStackHeight.constant = CGFloat(self.catStackHeight.constant * CGFloat(self.screenSizeRatio))
        self.noInternetX.constant = 500
        print("hhh: \(self.catStackLeading.constant)")
        print("after \(cardHeight.constant)")//
        self.catAgeTextField.textColor = .white
        self.catNameTextField.textColor = .white
        let user = Auth.auth().currentUser
        Utilities.styleOrangeButton(self.refreshButton)
        //set up next cat image view
        self.nextView.frame = self.card.frame
        self.card.layer.borderWidth = 2
        self.card.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        self.card.layer.cornerRadius = 20
        self.card.clipsToBounds = true
        self.nextView.layer.borderWidth = 2
        self.nextView.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        self.nextView.layer.cornerRadius = 20
        self.nextView.clipsToBounds = true
        print("card h: \(self.cardHeight.constant) w: \(self.cardWidth.constant)")
        if user != nil{
            db.collection("users").document(user!.uid).getDocument { (snapshot, error) in
                let isMod = snapshot?.get("isMod") as! Bool
                if isMod == false{
                    self.isModerator = false
                }else{
                    self.isModerator = true
                }
            }
            /*loginButton.alpha = 0
             loginButton.isUserInteractionEnabled = false*/
        }else{
        }
        /*self.standardCatStackTop = Float(self.catStackTop.constant)
         self.card.layer.borderWidth = 2
         self.card.layer.borderColor = UIColor.black.cgColor*/
        
    }
    func showNoInternet() {
        print("no internet")
        self.card.alpha = 0
        self.nextView.alpha = 0
        self.likeButton.alpha = 0
        self.dislikeButton.alpha = 0
        self.activityIndicator.alpha = 0
        self.noInternetX.constant = 0
        self.noInternetY.constant = -100
        self.noInternetView.alpha = 1
        self.likeButton.isUserInteractionEnabled = false
        self.dislikeButton.isUserInteractionEnabled = false
    }
    
    func main(kat: [cat]){
        if Utilities.globalVariables.catViewIndex <= kat.count{
            displayCat(kats: kat, ind: Utilities.globalVariables.catViewIndex,isReal: isReloading)}
        else {print("That's all folks")}
    }
    
    func reload(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.alpha = 1
        self.card.alpha = 0
        self.activityIndicator.startAnimating()
        let connectRef = Database.database().reference(withPath: ".info/connected")
        connectRef.observe(.value) { (snapshot) in
            if snapshot.value as? Bool ?? false {
                print("connected")
            }else{
                print("not connected")
                self.showNoInternet()
            }
        }
        Utilities.globalVariables.catViewCats.removeAll()
        Utilities.globalVariables.catViewIndex = 0
        Utilities.globalVariables.catViewCatImages.removeAll()
        let storage = Storage.storage()
        self.card.alpha = 1
        self.likeButton.alpha = 1
        self.dislikeButton.alpha = 1
        self.noInternetView.alpha = 0
        self.noInternetX.constant = 500
        view.backgroundColor = .white
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        db.collection("cats").getDocuments { (snapshots, err) in
            if err == nil{
                var i = 1
                for document in snapshots!.documents{
                    let age = document.get("age")
                    let name = document.get("name")
                    let avgr = document.get("averageRating")
                    let nar = document.get("numberOfRatings")
                    let iurl = document.get("url")
                    let idd = document.get("id")
                    let par = document.get("parentID")
                    let al = document.get("numberOfLikes")
                    let ad = document.get("numberOfDislikes")
                    if age == nil || name == nil || avgr == nil || nar == nil || iurl == nil || idd == nil || par == nil || al == nil || ad == nil{
                        print("cat was nil")
                    }else{
                        let temp : cat = cat(ag: age as! Int, nm: name as! String, avr: avgr as! String, nor: nar as! Int, url: iurl as! String, id: idd as! String, pd: par as! String, aol: al as! Int, aod: ad as! Int, downloadPrior: false)
                        let tempRef = storage.reference(forURL: iurl as! String)
                        tempRef.getData(maxSize: 1 * 1920 * 1920) { (data, dataError) in
                            if let dataError = dataError {
                                print(dataError.localizedDescription)
                            }else{
                                Utilities.globalVariables.catViewCats.append(temp)
                                Utilities.globalVariables.catViewCatImages.append(UIImage(data: data!)!)
                                if Utilities.globalVariables.catViewCatImages.count == 5{
                                    self.displayCat(kats: Utilities.globalVariables.catViewCats, ind: Utilities.globalVariables.catViewIndex, isReal: false)
                                }
                            }
                        }
                    }
                    
                    i = i + 1
                }
            }
        }
    }
    
    func transitionToSignInSecond(){
        let secondSignInViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.signInSecondViewController) as? secondSignInViewController
        
        view.window?.rootViewController = secondSignInViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToAccountScreen(){
        let accountViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.accountViewController) as? AccountViewController
        
        view.window?.rootViewController = accountViewController
        view.window?.makeKeyAndVisible()
    }
    
    func displayCat(kats : [cat], ind : Int, isReal : Bool){
        self.catStack.alpha = 1
        self.nextView.alpha = 1
        self.card.alpha = 1
        self.card.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 60)
        self.card.transform = CGAffineTransform(rotationAngle: 0)
        self.nextViewX.constant = 0
        self.nextViewY.constant = -80
        self.nextCatImageView.alpha = 1
        //let temp = kats.shuffled()
        print("is first launch: \(Utilities.globalVariables.isFirstLaunch)")
        if Utilities.globalVariables.isFirstLaunch == true{
            print("Showing intro animation")
            self.introAnimation()
            Utilities.globalVariables.isFirstLaunch = false
        }
        let temp = kats
        if Utilities.globalVariables.catViewIndex < temp.count {
            self.likeButton.isUserInteractionEnabled = true
            self.dislikeButton.isUserInteractionEnabled = true
            self.catAgeTextField.isHidden = true
            self.catNameTextField.isHidden = true
            self.starRating.isHidden = true
            wereDone = false
            self.activityIndicator.isHidden = false
            let aol = Utilities.globalVariables.catViewCats[Utilities.globalVariables.catViewIndex].getLikes()
            let aod = Utilities.globalVariables.catViewCats[Utilities.globalVariables.catViewIndex].getDislikes()
            self.starRating.image = getStar(L: aol, D: aod)
            self.imageView.isHidden = false
            let displayName : String = temp[ind].getName()
            let displayAge : Int = temp[ind].getAge()
            print("name: \(displayName)")
            let avgr : String = temp[Utilities.globalVariables.catViewIndex].getAvgRatingAsInt()
            let avgrAsNs : NSString = avgr as NSString
            var nameFontSize : CGFloat = CGFloat(42 * self.screenSizeRatio )
            var ageFontSize : CGFloat = CGFloat(26 * self.screenSizeRatio )
            if self.screenSizeRatio >= 0.99{
                nameFontSize = CGFloat(41 * self.screenSizeRatio * 1.2)
                ageFontSize = CGFloat(25 * self.screenSizeRatio * 1.2)
                
            }
            if nameFontSize > 45 {nameFontSize = 45}
            if ageFontSize > 27 || ageFontSize < 23 {ageFontSize = 27}
            print("name font size: \(nameFontSize) age font size: \(ageFontSize)")
            let nameFont = UIFont(name: "Avenir-Heavy", size: nameFontSize)
            let ageFont = UIFont(name: "Avenir-Heavy", size: ageFontSize)
            let name = NSAttributedString(string: "\(displayName)", attributes: [NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeWidth: -3, NSAttributedString.Key.font:
                nameFont!])
            var age = NSAttributedString(string: " \(displayAge)", attributes: [NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeWidth: -3, NSAttributedString.Key.font:
                ageFont!])
       
            catNameTextField.text = ""
            catNameTextField.attributedText = name
            catAgeTextField.text = ""
            catAgeTextField.attributedText = age
            catAgeTextField.text = "Age: \(displayAge)"
            if self.isModerator == true{
                print("moderator text")
                let total = temp[ind].getLikes() + temp[ind].getDislikes()
                let likes = temp[ind].getLikes()
                age = NSAttributedString(string: "TV: \(total) avg: \(Float(Float(likes)/Float(total)))", attributes: [NSAttributedString.Key.strokeColor: UIColor.black, NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.strokeWidth: -3, NSAttributedString.Key.font:
                    ageFont!])
                catAgeTextField.attributedText = age
            }
            //let urlTwo = URL(string: Utilities.globalVariables.catViewCats[(Utilities.globalVariables.catViewIndex + 1)].getURL())
            
            
            let urls  = temp[Utilities.globalVariables.catViewIndex].getURL()
            let urld = URL(string: urls)!
            self.imageView.alpha = 1
            self.activityIndicator.stopAnimating()
            self.activityIndicator.alpha = 0
            print("index: \(ind) catImages.count: \(Utilities.globalVariables.catViewCatImages.count)")
            self.imageView.image = Utilities.globalVariables.catViewCatImages[ind]
            var tempI = self.imageView.image
            if tempI != nil {
                let onePlus = 1 + ind
                if onePlus < Utilities.globalVariables.catViewCatImages.count {
                    let nextImg = Utilities.globalVariables.catViewCatImages[onePlus]
                    if nextImg != nil {
                        self.nextCatImageView.image = nextImg
                    }
                }
                if self.screenSizeRatio >= 1{
                    tempI = tempI as? UIImage
                    let tempAsp : Float = Float(tempI!.size.height/tempI!.size.width)
                    print("whitespace left: \(self.imageView.getWhiteSpaceLeft()) whitespace botton: \(self.imageView.getWhiteSpaceBotton())")
                    print("current aspect ratio: \(tempAsp)")
                    print("current screen sise ratio: \(self.screenSizeRatio)")
                    let tempScale = self.imageView.image?.scale
                    print("scale: \(tempScale)")
                    if tempAsp <= 1.1 && tempAsp > 0.1 {
                        self.catStackBottom.constant = CGFloat(10 + self.imageView.getWhiteSpaceBotton())
                        self.catStackLeading.constant = CGFloat(self.imageView.getWhiteSpaceLeft() + 10)
                    }else if tempAsp > 1.1{
                        let const = log(tempAsp)
                        self.catStackBottom.constant = CGFloat(10 + self.imageView.getWhiteSpaceBotton())
                        self.catStackLeading.constant = CGFloat(self.imageView.getWhiteSpaceLeft() + 10)
                        print("catStackLeading: \(self.catStackLeading.constant)")
                    }
                }else{
                    tempI = tempI as? UIImage
                    let tempAsp : Float = Float(tempI!.size.height/tempI!.size.width)
                    print("whitespace left: \(self.imageView.getWhiteSpaceLeft()) whitespace botton: \(self.imageView.getWhiteSpaceBotton())")
                    print("current aspect ratio: \(tempAsp)")
                    print("current screen sise ratio: \(self.screenSizeRatio)")
                    let tempScale = self.imageView.image?.scale
                    print("scale: \(tempScale)")
                    if tempAsp <= 1.1 && tempAsp > 0.1 {
                        self.catStackBottom.constant = CGFloat(10 + self.imageView.getWhiteSpaceBotton())
                        self.catStackLeading.constant = CGFloat(self.imageView.getWhiteSpaceLeft() + 10)
                    }else if tempAsp > 1.1{
                        let const = log(tempAsp)
                        self.catStackBottom.constant = CGFloat(10 + self.imageView.getWhiteSpaceBotton())
                        self.catStackLeading.constant = CGFloat(self.imageView.getWhiteSpaceLeft() + 10)
                        print("catStackLeading: \(self.catStackLeading.constant)")
                    }
                }
            }else{
                self.displayNext()
            }
        }else{
            self.reload()
        }
        
        self.catAgeTextField.isHidden = false
        self.catNameTextField.isHidden = false
        self.starRating.isHidden = false
    }
    
    @IBAction func startRatingTapped(_ sender: Any) {
        self.finishAnimating()
    }
    
    func sortByHighestRating() {
        var temp = Utilities.globalVariables.catViewCats
        var x : Int = 0
        var final : [cat] = []
        while x < temp.count{
            var highestCat : cat = temp[0]
            var highestCatIndex : Int = 0
            var i = 0
            while i < temp.count{
                if temp[i].getAVGRASFloat() > highestCat.getAVGRASFloat(){
                    highestCat = temp[i]
                    highestCatIndex = i
                }
                i += 1
            }
            final.append(highestCat)
            temp.remove(at: highestCatIndex)
            x += 1
        }
        Utilities.globalVariables.catViewCats.removeAll()
        Utilities.globalVariables.catViewCats = final
    }
    
    
    @IBAction func pullDown(_ sender: Any) {
        isReloading = true
        self.reload()
        self.catNameTextField.alpha = 1
        self.catAgeTextField.isHidden = false
        self.imageView.isHidden = false
        isReloading = false
    }
    
    @IBAction func swipedLeft(_ sender: Any) {
        let temper = Auth.auth().currentUser
        if temper == nil{
            transitionToSignInSecond()
        }else{transitionToAccountScreen()}
    }
    func displayNext(){
        Utilities.globalVariables.catViewIndex += 1
        displayCat(kats: Utilities.globalVariables.catViewCats, ind: Utilities.globalVariables.catViewIndex, isReal: false)
    }
    func addDislike(){
        self.activityIndicator.alpha = 1
        self.activityIndicator.isHidden = false
        self.cuteOrNo.alpha = 0
        self.imageView.alpha = 0
        self.catStack.alpha = 0
        self.activityIndicator.startAnimating()
        //  self.card.transform = CGAffineTransform(rotationAngle: 0.61)
        let ind = Utilities.globalVariables.catViewIndex
        let id : String = Utilities.globalVariables.catViewCats[ind].getCID()
        self.displayNext()
        db.collection("cats").document(id).getDocument { (document, err) in
            if err != nil{
                print(err?.localizedDescription)
            }else{
                let currentDislikes = document!.get("numberOfDislikes")
                if currentDislikes != nil{
                    let finalDisklikes = currentDislikes as! Int + 1
                    self.db.collection("cats").document(id).updateData(["numberOfDislikes" : finalDisklikes]) { (error) in
                        if error != nil{
                            print(error?.localizedDescription)
                        }else{
                            let finalLikes = document!.get("numberOfLikes") as! Int
                            let total = finalDisklikes + finalLikes
                            if total % 5 == 0{
                                print("notification if statement")
                                var registrationToken = document!.get("deviceTokenID")
                                let catName = document!.get("name") as! String
                                if registrationToken != nil {
                                    print("sending notification")
                                    let sender = PushNotificationSender()
                                    sender.sendPushNotification(to: registrationToken as! String, title: "\(catName) has new ratings!", body: "Login to chek out what they are")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func addLike(){
        self.cuteOrNo.alpha = 0
        self.activityIndicator.alpha = 1
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.catStack.alpha = 0
        let ind = Utilities.globalVariables.catViewIndex
        self.imageView.alpha = 0
        let id : String = Utilities.globalVariables.catViewCats[ind].getCID()
        // self.card.transform = CGAffineTransform(rotationAngle: -0.61)
        self.displayNext()
        db.collection("cats").document(id).getDocument { (document, err) in
            if err != nil{
                print(err?.localizedDescription)
            }else{
                let currentLikes = document!.get("numberOfLikes")
                if currentLikes != nil{
                    let finalLikes = (currentLikes as! Int) + 1
                    self.db.collection("cats").document(id).updateData(["numberOfLikes" : finalLikes]) { (error) in
                        if error != nil{
                            print(error?.localizedDescription)
                        }else{
                            let finalDislikes = document!.get("numberOfDislikes") as! Int
                            let total = finalDislikes + finalLikes
                            if total % 5 == 0{
                                print("notification if statement")
                                var registrationToken = document!.get("deviceTokenID")
                                let catName = document!.get("name") as! String
                                if registrationToken != nil {
                                    print("sending notification")
                                    let sender = PushNotificationSender()
                                    sender.sendPushNotification(to: registrationToken as! String, title: "\(catName) has new ratings!", body: "Login to chek out what they are")
                                }else{
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func getStar(L: Int, D: Int) -> UIImage{
        if L + D != 0{
            var lD : Float = Float(L)
            var dD : Float = Float(D)
            var percentL : Float = Float((lD/(lD+dD))*100)
            print("percentL: \(percentL) l: \(lD) d: \(dD)")
            if percentL < self.one {return UIImage(named: "oneStar")!}
            else if percentL >= self.one && percentL < self.two {return UIImage(named: "twoStar")!}
            else if percentL >= self.two && percentL < self.three {return UIImage(named: "threeStar")!}
            else if percentL >= self.three && percentL < self.four {return UIImage(named: "fourStar")!}
            else {return UIImage(named: "fiveStar")!}
        }else{return UIImage(named: "zeroStar")!}
    }
    
    @IBAction func accountButtonTapped(_ sender: Any) {
        let temp = Auth.auth().currentUser
        if temp == nil{
            transitionToSignInSecond()
        }else{
            transitionToAccountScreen()
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let user = Auth.auth().currentUser
        if user != nil{
            self.transitionToAccountScreen()
        }else{
            self.transitionToSignInSecond()
        }
        
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let cuteImage = UIImage(named: "cuteT")
        let nopeImage = UIImage(named: "nopeT")
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + (point.y - 100))
        if xFromCenter > 5{
            self.cuteOrNo.image = cuteImage
            self.cuteOrNo.tintColor = .green
            card.transform = CGAffineTransform(rotationAngle: 0.61*((xFromCenter)/(view.frame.width)))
            let dist = abs(xFromCenter)
            let percent = 3*(dist/(view.frame.width))
            if percent <= 1{
                self.cuteOrNo.alpha = percent
            }
        }else if xFromCenter < -5{
            self.cuteOrNo.image = nopeImage
            self.cuteOrNo.tintColor = .red
            card.transform = CGAffineTransform(rotationAngle: 0.61*((xFromCenter)/(view.frame.width)))
            
            let dist = abs(xFromCenter)
            let percent = 3*(dist/(view.frame.width))
            if percent <= 1{
                self.cuteOrNo.alpha = percent
            }
        }else{
            self.cuteOrNo.alpha = 0
            card.transform = CGAffineTransform(rotationAngle: 0)
        }
        
        if sender.state == UIGestureRecognizer.State.ended {
            print("ended")
            self.cuteOrNo.alpha = 0
            card.transform = CGAffineTransform(rotationAngle: 0)
            if card.center.x < 75{
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 400, y: card.center.y - 80)
                    card.transform = CGAffineTransform(rotationAngle: -0.61)
                    self.cuteOrNo.alpha = 1
                    self.cuteOrNo.image = nopeImage
                }) {finished in
                    self.addDislike()
                    self.card.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 60)
                }
            }else if card.center.x > (view.frame.width - 75){
                UIView.animate(withDuration: 0.3, animations: {
                    self.cuteOrNo.alpha = 1
                    self.cuteOrNo.image = cuteImage
                    card.center = CGPoint(x: card.center.x + 400, y: card.center.y + 75)
                    card.transform = CGAffineTransform(rotationAngle: 0.61)
                }) {finished in
                    self.addLike()
                    self.card.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 60)
                }
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    card.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 80)
                })
            }
        }
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        self.reload()
    }
    
    @IBAction func dislikeButtonTapped(_ sender: Any) {
        self.card.layoutIfNeeded()
        let transform : CGAffineTransform = CGAffineTransform(translationX: -500, y: 0).rotated(by: -0.61)
        UIView.animate(withDuration: 0.5, animations: {
            self.card.transform = transform
            self.cuteOrNo.alpha = 1
            self.cuteOrNo.image = UIImage(named: "nopeT")
            self.card.layoutIfNeeded()
        }) { finished in
            self.addDislike()
            self.cuteOrNo.alpha = 0
            self.card.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 80)
            self.card.layoutIfNeeded()
            return
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        self.card.layoutIfNeeded()
        let transform : CGAffineTransform = CGAffineTransform(translationX: 500, y: 0).rotated(by: 0.61)
        UIView.animate(withDuration: 0.5, animations: {
            self.card.transform = transform
            self.cuteOrNo.alpha = 1
            self.cuteOrNo.image = UIImage(named: "cuteT")
            self.card.layoutIfNeeded()
        }) { finished in
            self.card.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 80)
            self.cuteOrNo.alpha = 0
            self.addLike()
            self.card.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 80)
            return
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(origin: self.view.center, size: CGSize.zero)
        
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Report Pet", comment: ""), style: .default) { _ in
            self.transitionToReportVC()
        })
        
        if self.isModerator == true{
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Reported Pets", comment: ""), style: .default) { _ in
                self.transitionToReportedVC()
            })
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Test No Internet", comment: ""), style: .default) { _ in
                self.showNoInternet()
            })
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Test Intro Animation", comment: ""), style: .default) { _ in
                self.introAnimationIndex = 0
                self.introAnimation()
            })
        }
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func closeMenuTapped(_ sender: Any) {
    }
    
    func transitionToReportVC(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ReportVC") as? ReportViewController {
            self.present(viewController, animated: true, completion: nil)
            viewController.reloadInputViews()
        }
    }
    func transitionToReportedVC(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ReportedVC") as? ReportedCatsViewController {
            self.present(viewController, animated: true, completion: nil)
            viewController.reloadInputViews()
        }
    }
}
class cat{
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    var age : Int
    var name : String
    var averageRating : String
    var numberOfRatings : Int
    var imgURL : String
    var cID : String
    var pID : String
    var likes : Int
    var dislikes : Int
    var image : UIImage
    var deviceToken : String
    var downloadedPrior : Bool
    
    init(ag : Int,nm: String,avr : String, nor : Int, url : String, id : String, pd : String, aol: Int, aod: Int, downloadPrior: Bool) {
        age = ag
        name = nm
        numberOfRatings = nor
        averageRating = avr
        imgURL = url
        cID = id
        pID = pd
        likes = aol
        dislikes = aod
        deviceToken = "nil"
        image = UIImage()
        downloadedPrior = downloadPrior
        if downloadPrior == true{
            downloadCatImage(url: imgURL)
        }
        return
    }
    
    func getName() -> String{return name}
    func getAge() -> Int{return age}
    func getURL() -> String{return imgURL}
    func getAvgRatingAsInt() -> String{return averageRating}
    func getCID() -> String{return cID}
    func getNOR() -> Int{return numberOfRatings}
    func getPID() -> String{return pID}
    func getAVGRASFloat() -> Float{return Float(averageRating) as! Float}
    func getLikes() -> Int{return likes}
    func getDislikes() -> Int{return dislikes}
    func getDeviceToken() -> String{return deviceToken}
    func getImage() -> UIImage{return image}
    func getDownloadPrior() -> Bool{return downloadedPrior}
    
    func setLocalToken(tid : String){
        self.deviceToken = tid
    }
    
    func setParentToken(tid : String){
        Firestore.firestore().collection("cats").document(cID).getDocument { (document, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                Firestore.firestore().collection("cats").document(self.cID).updateData(["deviceTokenID" : tid]) { (err) in
                    if err != nil{
                        print(err?.localizedDescription)
                    }
                }
            }
        }
    }
    
    func addNewRating(newRating : Int){
        let temp : NSString = averageRating as NSString
        var avgr = temp.floatValue
        avgr = ((avgr * Float(numberOfRatings)) + Float(newRating))/Float(numberOfRatings + 1)
        let tempp : String = "\(avgr)"
        numberOfRatings += 1
        db.collection("cats").document(cID).updateData(["averageRating" :  tempp,"numberOfRatings":numberOfRatings]) { (error) in
            if error != nil{print(error!)}
        }
        if numberOfRatings % 5 == 0{
            print("notification if statement: \(self.deviceToken)")
            var registrationToken = self.deviceToken
            if self.deviceToken != "nil" {
                print("sending notification")
                let sender = PushNotificationSender()
                sender.sendPushNotification(to: self.deviceToken, title: "New Ratings", body: "Your Cat Has New Ratings")
            }
        }
    }
    func downloadCatImage(url: String)  {
        let storage = Storage.storage()
        let tempRef = storage.reference(forURL: url as! String)
        tempRef.getData(maxSize: 1 * 1920 * 1920) { (data, dataError) in
            if let dataError = dataError {
                print(dataError.localizedDescription)
            }else{
                self.image = UIImage(data: data!)!
                if self.downloadedPrior == true{
                    Utilities.globalVariables.numberOfAccountCatImagesDownloaded += 1
                }
            }
        }
    }
}
class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        print("send push notification called")
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body, "sound" : "default"],
                                           "data" : ["user" : "test_id"],
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAG4XTOSA:APA91bFUQZzIed4WK1cWQM64C2LaA5G8SEMoFPjwH-BwbantGDppxISPANgxmSAAD2bryMAJqMocKgMOg5-H-7ekDm6M2efRRK0V92D26ORJJ0HYE7EVTGkQxYeCMRDxrOCnTv-fq4nF", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
extension UIImageView {
    func getScaledImageSize() -> CGRect? {
        if let image = self.image {
            return AVMakeRect(aspectRatio: image.size, insideRect: self.frame);
        }
        
        return nil;
    }
    func getWhiteSpaceLeft() -> CGFloat {
        if let size = self.getScaledImageSize() {
            if (self.frame.width - size.width) > 0 {
                return (self.frame.width - size.width) / 2;
            } else {
                return 0;
            }
        }
        return 0;
    }
    func getWhiteSpaceBotton() -> CGFloat {
        if let size = self.getScaledImageSize() {
            if (self.frame.height - size.height) > 0 {
                return (self.frame.height - size.height) / 2;
            } else {
                return 0;
            }
        }
        return 0;
    }
}
extension UIViewPropertyAnimator {
    
}
