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
    }
    
    //MARK: HTTP Header Fields
    struct HTTPHeaderFields {
        static let TraktAPIKey = "trakt-api-key"
        static let TraktAPIVersion = "trakt-api-version"
        static let ContentType = "Content-Type"
    }
    
    //MARK: JSON Parameter Keys
    struct ParameterKeys {
        static let Extended = "extended"
    }
    
    //MARK: JSON Parameter Objects
    struct ParameterObjects {
        static let Images = "images"
        static let Full = "full"
        static let All = "full,images"
    }
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Code = "code"
        static let ClientID = "client_id"
        static let ClientSecret = "client_secret"
        static let RedirectURI = "redirect_uri"
        static let GrantType = "grant_type"
    }
    
    //MARK: JSON Body Values
    struct JSONBodyValues {
        static let ClientID = "908a52fa653e47e98503c7c2887923fbec904970959d01cca9455326b886d701"
        static let ClientSecret = "e2c9fc75765dd60995c0e494bc9469a25753da7b36291398dd80a11822d9249a"
        static let RedirectURI = "https://google.com"
        static let GrantType = "authorization_code"
    }
    
    //MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let TraktId = "traktId"
        static let Title = "title"
        static let TmdbId = "tmdbId"
        static let BackGroundImagePath = "backGroundImagePath"
    }
    
}
