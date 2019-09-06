//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Jeffrey Santana on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
	var user: User
	var imageData: Data?
	private var dataTask: URLSessionDataTask?
	
	init(user: User) {
		self.user = user
	}
	
	override func start() {
		super.start()
		state = .isExecuting
		
		dataTask = URLSession.shared.dataTask(with: user.picture.thumbnail) { (data, response, error) in
			defer {
				self.state = .isFinished
			}
			
			if self.isCancelled {
				return
			}
			
			if let error = error {
				print("Error fetching photos: \(error.localizedDescription)")
				return
			}
			
			guard let data = data else {
				print("No data found")
				return }
			
			self.imageData = data
		}
		dataTask?.resume()
	}
	
	override func cancel() {
		super.cancel()
		dataTask?.cancel()
	}
}
