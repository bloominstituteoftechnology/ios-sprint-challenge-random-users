//
//  RandomUserControllers.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class RandomUserController {
	var users = [RandomUser]()


	var userRequestCount = 100
	private let baseURL = URL(string: "https://randomuser.me/api/")!
	func fetchUsers(completion: @escaping (Result<Data?, NetworkError>) -> Void = {_ in }) {
		let query = URLQueryItem(name: "results", value: "\(userRequestCount)")
		var requestURL = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
		requestURL?.queryItems = [query]
		guard let request = requestURL?.url?.request else {
			completion(.failure(.urlInvalid(urlString: requestURL?.url?.absoluteString)))
			return
		}

		NetworkHandler.default.transferMahCodableDatas(with: request) { [weak self] (result: Result<RandomUserResult, NetworkError>) in
			do {
				let results = try result.get()
				self?.users = results.results
				completion(.success(nil))
			} catch {
				NSLog("Error loading random users: \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}
}
