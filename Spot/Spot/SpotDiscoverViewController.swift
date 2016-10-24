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
    
    var traktData: [[TraktData]] = [[TraktData]]()
    var traktKey: [String] = [String]()
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        setTableViewDelegateProperties()
        setNavigationBarTextProperties()
        activityViewController.hidesWhenStopped = true
        activityViewController.startAnimating()
        TraktClient.sharedInstance().getDiscoverTraktData(TraktClient.sharedInstance().discoverMovieMethodType) { (result, error) in
            if result == true {
                self.traktData = TraktSharedInstance.sharedInstance().traktData
                self.traktKey = TraktSharedInstance.sharedInstance().traktKey
                performUIUpdatesOnMain({
                    self.tableView.reloadData()
                    self.activityViewController.stopAnimating()
                })
            }
            else {
                self.dismissApp()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.traktData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCell",
                                                               for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? SpotDiscoverTableViewCell else { return }
        let keyValue = self.traktKey[(indexPath as NSIndexPath).row]
        tableViewCell.selectionStyle = UITableViewCellSelectionStyle.none
        tableViewCell.setCollectionViewTitle(keyValue)
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: (indexPath as NSIndexPath).row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? SpotDiscoverTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }

    //Logout
    fileprivate func dismissApp()
    {
        let alertController = UIAlertController(title: "Error", message: "Unexpected Server Side Error Encountered", preferredStyle: .alert)
        let CancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(CancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    //Helper Methods
    fileprivate func setTableViewDelegateProperties()
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    fileprivate func setNavigationBarTextProperties() {
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
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return traktData[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscoverCollectionViewCell", for: indexPath)
            cell.layer.shouldRasterize = true;
            cell.layer.rasterizationScale = UIScreen.main.scale
            cell.backgroundColor = UIColor.black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let collectionViewCell = cell as? SpotDiscoverCollectionViewCell else { return }
        let data = traktData[collectionView.tag][(indexPath as NSIndexPath).row]
        DispatchQueue.main.async {
            collectionViewCell.updateWithImage(data.backgroundImage)
            collectionViewCell.updateVotesLabel(data.votes)
            collectionViewCell.updateRatingLabel(data.rating)
            collectionViewCell.updateRuntimeLabel(data.runtime)
            collectionViewCell.addCircleView(data.rating)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = traktData[collectionView.tag][(indexPath as NSIndexPath).row]
        let controller = storyboard!.instantiateViewController(withIdentifier: "SpotDetailViewController") as! SpotDetailViewController
        controller.traktData = data
        navigationController!.pushViewController(controller, animated: true)
    }
}
