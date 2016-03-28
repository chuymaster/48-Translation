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
    
    // Singleton
    static let sharedInstance = APIBaseClient()
    
    // MARK: GET
    func taskForGETMethod(url: String, headers: [String:AnyObject], parameters: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask{
        let domain = "taskForGETMethod"
        let request = NSMutableURLRequest(URL: createURLFromParameters(url, parameters: parameters))
        request.HTTPMethod = Constants.HTTPMethod.GET
        for (key, value) in headers{
            request.addValue(value as! String, forHTTPHeaderField: key)
        }
        print("Request URL: \(request.URL!.absoluteString)")
        
        let task = sharedSession.dataTaskWithRequest(request) { (data, response, error) in
            
            guard (error == nil) else{
                let errorString = Message.Error.ER001.message
                self.sendErrorWithCompletionHandler(domain, code: Message.Error.ER001.code, request: request, errorString: errorString, completionHandler: completionHandler)
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else{
                let errorString = Message.Error.ER002.message + " \((response as? NSHTTPURLResponse)!.statusCode)"
                self.sendErrorWithCompletionHandler(domain, code: Message.Error.ER002.code, request: request, errorString: errorString, completionHandler: completionHandler)
                return
            }
            
            guard let data = data else{
                let errorString = Message.Error.ER003.message
                self.sendErrorWithCompletionHandler(domain, code: Message.Error.ER003.code, request: request, errorString: errorString, completionHandler: completionHandler)
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
                let errorString = Message.Error.ER004.message
                let userInfo = ["request": (request.URL?.absoluteString)!,
                                "HTTP method": request.HTTPMethod!,
                                NSLocalizedDescriptionKey: errorString]
                let formattedError = NSError(domain: domain, code: Message.Error.ER004.code, userInfo: userInfo)
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
            let userInfo = [NSLocalizedDescriptionKey : Message.Error.ER005.message]
            completionHandler(result: nil, error: NSError(domain: domain, code: Message.Error.ER005.code , userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }
}