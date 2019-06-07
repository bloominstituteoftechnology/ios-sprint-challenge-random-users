//
//  RandoDetailViewController.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandoDetailViewController: UIViewController {

	@IBOutlet var userImageView: UIImageView!
	@IBOutlet var emailButton: UIButton!
	@IBOutlet var phoneButton: UIButton!
	@IBOutlet var cellButton: UIButton!
	@IBOutlet var nameLabel: UILabel!

	var randomUserController: RandomUserController?
	var user: RandomUser? {
		didSet {
			updateViews()
		}
	}
	private var photoFetchOp: PhotoFetchOperation?

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2
		for button in [phoneButton, cellButton, emailButton] {
			button?.roundCorners()
		}
	}

	private func updateViews() {
		photoFetchOp?.cancel()
		photoFetchOp = nil
		guard let user = user else { return }
		loadViewIfNeeded()
		navigationItem.title = user.fullNameWithTitle
		emailButton.setTitle(user.email, for: .normal)
		phoneButton.setTitle(user.phone, for: .normal)
		cellButton.setTitle(user.cell, for: .normal)
		nameLabel.text = user.fullName

		if let imageData = randomUserController?.cache.value(forKey: user.picture.large.hashValue) {
			userImageView.image = UIImage(data: imageData)
			return
		}

		let tQueue = OperationQueue()
		tQueue.name = UUID().uuidString

		photoFetchOp = PhotoFetchOperation(photoURL: user.picture.large)
		let cacheOp = BlockOperation { [weak self] in
			guard let imageData = self?.photoFetchOp?.imageData else { return }
			self?.randomUserController?.cache.cache(value: imageData, forKey: user.picture.large.hashValue)
		}
		let completionOp = BlockOperation { [weak self] in
			defer { self?.photoFetchOp = nil }
			guard let imageData = self?.photoFetchOp?.imageData else { return }
			self?.userImageView.image = UIImage(data: imageData)
		}

		guard let photoFetchOp = photoFetchOp else { return }
		cacheOp.addDependency(photoFetchOp)
		completionOp.addDependency(photoFetchOp)
		tQueue.addOperations([photoFetchOp, cacheOp], waitUntilFinished: false)
		OperationQueue.main.addOperation(completionOp)
	}

	@IBAction func emailButtonPressed(_ sender: UIButton) {
		guard let emailString = sender.titleLabel?.text else { return }
		guard let url = URL(string: "mailto:\(emailString)") else {
			print("user has illegal characters in their email")
			return
		}
		print("(will open on actual device) opening email app via: \(url)")
		UIApplication.shared.open(url)
	}

	@IBAction func phoneButtonPressed(_ sender: UIButton) {
		guard let phoneString = sender.titleLabel?.text else { return }
		guard let url = URL(string: "tel://\(phoneString)") else { return }
		print("(will open on actual device) opening phone app to call via: \(url)")
		UIApplication.shared.open(url)
	}
}


extension UIButton {
	func roundCorners(radius: CGFloat = 10) {
		self.layer.cornerRadius = 10
	}
}
