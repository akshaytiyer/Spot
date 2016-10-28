//
//  SpotWatchlistViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 7/18/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
import Firebase

class SpotWatchlistViewController: UICollectionViewController
{
    
    let ref = FIRDatabase.database().reference(withPath: "spot-watchlist")
    
    @IBOutlet var watchlistView: UICollectionView!
    var movieData: [TraktData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchlistView.dataSource = self
        watchlistView.delegate = self
        transferPersistentDataToArray { (result, error) in
            if result==true {
                performUIUpdatesOnMain {
                    self.watchlistView.reloadData()
                }
            } else {
                print("Error fetching the data")
            }
        }
    }
    
    func transferPersistentDataToArray(completionHandlerForTokenData: @escaping (_ result: Bool,_ error: String?)->Void) {
        ref.child("watchlist").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.childrenCount
            print(value)
            self.storePersistentInPersistentArray(elementCount: value, completionHandlerForStoredData: { (result, error) in
                if result {
                    completionHandlerForTokenData(true, nil)
                }
            })
            })
        }
    
    func storePersistentInPersistentArray(elementCount: UInt!, completionHandlerForStoredData: @escaping (_ result: Bool,_ error: String?)->Void) -> Void {
        if elementCount > 0 {
        for term in 0...(elementCount-1) {
            self.ref.child("watchlist").child("\(term)").observeSingleEvent(of: .value, with: { (snapshot) in
                let traktData = snapshot.value as? NSDictionary
                let backgroundImagePath = traktData?["thumb"] as? String
                let backgroundImage = TraktClient.sharedInstance().fetchImage(backgroundImagePath)
                self.movieData.append(TraktData(traktId: traktData?["traktId"] as? Int, title: traktData?["title"] as? String, year: traktData?["year"] as? Int, tmdbId: traktData?["tmdbId"] as? Int, imdbId: traktData?["imdbId"] as? String, slug: traktData?["slug"] as? String, rating: traktData?["rating"] as? Double, votes: traktData?["votes"] as? Int, runtime: traktData?["runtime"] as? Int, titleDescription: traktData?["overview"] as? String, backgroundImagePath: traktData?["thumb"] as? String, backgroundImage: backgroundImage))
            if term==elementCount-1
            {
                completionHandlerForStoredData(true, nil)
            }
            })
        }
        }
    }
    
    @IBAction func refreshToken(_ sender: AnyObject) {
        self.movieData = []
        if Reachability.isConnectedToNetwork() == true {
            _ = TraktClient.sharedInstance().getDiscoverWatchlistData(method: TraktClient.PathExtension.Watchlist) { (result, error) in
                if let watchlistData = result {
                    self.movieData = watchlistData
                    performUIUpdatesOnMain {
                        self.watchlistView.reloadData()
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(OKAction)
            self.present(alert, animated: true)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(movieData.count)
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
