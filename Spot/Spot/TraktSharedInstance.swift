//
//  TraktSharedInstance.swift
//  Spot
//
//  Created by Akshay Iyer on 7/20/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

class TraktSharedInstance: NSObject
{
    var traktData: [[TraktData]] = [[TraktData]]()
    
    // MARK: Shared Instance
    class func sharedInstance() -> TraktSharedInstance {
        struct Singleton {
            static var sharedInstance = TraktSharedInstance()
        }
        return Singleton.sharedInstance
    }
}
