//
//  RandomUserDetailViewController.swift
//  Random Users
//
//  Created by Austin Cole on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let randomUser = randomUser else {return}
        nameLabel.text = Model.shared.getName(randomUser)
        phoneNumberLabel.text = randomUser.phone
        emailAddressLabel.text = randomUser.email
        pictureImageView.image = Model.shared.getImage(randomUser.picture.large)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    
    //MARK: Properties
    
    var randomUser: RandomUser?
}
