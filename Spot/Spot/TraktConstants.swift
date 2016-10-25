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
        static let TraktAPIKey = "908a52fa653e47e98503c7c2887923fbec904970959d01cca9455326b886d701"
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
        static let Authorization = "Authorization"
    }
    
    //MARK: JSON Parameter Keys
    struct ParameterKeys {
        static let Extended = "extended"
        static let Query = "query"
        static let Fields = "fields"
    }
    
    struct PathExtension {
        static let OauthToken = "/oauth/token"
        static let SearchMovies = "/search/movie"
        static let Watchlist = "/sync/watchlist/movies"
    }
    
    //MARK: JSON Parameter Objects
    struct ParameterObjects {
        static let Images = "images"
        static let Full = "full"
        static let All = "full,images"
        static let Title = "title"
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
