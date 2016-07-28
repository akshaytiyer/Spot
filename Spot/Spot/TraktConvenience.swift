//
//  TraktConvenience.swift
//  Spot
//
//  Created by Akshay Iyer on 7/19/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

extension TraktClient {
    
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