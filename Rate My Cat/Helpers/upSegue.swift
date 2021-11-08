//
//  upSegue.swift
//  Rate My Cat
//
//  Created by Matthew Mandelbaum on 1/7/20.
//  Copyright © 2020 Matthew Mandelbaum. All rights reserved.
//

import Foundation
import UIKit

class upSegue : UIStoryboardSegue {
    
    override func perform() {
        scale()
    }
    func scale(){
        let toViewController = self.destination
        let fromViewController = self.source
        
        /*UIView.animate(withDuration: 0.01, delay: 0, options: .transitionFlipFromBottom, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }) { (success) in
        }*/
        fromViewController.present(toViewController, animated: false, completion: nil)
        
    }
    
}
