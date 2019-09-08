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
	@IBOutlet weak var imageViewContainer: UIView!

	var userClient: UserClient?
	var user: User? {
		didSet {
			updateViews()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		userImageView.layer.cornerRadius = userImageView.frame.height / 2
		imageViewContainer.layer.cornerRadius = imageViewContainer.frame.height / 2
		imageViewContainer.backgroundColor = UIColor(red: 0.90, green: 0.38, blue: 0.35, alpha: 1.00)
		
		userImageView.image = nil
		updateViews()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		animateImageOnArrival()
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

	private func animateImageOnArrival() {
		UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: [.curveEaseInOut], animations: {
			self.imageViewContainer.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
		}, completion: nil)

		UIView.animate(withDuration: 0.2, delay: 0.3, options: [.curveEaseInOut], animations: {
			self.imageViewContainer.transform = .identity
		}, completion: nil)
	}
}
