//
//  DetailViewController.swift
//  Random Users
//
//  Created by Shawn James on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    var user: Result?
    
    private func updateViews() {
        guard let user = user else { return }
        nameLabel.text = "\(user.name.title.rawValue) \(user.name.first) \(user.name.last)"
        phoneLabel.text = user.phone
        emailLabel.text = user.email
    }
    
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

}
