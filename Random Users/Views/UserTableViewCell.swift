//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Chris Dobek on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    func updateViews() {
        guard let user = user else { return }
        userName.text = user.name
    }
    
}
