//
//  ContactTableViewCell.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 13/03/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    // MARK: - Properties
    
    var contact: Contact? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Actions
    
    func updateViews() {
        guard let contact = contact else { return }
        let thumbnail = contact.pictures[1]
        let request = URLRequest(url: thumbnail)
        
        contactNameLabel.text = contact.name
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error fetching thumbnail: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No thumbnail image data")
                return
            }
            
            DispatchQueue.main.async {
                self.contactImage.image = UIImage(data: data)
            }
        }.resume()
    }
}
