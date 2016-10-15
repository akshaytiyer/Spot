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
    @discardableResult func taskForGETMethod(_ method: String!, methodParameters: [String: String]!, completionHandlerForGET: @escaping (_ result: Any?, _ error: String?) -> Void) -> URLSessionTask {
        let request = NSMutableURLRequest(url: parseURLFromParameters(methodParameters as [String : AnyObject], withPathExtension: method))
        request.addValue(TraktClient.Constants.ContentType, forHTTPHeaderField: TraktClient.HTTPHeaderFields.ContentType)
        request.addValue(TraktClient.Constants.TraktAPIVersion, forHTTPHeaderField: TraktClient.HTTPHeaderFields.TraktAPIVersion)
        request.addValue(TraktClient.Constants.TraktAPIKey, forHTTPHeaderField: TraktClient.HTTPHeaderFields.TraktAPIKey)
        let task = AppDelegate.sharedInstance().session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            //MARK: Error Handling
            func sendError(_ error: String) {
                completionHandlerForGET(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error!.localizedDescription)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }) 
        task.resume()
        return task
        
    }
    
    //MARK: Helper Methods
    //Convert the Raw JSONData to a Reusable Foundation Object
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: Any?, _ error: String?) -> Void) {
        var parsedResult: Any!
        let stringData = String(data: data, encoding: String.Encoding.utf8)
        let newData = stringData?.data(using: String.Encoding.utf8)
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments)
        } catch {
            completionHandlerForConvertData(nil, "Could not parse the data as JSON: '\(data)'")
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    //Create a URL from Parameters
    func parseURLFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
     var components = URLComponents()
        components.scheme = TraktClient.Constants.ApiScheme
        components.host = TraktClient.Constants.ApiHost
        components.path = TraktClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> TraktClient {
        struct Singleton {
            static var sharedInstance = TraktClient()
        }
        return Singleton.sharedInstance
    }
    
}
