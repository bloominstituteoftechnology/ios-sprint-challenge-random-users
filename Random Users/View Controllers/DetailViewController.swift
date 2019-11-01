//
//  DetailViewController.swift
//  Random Users
//
//  Created by Percy Ngan on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var userImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!

	var user: User? {
		didSet {
			updateViews()
		}
	}
	var cache: Cache<String, UIImage>?

	override func viewDidLoad() {
		super.viewDidLoad()

		updateViews()
	}

	private func updateViews() {
		guard let cache = cache, let user = user, isViewLoaded else { return }

		if let image = cache.fetch(key: "\(user.picture.large)") {
			userImageView.image = image
		} else {
			guard let imageURL = URL(string: user.picture.large) else { return }
			let imageRequest = URLRequest(url: imageURL)

			URLSession.shared.dataTask(with: imageRequest) { (data, _, error) in
				if let error = error {
					NSLog("Error fetching image data: \(error)")
					return
				}

				guard let data = data else {
					NSLog("No data returned.")
					return
				}

				DispatchQueue.main.async {
					let image = UIImage(data: data)
					self.userImageView.image = image

					if let image = image {
						self.cache?.imageCache["\(user.picture.large)"] = image
					}
				}
			}.resume()
		}

		title = "\(user.name.title.uppercased()). \(user.name.last.capitalized)"
		nameLabel.text = "\(user.name.title.uppercased()). \(user.name.first.capitalized) \(user.name.last.capitalized)"
		phoneLabel.text = "Cell: \(user.cell)\nPhone: \(user.phone)"
		emailLabel.text = "\(user.email)"
	}
}
