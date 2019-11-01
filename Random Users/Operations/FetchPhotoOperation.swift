//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Percy Ngan on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {

	let photoReference: Photos
	private(set) var imageData: Data?
	private let session: URLSession
	private var dataTask: URLSessionDataTask?

	init(photoReference: Photos, session: URLSession = URLSession.shared) {
		self.photoReference = photoReference
		self.session = session
		super.init()
	}

	override func start() {
		state = .isExecuting
		guard let imageURL = URL(string: photoReference.thumbnail)!.usingHTTPS else { return }
		let task = session.dataTask(with: imageURL) { (data, _, error) in
			defer { self.state = .isFinished }
			if self.isCancelled { return }
			if let error = error {
				NSLog("Error fetching data for \(self.photoReference): \(error)")
			}
			guard let data = data else { return }
			self.imageData = data
		}
		dataTask = task
		task.resume()
	}

	override func cancel() {
		dataTask?.cancel()
		super.cancel()
	}

}
