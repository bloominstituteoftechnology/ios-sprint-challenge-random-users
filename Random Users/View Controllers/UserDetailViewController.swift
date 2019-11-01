//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Isaac Lyons on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    //MARK: Properties
    
    var user: User! {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    //MARK: Private
    
    private func updateViews() {
        if isViewLoaded {
            nameLabel.text = user.name
            phoneLabel.text = user.phone
            emailLabel.text = user.email
        }
    }

}
