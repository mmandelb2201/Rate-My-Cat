//
//  ReportViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 1/26/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ReportViewController: UIViewController {
    
    @IBOutlet weak var reportACatLabel: UILabel!
    
    @IBOutlet weak var whatAreYouReportingLabel: UILabel!
    
    @IBOutlet weak var imageLabel: UIButton!
    
    @IBOutlet weak var nameLabel: UIButton!
    
    @IBOutlet weak var nameImageLabel: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements(){
        Utilities.styleOrangeButton(self.imageLabel)
        Utilities.styleWhiteButton(self.nameLabel)
        Utilities.styleOrangeButton(self.nameImageLabel)
    }
    
    func finished(){
        self.reportACatLabel.alpha = 0
        self.whatAreYouReportingLabel.text = "Thanks you for your report, swipe right or press the back button to go back to rating"
        self.imageLabel.alpha = 0
        self.imageLabel.isUserInteractionEnabled = false
        self.nameImageLabel.alpha = 0
        self.nameImageLabel.isUserInteractionEnabled = false
        self.nameLabel.alpha = 0
        self.nameLabel.isUserInteractionEnabled = false
    }
    
    @IBAction func imageLabelTapped(_ sender: Any) {
        self.finished()
        let id = Utilities.globalVariables.catViewCats[Utilities.globalVariables.catViewIndex].getCID()
        Firestore.firestore().collection("cats").document(id).getDocument { (document, error) in
            if error != nil{print("\(error?.localizedDescription)")}
            else{
                var tomp = document?.get("numberOfImageReports")
                var trum = document?.get("numberOfReports")
                if tomp != nil && trum != nil{
                var temp : Int = tomp as! Int
                temp = temp + 1
                Firestore.firestore().collection("cats").document(id).getDocument { (document, error) in
                    if error != nil{
                        print("\(error?.localizedDescription)")
                    }else{
                        let first : Int = document?.get("numberOfImageReports") as! Int
                        let second : Int = document?.get("numberOfNameReports") as! Int
                        let third : Int = document?.get("numberOfMeanReports") as! Int
                        let trumVersionTwo : Int = trum as! Int
                        let newNumReports = 1 + trumVersionTwo
                        if first == 0 && second == 0 && third == 0{
                            Firestore.firestore().collection("reportedCats").addDocument(data: ["parentID" : id]) { (err) in
                                if err != nil{print("\(err?.localizedDescription)")}
                            }
                        }
                        Firestore.firestore().collection("cats").document(id).updateData(["numberOfImageReports" : temp, "numberOfReports" : newNumReports])
                    }
                    }
                }else{
                    Firestore.firestore().collection("cats").document(id).setData(["numberOfImageReports" : 1, "numberOfNameReports" : 0, "numberOfMeanReports" : 0, "numberOfReports" : 1]) { (ror) in
                        if ror != nil{
                            print(ror?.localizedDescription)
                        }
                    }
                }
            }
        }
        Utilities.globalVariables.catViewIndex += 1
    }
    
    @IBAction func nameLabelTapped(_ sender: Any) {
        self.finished()
        let id = Utilities.globalVariables.catViewCats[Utilities.globalVariables.catViewIndex].getCID()
            Firestore.firestore().collection("cats").document(id).getDocument { (document, error) in
                if error != nil{print("\(error?.localizedDescription)")}
                else{
                    var tomp = document?.get("numberOfNameReports")
                    var trum = document?.get("numberOfReports")
                    if tomp != nil && trum != nil{
                    var temp : Int = tomp as! Int
                    temp = temp + 1
                    Firestore.firestore().collection("cats").document(id).getDocument { (document, error) in
                        if error != nil{
                            print("\(error?.localizedDescription)")
                        }else{
                            let first : Int = document?.get("numberOfImageReports") as! Int
                            let second : Int = document?.get("numberOfNameReports") as! Int
                            let third : Int = document?.get("numberOfMeanReports") as! Int
                            let trumVersionTwo : Int = trum as! Int
                            let newNumReports = 1 + trumVersionTwo
                            if first == 0 && second == 0 && third == 0{
                                Firestore.firestore().collection("reportedCats").addDocument(data: ["parentID" : id]) { (err) in
                                    if err != nil{print("\(err?.localizedDescription)")}
                                }
                            }
                            Firestore.firestore().collection("cats").document(id).updateData(["numberOfNameReports" : temp, "numberOfReports" : newNumReports])
                        }
                        }
                    }else{
                        Firestore.firestore().collection("cats").document(id).setData(["numberOfImageReports" : 0, "numberOfNameReports" : 1, "numberOfMeanReports" : 0, "numberOfReports" : 1]) { (ror) in
                            if ror != nil{
                                print(ror?.localizedDescription)
                            }
                        }
                    }
                }
            }
            Utilities.globalVariables.catViewIndex += 1
    }
    
    @IBAction func nameImageTapped(_ sender: Any) {
        self.finished()
        let id = Utilities.globalVariables.catViewCats[Utilities.globalVariables.catViewIndex].getCID()
            Firestore.firestore().collection("cats").document(id).getDocument { (document, error) in
                if error != nil{print("\(error?.localizedDescription)")}
                else{
                    var tomp = document?.get("numberOfMeanReports")
                    var trum = document?.get("numberOfReports")
                    if tomp != nil && trum != nil{
                    var temp : Int = tomp as! Int
                    var tempVT = temp + 1
                    Firestore.firestore().collection("cats").document(id).getDocument { (document, error) in
                        if error != nil{
                            print("\(error?.localizedDescription)")
                        }else{
                            let first : Int = document?.get("numberOfImageReports") as! Int
                            let second : Int = document?.get("numberOfNameReports") as! Int
                            let third : Int = document?.get("numberOfMeanReports") as! Int
                            let trumVersionTwo : Int = trum as! Int
                            let newNumReports = 1 + trumVersionTwo
                            if first == 0 && second == 0 && third == 0{
                                Firestore.firestore().collection("reportedCats").addDocument(data: ["parentID" : id]) { (err) in
                                    if err != nil{print("\(err?.localizedDescription)")}
                                }
                            }
                            Firestore.firestore().collection("cats").document(id).updateData(["numberOfMeanReports" : tempVT, "numberOfReports" : newNumReports])
                        }
                        }
                    }else{
                        Firestore.firestore().collection("cats").document(id).setData(["numberOfImageReports" : 0, "numberOfNameReports" : 0, "numberOfMeanReports" : 1, "numberOfReports" : 1]) { (ror) in
                            if ror != nil{
                                print(ror?.localizedDescription)
                            }
                        }
                    }
                }
            }
            Utilities.globalVariables.catViewIndex += 1
    }

}
