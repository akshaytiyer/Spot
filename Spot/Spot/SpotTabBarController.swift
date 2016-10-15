//
//  SpotTabBarController.swift
//  Spot
//
//  Created by Akshay Iyer on 7/18/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class SpotTabBarController: UITabBarController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.tintColor = UIColor.init(red: 30.0/255.0, green: 215.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        self.tabBar.isTranslucent = true
    }
}
