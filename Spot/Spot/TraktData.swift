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
    
    let title: String!
    let year: Int!
    
    let traktId: Int!
    let slug: String!
    let imdbId: String!
    let tmdbId: Int!
    
    let rating: Double!
    let votes: Int!
    let runtime: Int!
    let titleDescription: String!
    let backgroundImagePath: String!
    var backgroundImage: UIImage!
    
    //MARK: Initializers
    
    //Construct a data from a dictionary
    init(traktId: Int!, title: String!, year: Int!, tmdbId: Int!, imdbId: String!, slug: String!, rating: Double!, votes: Int!, runtime: Int!, titleDescription:String!, backgroundImagePath: String!, backgroundImage: UIImage!) {
        self.title = title
        self.year =  year
        //ID's
        self.traktId = traktId
        self.slug = slug
        self.imdbId = imdbId
        self.tmdbId = tmdbId
        //Data
        self.rating = rating
        self.votes = votes
        self.runtime = runtime
        self.titleDescription = titleDescription
        self.backgroundImagePath = backgroundImagePath
        self.backgroundImage = backgroundImage
    }
    
    //MARK: Helper Method
    static func traktDataFromResults(_ results: [[String: AnyObject]]) -> [TraktData] {
        var image: UIImage!
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
            if (poster["thumb"] as? NSString) != nil {
            let url = URL(string: (poster["thumb"] as? NSString)! as String)
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
            trakt.append(TraktData(traktId: idData["trakt"] as? Int, title: movieData["title"] as? String, year: movieData["year"] as? Int, tmdbId: idData["tmdb"] as? Int, imdbId: idData["imdb"] as? String, slug: idData["slug"] as? String, rating: movieData["rating"] as? Double, votes:  movieData["votes"] as? Int, runtime:  movieData["runtime"] as? Int, titleDescription: movieData["overview"] as? String, backgroundImagePath: poster["thumb"] as? String, backgroundImage: image))
        }
        return trakt
    }
    
    static func traktSearchDataFromResults(_ results: [[String: AnyObject]]) -> [TraktData] {
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
            
            trakt.append(TraktData(traktId: idData["trakt"] as? Int, title: movieData["title"] as? String, year: movieData["year"] as? Int, tmdbId: idData["tmdb"] as? Int, imdbId: idData["imdb"] as? String, slug: idData["slug"] as? String, rating: movieData["rating"] as? Double, votes:  movieData["votes"] as? Int, runtime:  movieData["runtime"] as? Int, titleDescription: movieData["overview"] as? String, backgroundImagePath: poster["thumb"] as? String, backgroundImage: nil))
        }
        return trakt
    }
    
    
}

