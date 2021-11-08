//
//  Utilities.swift
//  Rate My Cat
//

//  Created by Matthew Mandelbaum on 1/6/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
       struct globalVariables{
        static var isFirstLaunch : Bool = false
        static var currentCatID : String = ""
        static var catViewIndex : Int = 0
        static var accountIndex : Int = 0
        static var catViewCats : [cat] = []
        static var videoIndex : Int = 0
        static var videos : [video] = []
        static var accountViewCats : [cat] = []
        static var accountViewCatsImages : [UIImage] = []
        static var reportedCats : [cat] = []
        static var justCameFromAccountView : Bool = false
        static var deviceTokenID : String = ""
        static var imageAspectRatio : Float = 0
        static var catViewCatImages : [UIImage] = []
        static var currenAccountCat : cat = cat(ag: 1, nm: "", avr: "", nor: 1, url: "", id: "", pd: "", aol: 0, aod: 0, downloadPrior: false)
        static var currentAccountCatImage : UIImage = UIImage()
        static var accountUsername : String = ""
        static var numberOfAccountCatImagesDownloaded : Int = 0
        static var sendToUpdatePassword : Bool = false
        static var justAddedCat : Bool = false
        
      }
    static func styleBlackTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        textfield.borderStyle = .none
        textfield.textColor = .black
        textfield.font = UIFont(name: "Avenir Book", size: 20)
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleOrangeTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 249/255, green: 105/255, blue: 34/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        textfield.textColor = .black
        textfield.font = UIFont(name: "Avenir Book", size: 20)
        textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])

        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleOrangeButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 249/255, green: 105/255, blue: 34/255, alpha: 1)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont(name: "Avenir Book", size: 20)
        button.titleLabel?.attributedText = NSAttributedString(string: button.titleLabel!.text!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func calculateRating(L : Float, D : Float) -> Int{
        if L + D != 0{
        var percentL : Float = (L/(L+D))*100
        if percentL < 30 {return 1}
        else if percentL >= 30 && percentL < 50 {return 2}
        else if percentL >= 50 && percentL < 65 {return 3}
        else if percentL >= 65 && percentL < 80 {return 4}
        else {return 5}
        }else{return 0}
    }
    
    func getStar(L: Int, D: Int) -> UIImage{
        if L + D != 0{
            var percentL : Float = Float((L/(L+D))*100)
        if percentL < 30 {return UIImage(named: "oneStar")!}
        else if percentL >= 30 && percentL < 50 {return UIImage(named: "twoStar")!}
        else if percentL >= 50 && percentL < 65 {return UIImage(named: "threeStar")!}
        else if percentL >= 65 && percentL < 80 {return UIImage(named: "fourStar")!}
        else {return UIImage(named: "fiveStar")!}
        }else{return UIImage(named: "zeroStar")!}
    }
    
    static func styleWhiteButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.titleLabel?.font = UIFont(name: "Avenir Book", size: 20)
        button.titleLabel?.attributedText = NSAttributedString(string: button.titleLabel!.text!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        button.tintColor = UIColor.black
    }
    
}
