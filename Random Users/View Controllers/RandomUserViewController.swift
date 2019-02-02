//
//  RandomUserViewController.swift
//  Random Users
//
//  Created by Ivan Caldwell on 2/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserViewController: UIViewController {

    // Variables & Constants
    var randomUser: RandomUser?
    
    // Outlets and Actions
    @IBOutlet weak var randomUserEmailLabel: UILabel!
    @IBOutlet weak var randomUserPhoneLabel: UILabel!
    @IBOutlet weak var randomUserNameLabel: UILabel!
    @IBOutlet weak var randomUserImageView: UIImageView!
    
    // View Overrides Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let randomUser = randomUser else { return }
        randomUserNameLabel.text = "\(randomUser.title.capitalized). \(randomUser.first.capitalized) \(randomUser.last.capitalized)"
        randomUserPhoneLabel.text = randomUser.phone
        randomUserEmailLabel.text = randomUser.email
        let imageData = try! Data(contentsOf: randomUser.picture)
        randomUserImageView.image = UIImage(data: imageData)
    }

}
