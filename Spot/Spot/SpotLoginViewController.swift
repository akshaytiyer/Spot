//
//  SpotLoginViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 8/30/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class SpotLoginViewController: UIViewController {
    
    @IBAction func loginButton(_ sender: AnyObject) {
        TraktClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in

        }

    }
}
