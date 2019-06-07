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
	@IBOutlet var emailLabel: UILabel!
	@IBOutlet var phoneLabel: UILabel!
	@IBOutlet var cellLabel: UILabel!

	var randomUserController: RandomUserController?
	var user: RandomUser? {
		didSet {
			updateViews()
		}
	}
	private var photoFetchOp: PhotoFetchOperation?

	private func updateViews() {
		photoFetchOp?.cancel()
		photoFetchOp = nil
		guard let user = user else { return }
		loadViewIfNeeded()
		navigationItem.title = user.fullNameWithTitle
		emailLabel.text = user.email
		phoneLabel.text = user.phone
		cellLabel.text = user.cell
		userImageView.layer.cornerRadius = userImageView.frame.size.width / 2

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

}
