//
//  TraktConvenience.swift
//  Spot
//
//  Created by Akshay Iyer on 7/19/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
import Foundation

extension TraktClient {
    
    func authenticateWithViewController(hostViewController: UIViewController, completionHandlerForAuth: (success: Bool, errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        loginWithToken(nil, hostViewController: hostViewController) { (success, errorString) in
            print("Reached Here")
        }
    }
        
    
    private func loginWithToken(requestToken: String?, hostViewController: UIViewController, completionHandlerForLogin: (success: Bool, errorString: String?) -> Void) {
        
        let authorizationURL = NSURL(string: "https://trakt.tv/oauth/authorize?response_type=code&client_id=de74b222f292d9dbd52b540ed41c5a4490ac571731b058b9b13f3400c99ba2f2&redirect_uri=https://google.com")
        print(authorizationURL)
        let request = NSURLRequest(URL: authorizationURL!)
        print(request)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("TraktAuthenticationViewController") as! TraktAuthenticationViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completionHandlerForView = completionHandlerForLogin
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        performUIUpdatesOnMain {
            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
    func getDiscoverTraktData(discoverMovieMethodType: [String: String]!, completionHandlerForTraktData: (result: Bool?, error: String?)->Void) {
        let methodParameters: [String: String] = [
            TraktClient.JSONParameterKeys.Extended: TraktClient.JSONParameterObjects.All
        ]
        var i=0
        for (key, value) in discoverMovieMethodType {
        taskForGETMethod(value, methodParameters: methodParameters) { (result, error) in
            if let error = error {
                completionHandlerForTraktData(result: false, error: error)
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
                completionHandlerForTraktData(result: true, error: nil)
                }
                }
            }
        }
        
    }


    
}