//
//  ContactTableViewCell.swift
//  Random Users
//
//  Created by Farhan on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
//    let placeholderImage = UIImage(named: "Lambda_Logo_Full")
    
    override func prepareForReuse() {
        userImageView.image = #imageLiteral(resourceName: "Lambda_Logo_Full.pdf")
        super.prepareForReuse()
    }
    
    //DONT NEED TO PASS IT BECAUSE WE WILL EDIT IT IN THE TVC
//    var user: Users.User?{
//        didSet{
//            DispatchQueue.main.async {
//                self.updateViews()
//            }
//        }
//    }
//
//    func updateViews(){
//
//    }

}
