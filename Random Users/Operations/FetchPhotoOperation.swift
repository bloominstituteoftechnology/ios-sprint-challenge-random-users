//
//  FetchPhotoOperation.swift
//  Random Users
//
//  Created by Percy Ngan on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

//class FetchPhotoOperation: ConcurrentOperation {
//
//	var user: User
//	var imageData: Data?
//	//let photoReference: Photos
//	//private let session: URLSession
//	private var dataTask: URLSessionDataTask?
//
//	init(user: User) {
//		self.user = user
//		super.init()
//	}
//
////	init(photoReference: Photos, session: URLSession = URLSession.shared) {
////		self.photoReference = photoReference
////		self.session = session
////		super.init()
////	}
//
//	override func start() {
//			state = .isExecuting
//			fetchLargePhoto()
//		}
//
//	private func fetchLargePhoto() {
//		let url = user.picture.large
//
//		dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
//			defer { self.state = .isFinished }
//
//			if let error = error {
//				print("Error fetching large photo: \(error)")
//				return
//			}
//			self.imageData = data
//		})
//		dataTask?.resume()
//	}
////	override func start() {
////		state = .isExecuting
////		//guard let imageURL = URL(string: photoReference.thumbnail)!.usingHTTPS else { return }
////		guard let imageURL = URL(string: (photoReference.thumbnail).path) else { return }
////		let task = session.dataTask(with: imageURL) { (data, _, error) in
////			defer { self.state = .isFinished }
////			if self.isCancelled { return }
////			if let error = error {
////				NSLog("Error fetching data for \(self.photoReference): \(error)")
////			}
////			guard let data = data else { return }
////			self.imageData = data
////		}
////		dataTask = task
////		task.resume()
////	}
////
//	override func cancel() {
//		dataTask?.cancel()
//		//super.cancel()
//	}
//
//}
