//
//  PersonTableViewCell.swift
//  Random Users
//
//  Created by Dennis Rudolph on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbNailImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    
    var randomPerson: RandomPerson? {
        didSet {
            personNameLabel.text = "\(randomPerson?.name.title ?? "") \(randomPerson?.name.first ?? "") \(randomPerson?.name.last ?? "")"
            
        }
    }
}


