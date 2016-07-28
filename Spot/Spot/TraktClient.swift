//
//  TraktClient.swift
//  Spot
//
//  Created by Akshay Iyer on 7/19/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import Foundation

class TraktClient: NSObject {
    
    var discoverMovieMethodType: [String: String]! =    ["Trending Movies": "/trending",
                                                      "Most Played Movies": "/played/weekly",
                                                     "Most Watched Movies": "/watched/monthly",
                                                   "Most Collected Movies": "/collected/weekly",
                                                      "Anticipated Movies": "/anticipated",
                                                       "Box Office Movies": "/boxoffice"]
                                                //"/updates/2015-09-22"]
    
    
    //MARK: Initializers
    override init() {
        super.init()
    }
    
    //MARK: GET
    func taskForGETMethod(method: String!, methodParameters: [String: String]!, completionHandlerForGET: (result: AnyObject!, error: String!) -> Void) -> NSURLSessionTask {
        let request = NSMutableURLRequest(URL: parseURLFromParameters(methodParameters, withPathExtension: method))
        request.addValue(TraktClient.Constants.ContentType, forHTTPHeaderField: TraktClient.HTTPHeaderFields.ContentType)
        request.addValue(TraktClient.Constants.TraktAPIVersion, forHTTPHeaderField: TraktClient.HTTPHeaderFields.TraktAPIVersion)
        request.addValue(TraktClient.Constants.TraktAPIKey, forHTTPHeaderField: TraktClient.HTTPHeaderFields.TraktAPIKey)
        let task = AppDelegate.sharedInstance().session.dataTaskWithRequest(request) { (data, response, error) in
            //MARK: Error Handling
            func sendError(error: String) {
                completionHandlerForGET(result: nil, error: error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!.localizedDescription)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        task.resume()
        return task
        
    }
    
    //MARK: Helper Methods
    //Convert the Raw JSONData to a Reusable Foundation Object
    func convertDataWithCompletionHandler(data: NSData, completionHandlerForConvertData: (result: AnyObject!, error: String!) -> Void) {
        var parsedResult: AnyObject!
        let stringData = String(data: data, encoding: NSUTF8StringEncoding)
        let newData = stringData?.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData!, options: .AllowFragments)
        } catch {
            completionHandlerForConvertData(result: nil, error: "Could not parse the data as JSON: '\(data)'")
        }
        completionHandlerForConvertData(result: parsedResult, error: nil)
    }
    
    //Create a URL from Parameters
    func parseURLFromParameters(parameters: [String: AnyObject], withPathExtension: String? = nil) -> NSURL {
     let components = NSURLComponents()
        components.scheme = TraktClient.Constants.ApiScheme
        components.host = TraktClient.Constants.ApiHost
        components.path = TraktClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.URL!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> TraktClient {
        struct Singleton {
            static var sharedInstance = TraktClient()
        }
        return Singleton.sharedInstance
    }
    
}