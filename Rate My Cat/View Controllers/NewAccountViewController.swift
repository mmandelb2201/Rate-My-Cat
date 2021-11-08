//
//  NewAccountViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 12/25/19.
//  Copyright © 2019 Matthew Mandelbaum. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var backButton: UINavigationItem!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
