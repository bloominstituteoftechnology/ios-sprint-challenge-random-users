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
		userImageView.layer.cornerRadius = 6
		userImageView.image = nil
		updateViews()
    }

	private func updateViews() {
		loadViewIfNeeded()
		if let user = user {
			nameLabel.text = "\(user.name.title.capitalized) \(user.name.first.capitalized) \(user.name.last.capitalized)"
			phoneLabel.text = "\(user.phone)"
			emailLabel.text = "\(user.email)"

			URLSession.shared.dataTask(with: user.picture.large) { (data, _, error) in
				if let error = error {
					NSLog("Error fetching photo: \(error)")
					return
				}

				guard let data = data else { return }
				DispatchQueue.main.async {
					self.userImageView.image = UIImage(data: data)
				}
			}.resume()
		}
	}
}
