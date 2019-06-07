//
//  RandomUserControllers.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class RandomUserController {
	private(set) var users = [RandomUser]() {
		didSet {
			sectionUsers()
		}
	}
	private(set) var sectionedUsers = [[RandomUser]]()
	let cache = Cache<Int, Data>()

	var userRequestCount = 1000
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
				self?.users = results.results.sorted { $0.lastName < $1.lastName }
				completion(.success(nil))
			} catch {
				NSLog("Error loading random users: \(error)")
				completion(.failure(error as? NetworkError ?? NetworkError.otherError(error: error)))
			}
		}
	}

	private func sectionUsers() {
		var sectionArray = [[RandomUser]]()
		var tArray = [RandomUser]()

		for user in users {
			guard let letter = user.lastName.first else { print("FOOLS"); return }
			if tArray.count == 0 {
				tArray.append(user)
			} else {
				guard let tLetter = tArray[0].lastName.first else { print("FLY"); return }
				if tLetter != letter {
					sectionArray.append(tArray)
					tArray = []
				}
				tArray.append(user)
			}
		}
		sectionArray.append(tArray)
		sectionedUsers = sectionArray
	}
}
