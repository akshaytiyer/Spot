//
//  CircularView.swift
//  Spot
//
//  Created by Akshay Iyer on 7/19/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class CircularView: UIView
{
    var circleLayer: CAShapeLayer!
    var backgroundLayer: CAShapeLayer!
    var shape: CAShapeLayer!

    init(frame: CGRect, percentagevalue: Double!) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: CGFloat(-0.5 * M_PI), endAngle: CGFloat((2.0 * M_PI * percentagevalue/10) - (0.5 * M_PI)), clockwise: true)
        
        let circlePath2 = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: CGFloat(1.5*M_PI), endAngle: CGFloat(3.5 * M_PI), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.init(red: 30.0/255.0, green: 215.0/255.0, blue: 96.0/255.0, alpha: 1.0).CGColor
        circleLayer.lineWidth = 3.0;
        
        // Setup the CAShapeLayer with the path, colors, and line width
        backgroundLayer = CAShapeLayer()
        backgroundLayer.path = circlePath2.CGPath
        backgroundLayer.fillColor = UIColor.clearColor().CGColor
        backgroundLayer.strokeColor = UIColor.grayColor().CGColor
        backgroundLayer.lineWidth = 3.0;
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = 1.0
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(circleLayer)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        //state = .OptionsVisible
        super.init(coder: aDecoder)
    }
    
    func animateCircle(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1.0
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }
    
}
