//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Mark Poggi on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {


    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var user: User? {
        didSet {
         updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }

    func updateViews() {
        guard isViewLoaded,
            let user = user else { return }
        title = user.name.first.capitalized + " " + user.name.last.capitalized
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        guard let imageData = try? Data(contentsOf: user.picture.large) else { fatalError() }
        imageView.image = UIImage(data: imageData)
    }


}
