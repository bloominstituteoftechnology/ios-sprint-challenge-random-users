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
        guard let largeImageData = try? Data(contentsOf: contact.pictures[0]) else { fatalError() }
        contactImage.image = UIImage(data: largeImageData)
        contactNameLabel.text = contact.name
    }
}
