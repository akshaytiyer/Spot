 //
//  TraktData.swift
//  Spot
//
//  Created by Akshay Iyer on 7/19/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

struct TraktData {
    //MARK: Properties
    let traktId: Int!
    let title: String!
    let tmdbId: Int!
    let backgroundImagePath: String!
    let backgroundImage: UIImage!
    //MARK: Initializers
    
    //Construct a data from a dictionary
    init(traktId: Int!, title: String!, tmdbId: Int!, backgroundImagePath: String!, backgroundImage: UIImage!) {
        self.traktId = traktId
        self.title = title
        self.tmdbId = tmdbId
        self.backgroundImagePath = backgroundImagePath
        self.backgroundImage = backgroundImage
    }
    
    //MARK: Helper Method
    static func traktDataFromResults(results: [[String: AnyObject]]) -> [TraktData] {
        var trakt = [TraktData]()
        for result in results {
            guard let movieData = result["movie"] as? [String: AnyObject],
                  //MARK: Image Data
                  let imageData = movieData["images"] as? [String: AnyObject],
                  let poster = imageData["poster"] as? [String: AnyObject],
                  //MARK: ID data
                  let idData = movieData["ids"] as? [String: AnyObject] else {
                return trakt
            }
            let url = NSURL(string: (poster["thumb"] as? String)!)
            let image = NSData.init(contentsOfURL: url!)
            trakt.append(TraktData(traktId: idData["trakt"] as? Int, title: movieData["title"] as? String, tmdbId: idData["tmdb"] as? Int, backgroundImagePath: poster["thumb"] as? String, backgroundImage: UIImage(data: image!)))
        }
        return trakt
    }
}

