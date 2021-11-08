//
//  TermsViewController.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 1/18/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    @IBOutlet weak var termsLabel: UILabel!
        
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var termsOfUseLabel: UILabel!
    
    @IBOutlet var swipeGestureRecognizer: UISwipeGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.termsLabel.alpha = 1
        self.termsLabel.textColor = .black
        self.scrollView.contentSize = self.termsLabel.intrinsicContentSize
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func swiped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
