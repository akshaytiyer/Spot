//
//  TraktConvenience.swift
//  Spot
//
//  Created by Akshay Iyer on 7/19/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

extension TraktClient {
    
    func getDiscoverTraktData(discoverMovieMethodType: [String: String]!, completionHandlerForTraktData: (result: [TraktData]?, title: String!, error: String?)->Void) {
        let methodParameters: [String: String] = [
            TraktClient.JSONParameterKeys.Extended: TraktClient.JSONParameterObjects.All
        ]
        
        
        for (key, value) in discoverMovieMethodType {
        taskForGETMethod(value, methodParameters: methodParameters) { (result, error) in
            if let error = error {
                completionHandlerForTraktData(result: nil, title: nil, error: error)
            } else {
                guard let jsonData = result as? [[String:AnyObject]] else {
                        print("Unable to Parse JSON Data")
                        return
                }
                let traktData = TraktData.traktDataFromResults(jsonData)
                self.traktData.append(traktData)
                print(key)
                completionHandlerForTraktData(result: traktData, title: key, error: nil)
                }
            }
        }
    }
    
}