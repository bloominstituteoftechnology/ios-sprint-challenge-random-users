//
//  PeopleTableViewCell.swift
//  Random Users
//
//  Created by Joshua Sharp on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    var person: Person?{
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    
    
    private func updateViews() {
        guard let person = person else { return}
        let name = "\(person.name.title) \(person.name.first) \(person.name.last)"
        nameLabel.text = name
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
