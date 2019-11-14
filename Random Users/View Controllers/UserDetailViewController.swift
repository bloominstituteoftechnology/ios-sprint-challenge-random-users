//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Bobby Keffury on 11/9/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    private func updateViews() {
        guard isViewLoaded else { return }
        
        
        let fullName = user?.name.title + "." + " " + user?.name.first + " " + user?.name.last
        
        nameLabel.text = fullName
        phoneNumberLabel.text = user?.phone
        emailAddressLabel.text = user?.email
        
    }

}
