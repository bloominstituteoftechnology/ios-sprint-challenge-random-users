//
//  DetailViewController.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/14/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    let cache = Cache<String, Data>()
    var userClient: UserClient?
    var userResults: Users? {
        didSet {
            updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }


    func updateViews() {

        guard let user = userResults else { return }

        nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.first)"
        phoneNumberLabel.text = "\(user.phone)"
        emailLabel.text = "\(user.email)"

        if let imageCashe = cache.getValue(for: user.email),
            let image = UIImage(data: imageCashe) {
            userImageView.image = image
        }
    }
}
