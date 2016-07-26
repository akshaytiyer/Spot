//
//  SpotDiscoverCollectionViewCell.swift
//  Spot
//
//  Created by Akshay Iyer on 7/20/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class SpotDiscoverCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var collectionView: UIView!
    
//UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, myImageView.frame.size.width, myImageView.frame.size.height / 2)]
    
    var overlay: UIView!
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            overlay = UIView.init(frame: CGRectMake(0, 0.6*(self.imageView?.frame.height)!, (self.imageView?.frame.width)!,0.4*(self.imageView?.frame.height)!))
            print(overlay)
            overlay.backgroundColor = UIColor.blackColor()
            overlay.alpha = 0.75
            for view in imageView.subviews {
                view.removeFromSuperview()
            }
            imageView.image = imageToDisplay
            imageView.addSubview(overlay)
        }
        else {
            imageView.image = nil
        }
    }
    
    func addCircleView() {
        let x = (collectionView.frame.width/4)-22
        let y = (3/4*collectionView.frame.height)
        let circleWidth = CGFloat(44)
        let circleHeight = circleWidth
        
        // Create a new CircleView
        let circleView = CircularView(frame: CGRectMake(x,y,circleWidth, circleHeight))
        
        collectionView.addSubview(circleView)
        
        // Animate the drawing of the circle over the course of 1 second
        //circleView.animateCircle(1.0)
    }

}
