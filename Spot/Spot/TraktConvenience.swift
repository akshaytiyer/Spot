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
    
    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: (_ success: Bool, _ errorString: String?) -> Void) {
        
        // chain completion handlers for each request so that they run one after the other
        loginWithToken(nil, hostViewController: hostViewController) { (success, errorString) in
            print("Reached Here")
        }
    }
        
    
    fileprivate func loginWithToken(_ requestToken: String?, hostViewController: UIViewController, completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let authorizationURL = URL(string: "https://trakt.tv/oauth/authorize?response_type=code&client_id=de74b222f292d9dbd52b540ed41c5a4490ac571731b058b9b13f3400c99ba2f2&redirect_uri=https://google.com")
        print(authorizationURL)
        let request = URLRequest(url: authorizationURL!)
        print(request)
        let webAuthViewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "TraktAuthenticationViewController") as! TraktAuthenticationViewController
        webAuthViewController.urlRequest = request
        webAuthViewController.requestToken = requestToken
        webAuthViewController.completionHandlerForView = completionHandlerForLogin
        
        let webAuthNavigationController = UINavigationController()
        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
        
        performUIUpdatesOnMain {
            hostViewController.present(webAuthNavigationController, animated: true, completion: nil)
        }
    }
    
    func getDiscoverTraktData(_ discoverMovieMethodType: [String: String]!, completionHandlerForTraktData: @escaping (_ result: Bool?, _ error: String?)->Void) {
        let methodParameters: [String: String] = [
            TraktClient.JSONParameterKeys.Extended: TraktClient.JSONParameterObjects.All
        ]
        var i=0
        for (key, value) in discoverMovieMethodType {
        taskForGETMethod(value, methodParameters: methodParameters) { (result, error) in
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


    
}
