//
//  SpotDiscoverViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 7/18/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class SpotDiscoverViewController: UIViewController
{
    override func viewDidLoad() {
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
        
        if let font = UIFont(name: "GothamMedium", size: 14) {
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.init(red: 213.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0)]
        }

    }
}
