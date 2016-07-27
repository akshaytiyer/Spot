//
//  SpotDiscoverViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 7/20/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
class SpotDiscoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityViewController: UIActivityIndicatorView!
    
    var traktData = TraktSharedInstance.sharedInstance().traktData
    var key: [String] = [String]()
    
    override func viewDidLoad() {
        setTableViewDelegateProperties()
        setNavigationBarTextProperties()
        TraktClient.sharedInstance().getDiscoverTraktData(TraktClient.sharedInstance().discoverMovieMethodType) { (result, title, error) in
            if let title = title {
                self.key.append(title)
            }
            if let result = result {
                self.traktData.append(result)
                //self.key.append(key)
                performUIUpdatesOnMain({
                    self.tableView.reloadData()
                })
            }
            else {
                self.dismissApp()
            }
        }

    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return traktData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiscoverTableViewCell",
                                                               forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? SpotDiscoverTableViewCell else { return }
        let keyValue = self.key[indexPath.row]
        tableViewCell.setCollectionViewTitle(keyValue)
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }

    //Logout
    private func dismissApp()
    {
        let alertController = UIAlertController(title: "Error", message: "Unexpected Server Side Error Encountered", preferredStyle: .Alert)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(CancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    //Helper Methods
    private func setTableViewDelegateProperties()
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func setNavigationBarTextProperties() {
        if let font = UIFont(name: "GothamMedium", size: 14) {
            let navBarAttributesDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.init(red: 213.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0),
                NSFontAttributeName: font
            ]
            self.navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
    }
    
}

extension SpotDiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return traktData[collectionView.tag].count
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DiscoverCollectionViewCell",
                                                                         forIndexPath: indexPath)
        cell.layer.shouldRasterize = true;
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let collectionViewCell = cell as? SpotDiscoverCollectionViewCell else { return }
        let data = traktData[collectionView.tag][indexPath.row]
        collectionViewCell.updateWithImage(data.backgroundImage)
        collectionViewCell.updateVotesLabel(data.votes)
        collectionViewCell.updateRatingLabel(data.rating)
        collectionViewCell.updateRuntimeLabel(data.runtime)
        collectionViewCell.addCircleView()
    }
}
