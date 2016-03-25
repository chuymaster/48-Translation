//
//  APIBaseClient.swift
//  48+ Translation
//  Generic methods for communicating with API
//
//  Created by CHATCHAI LOKNIYOM on 3/25/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class APIBaseClient : NSObject{
    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    var sharedSession = NSURLSession.sharedSession()
    
    class func sharedInstance() -> APIBaseClient {
        
        struct Singleton {
            static var sharedInstance = APIBaseClient()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: GET
    func taskForGETMethod(url: String, headers: [String:AnyObject], parameters: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask{
        let domain = "taskForGETMethod"
        let request = NSMutableURLRequest(URL: createURLFromParameters(url, parameters: parameters))
        request.HTTPMethod = Constants.HTTPMethod.GET
        for (key, value) in headers{
            request.addValue(value as! String, forHTTPHeaderField: key)
        }
        //print("Request:\(request)")
        
        let task = sharedSession.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else{
                let errorString = "There was an error with your request: \(error)"
                self.sendErrorWithCompletionHandler(domain, code: -1, request: request, errorString: errorString, completionHandler: completionHandler)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else{
                let errorString = "Your request returned a status code other than 2xx (\((response as? NSHTTPURLResponse)!.statusCode))"
                self.sendErrorWithCompletionHandler(domain, code: -2, request: request, errorString: errorString, completionHandler: completionHandler)
                return
            }
            
            guard let data = data else{
                let errorString = ("No data was returned by the request!")
                self.sendErrorWithCompletionHandler(domain, code: -3, request: request, errorString: errorString, completionHandler: completionHandler)
                return
            }
            
            // Parse the data to JSON
            self.convertDataWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
        
        return task
    }
    
    
    // MASK: Download images
    func taskForImage(url: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        let domain = "taskForImage"
        let fileUrl = NSURL(string: url)!
        let request = NSURLRequest(URL: fileUrl)
        //print("Request:\(request)")
        
        let task = sharedSession.dataTaskWithRequest(request) {data, response, error in
            
            guard (error == nil) else{
                let errorString = "There was an when downloading photos"
                let userInfo = ["request": (request.URL?.absoluteString)!,
                                "HTTP method": request.HTTPMethod!,
                                NSLocalizedDescriptionKey: errorString]
                let formattedError = NSError(domain: domain, code: -10, userInfo: userInfo)
                completionHandler(imageData: nil, error: formattedError)
                return
            }
            completionHandler(imageData: data, error: nil)
        }
        
        task.resume()
        
        return task
    }
    
    
    // MARK: create a URL from parameters
    private func createURLFromParameters(url: String, parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents(string: url)!
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    // MARK: Send errors
    private func sendErrorWithCompletionHandler(domain: String, code: Int, request: NSMutableURLRequest, errorString: String, completionHandler:(result: AnyObject!, error: NSError?) -> Void){
        let userInfo = ["request": (request.URL?.absoluteString)!,
                        "HTTP method": request.HTTPMethod,
                        NSLocalizedDescriptionKey: errorString]
        let formattedError = NSError(domain: domain, code: code, userInfo: userInfo)
        completionHandler(result: nil, error: formattedError)
    }
    
    // MARK: Convert raw data to JSON array
    private func convertDataWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void){
        let domain = "convertDataWithCompletionHandler"
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: domain, code: -99, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }
}