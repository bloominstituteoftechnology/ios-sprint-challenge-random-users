//
//  RandomPersonTableViewCell.swift
//  Random Users
//
//  Created by Gi Pyo Kim on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomPersonTableViewCell: UITableViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!

    var name: Name? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let name = name else { return }
        personNameLabel.text = "\(name.title) \(name.first) \(name.last)"
    }
    

}
