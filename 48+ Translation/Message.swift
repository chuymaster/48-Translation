//
//  Message.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/26/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import Foundation

/// Application messages
struct Message{
    struct General{
        static let MS001 = "Translate this!"
        static let MS002 = "Request URL: %@"
    }
    struct Error{
        static let ER001 = (code:-1, message:"There was an error with your request.")
        static let ER002 = (code:-2, message:"Your request returned a status code other than 2xx.")
        static let ER003 = (code:-3, message:"No data was returned by the request.")
        static let ER004 = (code:-4, message:"There was an when downloading photos.")
        static let ER005 = (code:-5, message:"Could not parse the data as JSON.")
        static let ER006 = (code:-6, message:"There is an error in response content.")
        static let ER007 = (code:-7, message:"Failed to fetch members.")
        static let ER008 = (code:-8, message:"Failed to fetch posts.")
        static let ER009 = (code:-9, message:"Could not download the photo")
        
    }
    struct Warning{
        static let WA001 = (code:1, message:"No new post.")
    }
}