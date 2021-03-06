//
//  SpotSearchViewController.swift
//  Spot
//
//  Created by Akshay Iyer on 7/18/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class SpotSearchViewController: UIViewController
{
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var searchTask: URLSessionDataTask?
    var movieData: [TraktData] = []
    
    override func viewDidLoad() {
       super.viewDidLoad()
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //view.addGestureRecognizer(tap)
        setTableViewDelegateProperties()
        setSearchBarDelegateProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
    
    fileprivate func setTableViewDelegateProperties()
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    fileprivate func setSearchBarDelegateProperties()
    {
        self.searchBar.delegate = self
        //self.searchBar.showsCancelButton = true
    }
    
    
}

// MARK: - MoviePickerViewController: UIGestureRecognizerDelegate

extension SpotSearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return searchBar.isFirstResponder
    }
}

extension SpotSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movieData = [TraktData]()
        
        // cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // if the text is empty we are done
        if searchText == "" {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            movieData = [TraktData]()
            tableView?.reloadData()
            return
        }

    if Reachability.isConnectedToNetwork() == true {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        searchTask = TraktClient.sharedInstance().getMoviesForSearchString(searchString: searchText) { (result, error) in
        self.searchTask = nil
        if let movieSearchData = result {
            self.movieData = movieSearchData
            performUIUpdatesOnMain {
                self.tableView.reloadData()
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.searchBar.text = ""
            self.view.endEditing(true)
         
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true)
        }
    }
    


    
}

extension SpotSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellReuseId = "TraktMovieSearchCell"
        let movie = movieData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId) as UITableViewCell!
        cell?.textLabel?.text = movie.title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var movies = movieData[indexPath.row]
        movies.backgroundImage = TraktClient.sharedInstance().fetchImage(movies.backgroundImagePath)
        let controller = storyboard!.instantiateViewController(withIdentifier: "SpotDetailViewController") as! SpotDetailViewController
        controller.traktData = movies
        navigationController!.pushViewController(controller, animated: true)
    }
}

