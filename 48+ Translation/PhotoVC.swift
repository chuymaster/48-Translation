//
//  PhotoVC.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/26/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit
import CoreData

class PhotoVC: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    var image: UIImage!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        photoImageView.image = image
    }
    
    @IBAction func shareImage(sender: AnyObject) {
        Utilities.shareItems(self, items: [photoImageView.image!])
    }
}