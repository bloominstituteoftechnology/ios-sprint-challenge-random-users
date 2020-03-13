//
//  ContactTableViewCell.swift
//  Random Users
//
//  Created by Keri Levesque on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

 //MARK: Oulets
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactLabel: UILabel!
    

    //MARK: Properties
    var contact: Contact? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
           guard let contact = contact else { return }
           contactLabel.text = contact.name
       }
}
