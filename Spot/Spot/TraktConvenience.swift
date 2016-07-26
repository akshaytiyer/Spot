//
//  TraktConvenience.swift
//  Spot
//
//  Created by Akshay Iyer on 7/19/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

extension TraktClient {
    
    func getTraktData(discoverMovieMethodType: [String]!, completionHandlerForTraktData: (result: [TraktData]?, error: String?)->Void) {
    for movie in discoverMovieMethodType {
        taskForGETMethod(movie) { (result, error) in
            if let error = error {
                completionHandlerForTraktData(result: nil, error: error)
            } else {
                guard let jsonData = result as? [[String:AnyObject]] else {
                        print("Unable to Parse JSON Data")
                        return
                }
                let traktData = TraktData.traktDataFromResults(jsonData)
                self.traktData.append(traktData)
                completionHandlerForTraktData(result: traktData, error: nil)
                }
            }
        }
    }
    
}