//
//  SpotLibraryViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 7/18/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class SpotLibraryViewController: UIViewController
{
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addCircleView()
    }
    
    func addCircleView() {
        let x = (view.frame.width/2)-22
        let y = (view.frame.height/2)-22
        let circleWidth = CGFloat(44)
        let circleHeight = circleWidth
        
        // Create a new CircleView
        let circleView = CircularView(frame: CGRectMake(x,y,circleWidth, circleHeight))
        
        view.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        circleView.animateCircle(1.0)
    }
}