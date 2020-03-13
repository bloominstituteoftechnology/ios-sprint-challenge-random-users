//
//  ContactDetailViewController.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 13/03/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Properties
    
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    
    func updateViews() {
        guard let contact = contact else { return }
        
        usernameLabel.text = contact.name
        phoneNumberLabel.text = contact.phone
        emailLabel.text = contact.email
        
        let largeImage = contact.pictures[0]
        let request = URLRequest(url: largeImage)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching large image: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No large image data")
                return
            }
            
            DispatchQueue.main.async {
                self.userImage.image = UIImage(data: data)
            }
        }.resume()
    }
}
