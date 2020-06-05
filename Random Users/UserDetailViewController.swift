//
//  UserDetailViewController.swift
//  Random Users
//
//  Created by Harmony Radley on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var detailUserImageView: UIImageView!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    // MARK: - Properties
    var user: User? {
        didSet {
            updateViews()
        }
    }

    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard isViewLoaded,
            let user = user else { return }
        title = user.name
        emailLabel.text = user.email
        phoneNumberLabel.text = user.phone
        guard let imageData = try? Data(contentsOf: user.large!) else { fatalError() }
        detailUserImageView.image = UIImage(data: imageData)
    }


}
