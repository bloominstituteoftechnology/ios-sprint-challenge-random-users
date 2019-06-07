//
//  PhotoFetchOperation.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PhotoFetchOperation: ConcurrentOperation {
	let photoURL: URL
	var imageData: Data?
	private var currentTask: URLSessionDataTask?

	init(photoURL: URL) {
		self.photoURL = photoURL
	}

	override func start() {
		let request = photoURL.request
		state = .isExecuting
		currentTask = NetworkHandler.default.transferMahDatas(with: request, completion: { [weak self] (result: Result<Data, NetworkError>) in
			guard let self = self else { return }
			defer { self.state = .isFinished }

			do {
				self.imageData = try result.get()
			} catch {
				NSLog("There was an error loading an image: \(error)")
			}
		})
	}

	override func cancel() {
		currentTask?.cancel()
		super.cancel()
	}
}
