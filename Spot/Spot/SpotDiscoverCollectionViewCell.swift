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
    
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var votesLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    
    var overlay: UIView!
    
    func formatNumber(rating: Double!) ->  String! {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .PercentStyle
        return formatter.stringFromNumber(rating/10)
    }
    
    
    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            overlay = UIView.init(frame: CGRectMake(0, 0.6*(self.imageView?.frame.height)!, (self.imageView?.frame.width)!,0.4*(self.imageView?.frame.height)!))
            overlay.backgroundColor = UIColor.blackColor()
            overlay.alpha = 0.85
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
    
    func updateRatingLabel(rating: Double!)
    {
        if let ratingToDisplay = rating {
            ratingLabel.text = formatNumber(ratingToDisplay)
        }
        else {
            ratingLabel.text = nil
        }
    }
    
    func updateVotesLabel(votes: Int!)
    {
        if let votesToDisplay = votes {
            votesLabel.text = String(votesToDisplay)
        }
        else {
            votesLabel.text = nil
        }
    }
    
    func updateRuntimeLabel(runtime: Int!)
    {
        if let runtimeToDisplay = runtime {
            runtimeLabel.text = String("\(runtimeToDisplay) Minutes")
            
        }
        else {
            runtimeLabel.text = nil
        }
    }
    
    func addCircleView(rating: Double!) {
        let x = 0.03*(self.imageView?.frame.height)!
        let y = 0.65*(self.imageView?.frame.height)!
        let circleHeight = 0.25*(self.imageView?.frame.height)!
        let circleWidth = circleHeight
        
        //Create a new CircleView
        let circleView = CircularView(frame: CGRectMake(x,y,circleWidth, circleHeight), percentagevalue: rating)
        
        imageView.addSubview(circleView)
        circleView.animateCircle(1.0)
    }

}
