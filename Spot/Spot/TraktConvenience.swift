//
//  TraktConvenience.swift
//  Spot
//
//  Created by Akshay Iyer on 7/19/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
import Foundation
import Firebase

extension TraktClient {
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        self.loginWithToken(hostViewController: hostViewController) { (success, code, errorString) in
            if success {
                self.getTokenData(code) { (success, accessToken, errorString) in
                    if success {
                        self.saveTokenData(newAccessToken: accessToken!) { (success, errorString) in
                            if success {
                                completionHandlerForAuth(true, nil)
                            }
                            else {
                                completionHandlerForAuth(false, errorString)
                            }
                        }
                    }
                    else  {
                        completionHandlerForAuth(false, errorString)
                    }
                }
            }
        }
    }
        
    
    fileprivate func loginWithToken(hostViewController: UIViewController, completionHandlerForLogin: @escaping (_ success: Bool, _ code: String?, _ errorString: String?) -> Void) {
        
        let authorizationURL = URL(string: "https://trakt.tv/oauth/authorize?response_type=code&client_id=908a52fa653e47e98503c7c2887923fbec904970959d01cca9455326b886d701&redirect_uri=https://google.com")
        let request = URLRequest(url: authorizationURL!)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "TraktAuthenticationViewController") as! TraktAuthenticationViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.completionHandlerForView = completionHandlerForLogin
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        performUIUpdatesOnMain {
            hostViewController.present(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
    func getDiscoverTraktData(_ discoverMovieMethodType: [String: String]!, completionHandlerForTraktData: @escaping (_ result: Bool?, _ error: String?)->Void) {
        let methodParameters: [String: String] = [
            TraktClient.ParameterKeys.Extended: TraktClient.ParameterObjects.All
        ]
        var i=0
        for (key, value) in discoverMovieMethodType {
        taskForGETMethod(value, methodParameters: methodParameters as [String : AnyObject]!) { (result, error) in
            if let error = error {
                completionHandlerForTraktData(false, error)
            } else {
                guard let jsonData = result as? [[String:AnyObject]] else {
                        print("Unable to Parse JSON Data")
                        return
                }
                let traktData = TraktData.traktDataFromResults(jsonData)
                TraktSharedInstance.sharedInstance().traktData.append(traktData)
                TraktSharedInstance.sharedInstance().traktKey.append(key)
                if i < discoverMovieMethodType.count-1 {
                   i = i + 1
                }
                else {
                completionHandlerForTraktData(true, nil)
                }
                }
            }
        }
    }
    
    func getDiscoverWatchlistData(method: String!, completionHandlerForTraktData: @escaping (_ result: [TraktData]?, _ error: String?)->Void) -> URLSessionDataTask {
        let methodParameters: [String: String] = [
            TraktClient.ParameterKeys.Extended: TraktClient.ParameterObjects.All
        ]
        let watchlist = self.ref.child("watchlist")
        watchlist.setValue(nil)
        let task = taskForGETMethod(method, methodParameters: methodParameters as [String : AnyObject]!) { (result, error) in
                if let error = error {
                    completionHandlerForTraktData(nil, error)
                } else {
                    guard let jsonData = result as? [[String:AnyObject]] else {
                        print("Unable to Parse JSON Data")
                        return
                    }
                    var count: Int = 0
                    let watchlistData = TraktData.traktDataFromResults(jsonData)
                    for individualData in watchlistData {
                        let data: Dictionary<NSString, Any> = [
                            "title": individualData.title as NSString,
                            "year": individualData.year as NSInteger,
                            "tmdbId": individualData.tmdbId as NSInteger,
                            "slug": individualData.slug as NSString,
                            "overview": individualData.titleDescription as NSString,
                            "thumb": individualData.backgroundImagePath as NSString,
                            "runtime": individualData.runtime as NSInteger,
                            "votes": individualData.votes as NSInteger,
                            "rating": individualData.rating as Double,
                            "imdbId": individualData.imdbId as NSString,
                            "traktId": individualData.traktId as NSInteger
                        ]
                       let watchlistItemRef = self.ref.child("watchlist").child("\(count)")
                        watchlistItemRef.setValue(data)
                        if count < watchlistData.count {
                            count = count + 1
                        }
                        print(count)
                    }
                    completionHandlerForTraktData(watchlistData, nil)
                }
            }
    return task
    }
    
    func getTokenData(_ code: String!, completionHandlerForTokenData: @escaping (_ result: Bool,_ accessToken: TraktAccessToken?, _ error: String?)->Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method = TraktClient.PathExtension.OauthToken
        let jsonBody = "{\n  \"\(TraktClient.JSONBodyKeys.Code)\": \"\(code!)\",\n  \"\(TraktClient.JSONBodyKeys.ClientID)\": \"\(TraktClient.JSONBodyValues.ClientID)\",\n  \"\(TraktClient.JSONBodyKeys.ClientSecret)\": \"\(TraktClient.JSONBodyValues.ClientSecret)\",\n  \"\(TraktClient.JSONBodyKeys.RedirectURI)\": \"\(TraktClient.JSONBodyValues.RedirectURI)\",\n  \"\(TraktClient.JSONBodyKeys.GrantType)\": \"\(TraktClient.JSONBodyValues.GrantType)\"\n}"
        taskForPOSTMethod(method, methodParameters: nil, jsonBody) { (result, error) in
            if let error = error {
            completionHandlerForTokenData(false,nil,error)
            } else {
                guard let jsonData = result as? [String:AnyObject] else {
                    print("Unable to Parse JSON Data")
                    return
            }
            let newAccessToken = TraktAccessToken(dictionary: jsonData)
            completionHandlerForTokenData(true, newAccessToken!, nil)
            }
        }
    }
    
    
    func toggleWatchlist(_ movie: TraktData!,_ isWatchlistItem: Bool, completionHandlerForWatchlistData: @escaping (_ result: Bool,_ error: String?)->Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var method: String!
        
        //Toggle between add and remove
        if isWatchlistItem {
            method = TraktClient.PathExtension.WatchlistAdd
        } else {
            method = TraktClient.PathExtension.WatchlistRemove
        }
        let jsonBody = "{\n  \"movies\": [\n    {\n      \"title\": \"\(movie.title!)\",\n      \"year\": \(movie.year!),\n      \"ids\": {\n        \"trakt\": \(movie.traktId!),\n        \"slug\": \"\(movie.slug!)\",\n        \"imdb\": \"\(movie.imdbId!)\",\n        \"tmdb\": \(movie.tmdbId!)\n      }\n }\n ]\n}"

        taskForPOSTMethod(method, methodParameters: nil, jsonBody) { (result, error) in
            if let error = error {
                completionHandlerForWatchlistData(false,error)
            } else {
                completionHandlerForWatchlistData(true, nil)
            }
        }
    }
    
    func revokeTokenData(completionHandlerForRevokeTokenData: @escaping (_ result: Bool,_ error: String?)->Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        if let accesstokendata = loadTokenData() {
        let method = TraktClient.PathExtension.OauthRevoke
            
        let jsonBody = "{\n \"token\": \"\(accesstokendata.access_token!)\" \n}"
        
        taskForPOSTMethod(method, methodParameters: nil, jsonBody) { (result, error) in
            if let error = error {
                completionHandlerForRevokeTokenData(false,error)
            } else {
                self.deleteTokenData(completionHandlerForDaleteTokenData: { (result, error) in
                    if result {
                        completionHandlerForRevokeTokenData(true, nil)
                    } else {
                        completionHandlerForRevokeTokenData(false,error)
                    }
                    
                })
                
            }
        }
        }
    }
    
    func deleteTokenData(completionHandlerForDaleteTokenData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let exists = FileManager.default.fileExists(atPath: TraktAccessToken.ArchiveURL.path)
        if exists {
            do {
                try FileManager.default.removeItem(atPath: TraktAccessToken.ArchiveURL.path)
                completionHandlerForDaleteTokenData(true, nil)
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
                completionHandlerForDaleteTokenData(false, "Unable to delete the file")
            }
        }
        
    }
    
    
    
    func saveTokenData(newAccessToken: TraktAccessToken, completionHandlerForTokenData: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let tokenData = NSKeyedArchiver.archiveRootObject(newAccessToken, toFile: TraktAccessToken.ArchiveURL.path)
        if !tokenData {
            completionHandlerForTokenData(false, "Data Did Not Get Saved Correctly")
        }
        else {
            completionHandlerForTokenData(true, nil)
        }
    }
    
    func checkTokenValidity(completionHandlerForValidity: @escaping (_ result: Bool, _ error: String?)->Void) {
        if let accesstokendata = loadTokenData() {
            if Date.timeIntervalSinceReferenceDate < (accesstokendata.expires_in + accesstokendata.createdDate) {
                completionHandlerForValidity(true, "The Session Expired")
            }
            else {
                completionHandlerForValidity(false, nil)
            }
        }
    }
    
    func loadTokenData() -> TraktAccessToken? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: TraktAccessToken.ArchiveURL.path) as? TraktAccessToken
    }
    
    func fetchImage(_ imagePath: String?) -> UIImage! {
        var image: UIImage!
        if imagePath != nil {
            let url = URL(string: (imagePath)!)
            let imageFromData = NSData(contentsOf: url!)
            if imageFromData != nil {
                image = UIImage(data: imageFromData as! Data)
            }
            else {
                image = UIImage(named: "Placeholder Image")
            }
        }
        else {
            image = UIImage(named: "Placeholder Image")
        }
        return image
    }
    
    func getMoviesForSearchString(searchString: String, completionHandlerForMovies: @escaping (_ result: [TraktData]?, _ error: String?) -> Void) -> URLSessionDataTask? {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [TraktClient.ParameterKeys.Query: searchString,
                          TraktClient.ParameterKeys.Extended: TraktClient.ParameterObjects.All,
                          TraktClient.ParameterKeys.Fields: TraktClient.ParameterObjects.Title
        ]
        let method = TraktClient.PathExtension.SearchMovies
        /* 2. Make the request */
        let task = taskForGETMethod(method, methodParameters: parameters as [String : AnyObject]!) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForMovies(nil, error)
            } else {
                guard let jsonData = results as? [[String: AnyObject]] else {
                    print("Unable to Parse JSON Data")
                    return
                }
                let traktSearchData = TraktData.traktSearchDataFromResults(jsonData)
                completionHandlerForMovies(traktSearchData, nil)
                
                }
            }
            return task
        }
    }

