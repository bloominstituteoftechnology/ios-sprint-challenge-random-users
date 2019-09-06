//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Marlon Raskin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

	var user: User? {
		didSet {
			updateViews()
		}
	}

	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	override func awakeFromNib() {
        super.awakeFromNib()

    }

	func updateViews() {
		guard let user = user else { return }
		nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
	}

}
