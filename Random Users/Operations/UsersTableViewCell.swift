//
//  UsersTableViewCell.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
       
     @IBOutlet weak var nameLabel: UILabel!

       var user: User? {
           didSet {
               updateViews()

           }
       }

       override func awakeFromNib() {
           super.awakeFromNib()
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

           // Configure the view for the selected state
       }

       func updateViews() {
           guard let user = user else { return }
           nameLabel.text = user.name

       }


}
