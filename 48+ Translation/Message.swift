//
//  Message.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/26/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import Foundation

struct Message{
    struct General{
        static let TranslateThis = "Translate this!"
        static let Translate = "Translate"
    }
    struct Error{
        static let ER001 = (code:-1, message:"There was an error with your request.")
        static let ER002 = (code:-2, message:"Your request returned a status code other than 2xx.")
        static let ER003 = (code:-3, message:"No data was returned by the request.")
        static let ER004 = (code:-4, message:"There was an when downloading photos.")
        static let ER005 = (code:-5, message:"Could not parse the data as JSON.")
        static let ER006 = (code:-6, message:"There is an error in response content.")
    }
}