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
    var isWatchlist = false
    
    @IBOutlet var titleDescription: UITextView!
    @IBOutlet var votesLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var titleLabel: UITextView!

    @IBOutlet var watchlistState: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() == true {
        _ = TraktClient.sharedInstance().getDiscoverWatchlistData(method: TraktClient.PathExtension.Watchlist) { (result, error) in
            if let watchlistData = result {
                for movie in watchlistData {
                    if movie.traktId == self.traktData!.traktId {
                        self.isWatchlist = true
                    }
                }
                performUIUpdatesOnMain {
                    if self.isWatchlist {
                        self.watchlistState.setTitle("Remove from Watchlist", for: .normal)
                    } else {
                        self.watchlistState.setTitle("Add to Watchlist", for: .normal)
                    }
                }
            } else {
                print(error)
            }
        }
        } else  {
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(OKAction)
            self.present(alert, animated: true)
        }
        self.updateView()
        self.updateVotesLabel(self.traktData.votes)
        self.updateRuntimeLabel(self.traktData.runtime)
        self.updateWithImage(self.backgroundImage.image)
    }
    
    func updateView()
    {
        self.imageView.image = traktData.backgroundImage
        self.backgroundImage.image = traktData.backgroundImage
        self.titleLabel.text = traktData.title
        self.titleDescription.text = traktData.titleDescription
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
    
    @IBAction func watchlistAction(_ sender: AnyObject) {
        
        let shouldWatchlist = !isWatchlist
        if Reachability.isConnectedToNetwork() == true {
        TraktClient.sharedInstance().toggleWatchlist(self.traktData, shouldWatchlist) { (result, error) in
            if let error = error {
                print(error)
            } else {
                if result == true {
                self.isWatchlist = shouldWatchlist
                performUIUpdatesOnMain {
                    self.watchlistState.setTitle((shouldWatchlist) ? "Remove from Watchlist" : "Add to Watchlist", for: .normal)
                        }
                    }
                }
            }
        }   else  {
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(OKAction)
            self.present(alert, animated: true)

        }
    }

}
