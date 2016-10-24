//
//  SpotDetailViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 10/23/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
class SpotDetailViewController: UIViewController {
    
    var traktData: TraktData!
    var overlay: UIView!
    
    @IBOutlet var titleDescription: UITextView!
    @IBOutlet var votesLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var titleLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(traktData)
        self.imageView.image = traktData.backgroundImage
        self.backgroundImage.image = traktData.backgroundImage
        self.titleLabel.text = traktData.title
        self.titleDescription.text = traktData.titleDescription
        updateVotesLabel(traktData.votes)
        updateRuntimeLabel(traktData.runtime)
        self.updateWithImage(self.backgroundImage.image)
    }
    
    func updateWithImage(_ image: UIImage?) {
        if let imageToDisplay = image {
            overlay = UIView.init(frame: CGRect(x: 0, y: 0, width: (self.backgroundImage?.frame.width)!,height: (self.backgroundImage?.frame.height)!))
            overlay.backgroundColor = UIColor.black
            overlay.alpha = 0.85
            for view in backgroundImage.subviews {
                view.removeFromSuperview()
            }
            backgroundImage.image = imageToDisplay
            backgroundImage.addSubview(overlay)
        }
        else {
            backgroundImage.image = nil
        }
    }
    
    func updateVotesLabel(_ votes: Int!)
    {
        if let votesToDisplay = votes {
            votesLabel.text = String(votesToDisplay)
        }
        else {
            votesLabel.text = nil
        }
    }
    
    func updateRuntimeLabel(_ runtime: Int!)
    {
        if let runtimeToDisplay = runtime {
            runtimeLabel.text = String("\(runtimeToDisplay) Minutes")
            
        }
        else {
            runtimeLabel.text = nil
        }
    }
    
    
}
