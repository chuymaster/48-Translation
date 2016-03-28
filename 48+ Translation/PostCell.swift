//
//  PostCell.swift
//  48+ Translation
//
//  Created by CHATCHAI LOKNIYOM on 3/25/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}