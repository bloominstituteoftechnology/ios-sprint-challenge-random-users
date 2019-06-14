//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Hector Steven on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class FetchPhotoOperation: ConcurrentOperation {
	override func start() {
		state = .isExecuting
		guard let url = URL(string: userImageUrl) else { return }
		
		task = URLSession.shared.dataTask(with: url){ data, _, error in
			if let error = error {
				print("Error fetching image: \(error)")
				return
			}
			
			guard let data = data else { return }
			self.imageData = data
			defer {self.state = .isFinished}
		}
		
		task?.resume()
	}
	
	
	override func cancel() {
		task?.cancel()
	}
	
	init(userImageUrl: String) {
		self.userImageUrl = userImageUrl
	}
	
	let userImageUrl: String
	var imageData: Data?
	private var task: URLSessionDataTask?
}
