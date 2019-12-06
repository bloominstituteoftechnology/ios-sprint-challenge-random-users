//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Jon Bash on 2019-12-06.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    weak var user: RandomUser?
    
    var operationQueue = OperationQueue()
    weak var imageFetchOp: ImageFetchOperation?

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSubViews()
    }
    
    private func setUpSubViews() {
        userNameLabel.text = user?.name
        phoneNumberLabel.text = user?.phoneNumber
        emailAddressLabel.text = user?.emailAddress
        didFetchImage()
    }
    
    func didFetchImage() {
        if let imageData = user?.imageInfo.fullImageData {
            userImageView.image = UIImage(data: imageData)
        }
    }
}
