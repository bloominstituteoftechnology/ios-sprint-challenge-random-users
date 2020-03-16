//
//  UserTableViewCell.swift
//  Random Users
//
//  Created by Chris Gonzales on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var userClient: UserClient?
    var user: User?{
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet var thumbnailImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    func updateViews(){
        guard let user = user,
            let userClient = userClient else { return }
        let firstName = user.first.capitalized
        let lastName = user.last.capitalized
        let fullName = "\(firstName) \(lastName)"
        
        nameLabel.text = fullName
        
        userClient.fetchPictures(for: user.thumbnail) { (result) in
            if let result = try? result.get() {
                DispatchQueue.main.async {
                    let image = UIImage(data: result)
                    self.thumbnailImage.image = image
                }
            }
        }
    }
}
