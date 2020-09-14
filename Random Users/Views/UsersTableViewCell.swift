//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usersNameLabel: UILabel!

    var result: Results? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let result = self.result else { return }

//        userImageView.image = result.picture

    }
}
