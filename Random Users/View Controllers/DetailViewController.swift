//
//  DetailViewController.swift
//  Random Users
//
//  Created by Marlon Raskin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!

	var userClient: UserClient?
	var user: User? {
		didSet {
			updateViews()
		}
	}
	

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	private func updateViews() {
		loadViewIfNeeded()
		if let user = user {
			nameLabel.text = "\(user.name.title) \(user.name.first) \(user.name.last)"
			phoneLabel.text = "\(user.phone)"
			phoneLabel.text = "\(user.email)"
		}

		guard let client = userClient,
		 	let user = user else { return }
		client.fetchPhoto(with: user.picture.large) { (error) in
			<#code#>
		}
	}
}
