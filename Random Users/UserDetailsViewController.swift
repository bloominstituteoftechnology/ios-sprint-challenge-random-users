//
//  UserDetailsViewController.swift
//  Random Users
//
//  Created by Sean Hendrix on 11/30/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let user = user else { return }
        
        userPhotoImageView.alpha = 0
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.height / 2
        userPhotoImageView.layer.masksToBounds = true
        
        nameLabel.text = user.name.formatted.3
        phoneNumberLabel.text = user.phone
        cellLabel.text = user.cell
        birthdayLabel.text = user.dob.formatted
        genderLabel.text = user.gender
        emailAddressLabel.text = user.email
        
        let fetchOperation = FetchImageOperation(url: user.picture.large)
        
        let updateImageOperation = BlockOperation {
            if let imageData = fetchOperation.imageData {
                UIView.animate(withDuration: 0.1, animations: {
                    let userImage = UIImage(data: imageData)
                    self.userPhotoImageView.image = userImage
                    self.userPhotoImageView.alpha = 1
                })
            }
        }
        
        updateImageOperation.addDependency(fetchOperation)
        
        fetchImageQueue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(updateImageOperation)
    }
    
    var user: User?
    private var fetchImageQueue = OperationQueue()
    
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
}
