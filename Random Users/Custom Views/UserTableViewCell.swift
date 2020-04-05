//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 3/20/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
//    var userController: UserController?
    var user: User? {
        didSet {
            updateViews()
        }
    }
//    var userQueue = OperationQueue()

    func updateViews() {
        guard let user = user else { return }
        
 //       let imageFetch = ImageFetchOperation(userController: userController, url: user.thumbnail)
 //       let completionOperation = BlockOperation {
 //           guard let image = imageFetch.image else { return }
 //           self.thumbnailImageView.image = image
            self.userNameLabel.text = user.name
 //       }
        
 //       completionOperation.addDependency(imageFetch)
 //       userQueue.addOperation(imageFetch)
 //       OperationQueue.main.addOperation(completionOperation)
    }
}
