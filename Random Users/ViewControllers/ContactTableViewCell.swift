//
//  ContactTableViewCell.swift
//  Random Users
//
//  Created by BrysonSaclausa on 9/12/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
