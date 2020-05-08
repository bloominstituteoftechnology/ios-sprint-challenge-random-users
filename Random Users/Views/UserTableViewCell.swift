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
  @IBOutlet weak var userImage: UIImageView!
  @IBOutlet weak var userName: UILabel!

  override func prepareForReuse() {
    userImage.image = #imageLiteral(resourceName: "Lambda_Logo_Full") //
      userName.text = "User Name"
      super.prepareForReuse()
  }

}
