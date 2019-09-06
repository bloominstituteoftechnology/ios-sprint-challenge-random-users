//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Marlon Raskin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {

	var user: User
	var imageData: Data?
	private var dataTask: URLSessionDataTask?

	init(user: User) {
		self.user = user
		super.init()
	}

	override func start() {
		state = .isExecuting
		fetchThumbnailPhoto()
		fetchLargePhoto()
	}

	private func fetchThumbnailPhoto() {
		let url = user.picture.thumbnail

		dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
			defer { self.state = .isFinished }

			if let error = error {
				print("Error fetching thumbnail photo \(error)")
				return
			}
			self.imageData = data
		})
		dataTask?.resume()
	}

	private func fetchLargePhoto() {
		let url = user.picture.large

		dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
			defer { self.state = .isFinished }

			if let error = error {
				print("Error fetching large photo: \(error)")
				return
			}
			self.imageData = data
		})
		dataTask?.resume()
	}

	override func cancel() {
		dataTask?.cancel()
	}
}
