//
//  SpotWatchlistViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 7/18/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class SpotWatchlistViewController: UICollectionViewController
{
    @IBOutlet var watchlistView: UICollectionView!

    var movieData: [TraktData] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = TraktClient.sharedInstance().getDiscoverWatchlistData(method: TraktClient.PathExtension.Watchlist) { (result, error) in
            if let watchlistData = result {
                self.movieData = watchlistData
                performUIUpdatesOnMain {
                    self.watchlistView.reloadData()
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchlistCollectionViewCell", for: indexPath)
        cell.layer.shouldRasterize = true;
        cell.layer.rasterizationScale = UIScreen.main.scale
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let collectionViewCell = cell as? SpotDiscoverCollectionViewCell else { return }
        let data = movieData[(indexPath as NSIndexPath).row]
        DispatchQueue.main.async {
            collectionViewCell.updateWithImage(data.backgroundImage)
            collectionViewCell.updateVotesLabel(data.votes)
            collectionViewCell.updateRatingLabel(data.rating)
            collectionViewCell.updateRuntimeLabel(data.runtime)
            collectionViewCell.addCircleView(data.rating)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = movieData[(indexPath as NSIndexPath).row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "SpotDetailViewController") as! SpotDetailViewController
        controller.traktData = data
        navigationController!.pushViewController(controller, animated: true)

    }
    
    
}
