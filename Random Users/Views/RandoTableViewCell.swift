//
//  RandoTableViewCell.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class RandoTableViewCell: UITableViewCell {

	var randomUserController: RandomUserController?
	var user: RandomUser? {
		didSet {
			updateViews()
		}
	}
	private var imageFetchOp: PhotoFetchOperation?

	private func updateViews() {
		imageFetchOp?.cancel()
		imageFetchOp = nil
		resetToPlaceholderImage()
		guard let user = user else { return }
		textLabel?.text = user.fullName

		// trigger image load
		if let imageData = randomUserController?.cache.value(forKey: user.picture.thumbnail.hashValue) {
			imageView?.image = UIImage(data: imageData)
			return
		}

		let tQueue = OperationQueue()
		tQueue.name = UUID().uuidString

		imageFetchOp = PhotoFetchOperation(photoURL: user.picture.thumbnail)
		guard let imageFetchOp = imageFetchOp else { fatalError() }
		let cacheOp = BlockOperation { [weak self] in
			guard let imageData = imageFetchOp.imageData else { return }
			self?.randomUserController?.cache.cache(value: imageData, forKey: user.picture.thumbnail.hashValue)
		}
		let completionOp = BlockOperation { [weak self] in
			defer { self?.imageFetchOp = nil }
			guard let imageData = imageFetchOp.imageData else { return }
			self?.imageView?.image = UIImage(data: imageData)
		}

		cacheOp.addDependency(imageFetchOp)
		completionOp.addDependency(imageFetchOp)

		tQueue.addOperations([imageFetchOp, cacheOp], waitUntilFinished: false)
		OperationQueue.main.addOperation(completionOp)
	}

	override func prepareForReuse() {
		resetToPlaceholderImage()
	}

	private func resetToPlaceholderImage() {
		imageView?.image = #imageLiteral(resourceName: "skate")
	}
}
