//
//  TableViewCell.swift
//  Random Users
//
//  Created by Shawn James on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    var user: Result? {
        didSet { updateViews() }
    }
    
    private func updateViews() {
        guard let user = user else { return }
        nameLabel.text = "\(user.name.title.rawValue) \(user.name.first) \(user.name.last)"
    }
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
}
