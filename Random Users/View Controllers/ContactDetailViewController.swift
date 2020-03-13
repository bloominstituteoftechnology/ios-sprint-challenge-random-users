//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by scott harris on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var imageData: Data?
    
    var contact: Contact?
    
    override func viewDidLoad() {
        updateViews()
    }
    
    func updateViews() {
        if isViewLoaded {
            if let contact = contact {
                if let imageData = imageData {
                    imageView.image = UIImage(data: imageData)
                }
                nameLabel.text = "\(contact.title) \(contact.firstName) \(contact.lastName)"
                phoneLabel.text = contact.phone
                emailLabel.text = contact.email
            }
        }
    }
    
}
