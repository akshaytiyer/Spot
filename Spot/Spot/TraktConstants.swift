//
//  TraktConstants.swift
//  Spot
//
//  Created by Akshay Iyer on 7/19/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

extension TraktClient {
    
    //MARK: Important Constants
    struct Constants {
        //MARK: APIKey
        static let TraktAPIKey = "de74b222f292d9dbd52b540ed41c5a4490ac571731b058b9b13f3400c99ba2f2"
        static let TraktAPIVersion = "2"
        static let ContentType = "application/json"
        
        //MARK: URL
        static let ApiScheme = "https"
        static let ApiHost = "api.trakt.tv"
        static let ApiPath = "/movies"
    }
    
    struct HTTPHeaderFields {
        static let TraktAPIKey = "trakt-api-key"
        static let TraktAPIVersion = "trakt-api-version"
        static let ContentType = "Content-Type"
    }
    
    struct ImageSizes {
        static let DiscoverPageSize = ""
    }
    
    //MARK: JSON Parameter Keys
    struct JSONParameterKeys {
        static let Extended = "extended"
    }
    
    //MARK: JSON Parameter Objects
    struct JSONParameterObjects {
        static let Images = "images"
        static let Full = "full"
        static let All = "full,images"
    }
    
    //MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let TraktId = "traktId"
        static let Title = "title"
        static let TmdbId = "tmdbId"
        static let BackGroundImagePath = "backGroundImagePath"
    }
    
}