//
//  TraktSearchData.swift
//  Spot
//
//  Created by Akshay Iyer on 10/22/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

struct TraktSearchData {
    //MARK: Properties
    let traktId: Int!
    let title: String!
    let tmdbId: Int!
    let year: Int!

    
    //MARK: Initializers
    
    //Construct a data from a dictionary
    init(traktId: Int!, title: String!, tmdbId: Int!, year: Int!) {
        self.traktId = traktId
        self.title = title
        self.tmdbId = tmdbId
        self.year = year
    }
    
    //MARK: Helper Method
    static func traktSearchDataFromResults(_ results: [[String: AnyObject]]) -> [TraktSearchData] {
        var trakt = [TraktSearchData]()
        for result in results {
            guard let movieData = result["movie"] as? [String: AnyObject],
                //MARK: ID data
                let idData = movieData["ids"] as? [String: AnyObject] else {
                    return trakt
            }
            trakt.append(TraktSearchData(traktId: idData["trakt"] as? Int, title: movieData["title"] as? String, tmdbId: idData["tmdb"] as? Int, year: 2010))
        }
        return trakt
    }
    
}
