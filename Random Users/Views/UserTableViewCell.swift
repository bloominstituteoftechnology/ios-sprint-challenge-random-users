//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Cody Morley on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    //MARK: - Properties -
    @IBOutlet weak var userThumbnail: UIImageView!
    @IBOutlet weak var userName: UILabel!
    var user: User?
}
