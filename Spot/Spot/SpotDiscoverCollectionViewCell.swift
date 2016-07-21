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

    func updateWithImage(image: UIImage?) {
        if let imageToDisplay = image {
            imageView.image = imageToDisplay
        }
        else {
            imageView.image = nil
        }
    }

}
