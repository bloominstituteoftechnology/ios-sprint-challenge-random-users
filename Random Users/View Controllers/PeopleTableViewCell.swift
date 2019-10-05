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
    
    // serial queue so that everyone can use shared resources without using NSLock
    private var queue = DispatchQueue(label: "info.emptybliss.randomusers.ConcurrentSetImageQueue")
    
    // have a function to add items to the cache
    func setImage(image : UIImage) {
        queue.sync {
            if self.thumbnailImage.image == nil {
                self.thumbnailImage.image = image
            }
        }
    }
    
    
    
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
