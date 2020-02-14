//
//  ContactTableViewCell.swift
//  Random Users
//
//  Created by Michael on 2/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    var contact: Contact? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    
    func updateViews() {
        guard let contact = contact else { return }
        contactNameLabel.text = contact.name
    }
}
