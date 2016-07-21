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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TraktClient.sharedInstance().getTraktData { (result, error) in
            if let result = result {
                self.traktData.append(result)
                print(self.traktData.count)
                print(self.traktData[0])
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

    //Logout
    private func dismissApp()
    {
        let alertController = UIAlertController(title: "Error", message: "Unexpected Server Side Error Encountered", preferredStyle: .Alert)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(CancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
