//
//  ReportedCatsViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 1/28/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import Firebase

class ReportedCatsViewController: UIViewController {
    
    @IBOutlet weak var reportedCatsLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var badButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageReportsLabel: UILabel!
    
    @IBOutlet weak var nameReportsLabel: UILabel!
    
    @IBOutlet weak var otherLabel: UILabel!
    
    var index : Int = 0
    var wereDone : Bool = false
    var reportedDocIds : [String] = []
    
    override func viewDidLoad() {
        let db = Firestore.firestore()
        super.viewDidLoad()
        Utilities.globalVariables.reportedCats.removeAll()
        self.index = 0
        self.wereDone = false
        self.activityIndicator.alpha = 0
        db.collection("cats").whereField("numberOfReports", isGreaterThanOrEqualTo: 1).getDocuments { (snapshots, err) in
            if err != nil{
                print(err?.localizedDescription)
            }else{
                var x : Int = 1
                if snapshots?.documents.count == 0{
                    self.wereDone = true
                    self.displayCats()
                }
                for document in snapshots!.documents {
                    let docID : String = document.documentID
                    self.reportedDocIds.append(docID)
                    let age = document.get("age")
                    let name = document.get("name")
                    let avgr = document.get("averageRating")
                    let nar = document.get("numberOfRatings")
                    let iurl = document.get("url")
                    let idd = document.get("id")
                    let pidd = document.get("parentID")
                    var al = document.get("amountOfLikes")
                    var ad = document.get("amountOfDislikes")
                    if al == nil{al = 0}
                    if ad == nil{ad = 0}
                    print("this is the error cat: \(idd)")
                    if age != nil && name != nil && avgr != nil && nar != nil && iurl != nil && idd != nil && pidd != nil && al != nil && ad != nil {
                        let timp : cat = cat(ag: age as! Int, nm: name as! String, avr: avgr as! String, nor: nar as! Int, url: iurl as! String, id: idd as! String, pd: pidd as! String, aol: al as! Int, aod: ad as! Int, downloadPrior: false)
                        Utilities.globalVariables.reportedCats.append(timp)
                        print("addedCat: \(Utilities.globalVariables.reportedCats.count)")
                        
                    }
                    if x == snapshots!.documents.count {
                        print("we're goin for it: \(Utilities.globalVariables.reportedCats.count)")
                        self.index = 0
                        self.wereDone = false
                        self.displayCats()
                    }
                    else{x = x + 1}
                    
                    print("x: \(x) snapshots.doc: \(snapshots!.documents.count)")
                }
                if snapshots!.documents.count == 0{
                    self.wereDone = true
                    self.displayCats()
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func displayCats(){
        print("index: \(self.index) Ut: \(Utilities.globalVariables.reportedCats.count)")
        if self.index < Utilities.globalVariables.reportedCats.count && self.wereDone == false{
            wereDone = false
            self.imageView.isHidden = false
            self.imageView.image = UIImage()
            let id : String = Utilities.globalVariables.reportedCats[self.index].getCID()
            let displayName : String = Utilities.globalVariables.reportedCats[self.index].getName()
            let displayAge : Int = Utilities.globalVariables.reportedCats[self.index].getAge()
            let urls  = Utilities.globalVariables.reportedCats[self.index].getURL()
            let avgr : String = Utilities.globalVariables.reportedCats[self.index].getAvgRatingAsInt()
            let avgrAsNs : NSString = avgr as NSString
            let avgrAsF = avgrAsNs.integerValue
            self.nameLabel.text = "Name: \(displayName) Age:\(displayName)"
            let urld = URL(string: urls)
            Firestore.firestore().collection("cats").document(id).getDocument { (document, error) in
                if error != nil{
                    print("\(error?.localizedDescription)")
                }else{
                    let tempImageR = document?.get("numberOfImageReports")
                    let tempNameR = document?.get("numberOfNameReports")
                    let tempElseR = document?.get("numberOfMeanReports")
                    if tempImageR != nil && tempNameR != nil && tempElseR != nil{
                        let imageR = tempImageR as! Int
                        let elseR = tempElseR as! Int
                        let nameR = tempNameR as! Int
                        print("name: \(nameR) image: \(imageR) else: \(elseR)")
                        self.nameReportsLabel.text = "Number Of Name Reports: \(nameR)"
                        self.imageReportsLabel.text = "Number Of Image Reports: \(imageR)"
                        self.otherLabel.text = "Number of Harassment Reports: \(elseR)"
                        self.nameLabel.text = "Name: \(displayName) Age: \(displayAge)"
                    }
                    
                }
            }
            self.imageView.downloadImage(from: urld!, actv: self.activityIndicator, imgV : self.imageView, rmv: true
                ,finished: {
                    print("completed")
            })
        }else if Utilities.globalVariables.reportedCats.count == 0{
            self.wereDone = true
            self.imageView.image = UIImage(named: "manCheetah")
            self.nameLabel.text = "All the cats have been deal with"
            self.okButton.isUserInteractionEnabled = false
            self.badButton.isUserInteractionEnabled = false
        }
        else if self.wereDone == true{
            self.imageView.image = UIImage(named: "manCheetah")
            self.nameLabel.text = "All the cats have been deal with"
            self.okButton.isUserInteractionEnabled = false
            self.badButton.isUserInteractionEnabled = false
        }
    }
    
    
    @IBAction func badButtonTapped(_ sender: Any) {
        print("bad button tapped")
        let tempID = Utilities.globalVariables.reportedCats[self.index].getCID()
        let id : String = self.reportedDocIds[index]
        Firestore.firestore().collection("reportedCats").document(id).delete { (err) in
            if err != nil{print("\(err?.localizedDescription)")}
        }
        Firestore.firestore().collection("cats").document(id).getDocument { (doc, err) in
            if err != nil{
                print(err?.localizedDescription)
            }else{
                let temp = doc?.get("parentID")
                if temp != nil{
                    let parentID = temp as! String
                    Firestore.firestore().collection("cats").document(tempID).delete { (err) in
                        if err != nil{
                            print("error deleting cat: \(err?.localizedDescription)")
                        }
                    }
                    Firestore.firestore().collection("users").document(parentID).getDocument { (userDoc, userErr) in
                        if userErr != nil{
                            print(userErr?.localizedDescription)
                        }else{
                            let tempNum = userDoc?.get("numberOfCats")
                            if tempNum != nil{
                                let numOfCats : Int = tempNum as! Int
                                let newNum : Int = numOfCats - 1
                                Firestore.firestore().collection("users").document(parentID).updateData(["numberOfCats" : newNum])
                            }
                        }
                    }
                }
            }
        }
        Firestore.firestore().collection("cats").document(Utilities.globalVariables.reportedCats[self.index].getCID()).delete { (error) in
            if error != nil {print(error?.localizedDescription)}
        }
        let temp = self.index + 1
        if temp == Utilities.globalVariables.reportedCats.count{
            self.wereDone = true
        }
        self.index = temp
        self.displayCats()
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        print("\(self.index) and \(Utilities.globalVariables.reportedCats.count)")
        let tempID = Utilities.globalVariables.reportedCats[self.index].getCID()
        let temp = self.index + 1
        if temp == Utilities.globalVariables.reportedCats.count{
            self.wereDone = true
        }
        self.index = temp
        self.displayCats()
        Firestore.firestore().collection("cats").document(tempID).updateData(["numberOfImageReports" : 0, "numberOfMeanReports" : 0, "numberOfNameReports" : 0, "numberOfReports" : 0]) { (error) in
            if error != nil{print("\(error?.localizedDescription)")}
        }
    }
    
}
