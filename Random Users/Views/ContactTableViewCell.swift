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
        guard let selectedContact = contact else { return }
        let url = selectedContact.picture[2]
        let data = try! Data(contentsOf: url)
        DispatchQueue.main.async {
            self.contactImageView.image = UIImage(data: data)
            self.contactNameLabel.text = selectedContact.name
        }
    }
}
