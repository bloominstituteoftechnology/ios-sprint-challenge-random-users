//
//  FetchPhotoOperaton.swift
//  Random Users
//
//  Created by Percy Ngan on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {

	let photoReference: User
	private(set) var imageData: Data?
	private let session: URLSession
	private var dataTask: URLSessionDataTask?

	init(photoReference: User, session: URLSession = URLSession.shared) {
		self.photoReference = photoReference
		self.session = session
		super.init()
	}

	override func start() {
		state = .isExecuting

	}

	override func cancel() {

	}

}
