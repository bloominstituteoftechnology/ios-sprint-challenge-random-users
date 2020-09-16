//
//  UsersDetailViewController.swift
//  Random Users
//
//  Created by Gladymir Philippe on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersDetailViewController: UIViewController {

    var randomUsersApiController: RandomUsersApiController?
    var user: User? {
        didSet {
       //     updateViews()
        }
    }
   

    @IBOutlet weak var largePhotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        guard let user = user else { return }
        nameLabel.text = user.name
        phoneNumberLabel.text = user.phone
        emailLabel.text = user.email

        do {
            let url = user.largeImage //else do { return } //guard
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            largePhotoImageView.image = image
        } catch {
            print("\(error)")
        }
    }
}
