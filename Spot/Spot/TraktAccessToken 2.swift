//
//  TraktAccessToken.swift
//  Spot
//
//  Created by Akshay Iyer on 10/16/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit
class TraktAccessToken: NSObject, NSCoding {

    var access_token: String!
    var token_type: String!
    var expires_in: Double!
    var refresh_token: String!
    var scope: String!
    var createdDate: Double!
    
    static var DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("accesstoken")
    
    
    override init() {}
    
    convenience init?(dictionary: [String:AnyObject]) {
        
        self.init()
        
        if let urlString = dictionary["access_token"] as? String,
            let secureURLString = dictionary["token_type"] as? String,
            let posterSizesArray = dictionary["expires_in"] as? Double,
            let profileSizesArray = dictionary["refresh_token"] as? String,
            let scopeData = dictionary["scope"] as? String {
            access_token = urlString
            token_type = secureURLString
            expires_in = posterSizesArray
            refresh_token = profileSizesArray
            scope = scopeData
            createdDate = Date.timeIntervalSinceReferenceDate
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: TraktAccessTokenKey.access_token)
        aCoder.encode(token_type, forKey: TraktAccessTokenKey.token_type)
        aCoder.encode(expires_in, forKey: TraktAccessTokenKey.expires_in)
        aCoder.encode(refresh_token, forKey: TraktAccessTokenKey.refresh_token)
        aCoder.encode(scope, forKey: TraktAccessTokenKey.scope)
        aCoder.encode(createdDate, forKey: TraktAccessTokenKey.createdDate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: TraktAccessTokenKey.access_token) as! String
        token_type = aDecoder.decodeObject(forKey: TraktAccessTokenKey.token_type) as! String
        expires_in = aDecoder.decodeObject(forKey: TraktAccessTokenKey.expires_in) as! Double
        refresh_token = aDecoder.decodeObject(forKey: TraktAccessTokenKey.refresh_token) as! String
        scope = aDecoder.decodeObject(forKey: TraktAccessTokenKey.scope) as! String
        createdDate = aDecoder.decodeObject(forKey: TraktAccessTokenKey.createdDate) as! Double
    }
}

    struct TraktAccessTokenKey {
        static let access_token = "access_token"
        static let token_type = "token_type"
        static let expires_in = "expires_in"
        static let refresh_token = "refresh_token"
        static let scope = "scope"
        static let createdDate = "createdDate"
    }
