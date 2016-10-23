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
    var movieData: [TraktSearchData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        setTableViewDelegateProperties()
        setSearchBarDelegateProperties()
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
        self.searchBar.showsCancelButton = true
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
        movieData = [TraktSearchData]()
        
        // cancel the last task
        if let task = searchTask {
            task.cancel()
        }
        
        // if the text is empty we are done
        if searchText == "" {
            movieData = [TraktSearchData]()
            tableView?.reloadData()
            return
        }
        
        searchTask = TraktClient.sharedInstance().getMoviesForSearchString(searchString: searchText) { (result, error) in
        self.searchTask = nil
        if let movieSearchData = result {
            self.movieData = movieSearchData
            performUIUpdatesOnMain {
                self.tableView.reloadData()
            }
            }
        }
    }
}

extension SpotSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellReuseId = "TraktMovieSearchCell"
        let movie = movieData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId) as UITableViewCell!
        /*
        if let releaseYear = movie.year {
            cell?.textLabel!.text = "\(movie.title) (\(releaseYear))"
        } else {
            cell?.textLabel!.text = "\(movie.title)"
        } */
        cell?.textLabel?.text = movie.title
        print(cell?.textLabel?.text)
        //print(movie.title)
        //print(movie.year)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let movie = movies[indexPath.row]
        let controller = storyboard!.instantiateViewControllerWithIdentifier("MovieDetailViewController") as! MovieDetailViewController
        controller.movie = movie
        navigationController!.pushViewController(controller, animated: true)*/
    }
}

