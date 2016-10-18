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
    
    func getTokenData(_ code: String!, completionHandlerForTokenData: @escaping (_ result: Bool,_ accessToken: TraktAccessToken?, _ error: String?)->Void) {
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let method = "/oauth/token"
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
    
}
