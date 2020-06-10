//
//  PeopleTableViewCell.swift
//  Random Users
//
//  Created by Lambda_School_loaner_226 on 6/9/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
