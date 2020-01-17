//
//  RandomUserTableViewCell.swift
//  Random Users
//
//  Created by Rick Wolter on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserTableViewCell: UITableViewCell {

    var user: User? {
        didSet{
            updateView()
        }
    }
 
    @IBOutlet weak var randomUserNameLabel: UILabel!
    @IBOutlet weak var randomUserThumbnailImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func updateView(){
       guard let user = user else { return }
        randomUserNameLabel.text = "\(user.name.last), \(user.name.first) "
    }

}
