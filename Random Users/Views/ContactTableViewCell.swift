//
//  ContactTableViewCell.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 10/04/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    
    // MARK: Properties
    
    var contact: Contact? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Actions
    
    func updateViews() {
        guard let contact = contact else { return }
        guard let largeImageData = try? Data(contentsOf: contact.largePicture) else { fatalError() }
        contactImage.image = UIImage(data: largeImageData)
        contactName.text = contact.name
    }
}
