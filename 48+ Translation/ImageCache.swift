//
//  ImageCache.swift
//  48+ Translation
//
//  Created by Jason on 1/31/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//
import UIKit

/// Image cache helper
class ImageCache {
    
    private var inMemoryCache = NSCache()
    
    init(){
        inMemoryCache.totalCostLimit = 30*1024*1024 // 30MB
    }
    
    // MARK: - Retreiving images
    
    func imageWithIdentifier(identifier: String?, fromDisk: Bool) -> UIImage? {
        
        // If the identifier is nil, or empty, return nil
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        // First try the memory cache
        if let image = inMemoryCache.objectForKey(path) as? UIImage {
            return image
        }
        
        // Next Try the hard drive if fromDisk is true
        if fromDisk{
            if let data = NSData(contentsOfFile: path) {
                NSLog("Loaded " + path)
                return UIImage(data: data)
            }
        }
        
        return nil
    }
    
    // MARK: - Saving images
    
    func storeImage(image: UIImage?, withIdentifier identifier: String, toDisk: Bool) {
        let path = pathForIdentifier(identifier)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch _ {}
            
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
        
        // And in documents directory if toDisk is true
        if toDisk{
            let data = UIImageJPEGRepresentation(image!, 0.8)!
            data.writeToFile(path, atomically: true)
            NSLog("Saved " + path)
        }
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
}