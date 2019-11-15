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
        
        
        let firstName = (user?.name.title)! + "." + " " + (user?.name.first)!
        let lastName = user!.name.last
        
        nameLabel.text = firstName + " " + lastName
        phoneNumberLabel.text = user?.phone
        emailAddressLabel.text = user?.email
        guard let url = user?.picture.large else { return }
        if let data = try? Data(contentsOf: url) {
          imageView.image = UIImage(data: data)
            imageView.layer.cornerRadius = 12
        }
    }
}
