//
//  SpotDiscoverViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 7/20/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
class SpotDiscoverViewController: UITableViewController {
    
    var traktData = TraktSharedInstance.sharedInstance().traktData
    
    override func viewDidLoad() {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        if let font = UIFont(name: "GothamMedium", size: 14) {
            let navBarAttributesDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.init(red: 213.0/255.0, green: 227.0/255.0, blue: 227.0/255.0, alpha: 1.0),
                NSFontAttributeName: font
            ]
            self.navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TraktClient.sharedInstance().getTraktData(TraktClient.sharedInstance().discoverMovieMethodType) { (result, error) in
            if let result = result {
                self.traktData.append(result)
                performUIUpdatesOnMain({
                    self.tableView.reloadData()
                })
            }
            else {
                self.dismissApp()
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return traktData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DiscoverTableViewCell",
                                                               forIndexPath: indexPath)
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let tableViewCell = cell as? SpotDiscoverTableViewCell else { return }
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
    }
}
