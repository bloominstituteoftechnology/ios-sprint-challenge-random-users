//
//  RandomUsersClient.swift
//  Random Users
//
//  Created by Marlon Raskin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class UserClient {

	let userURL = URL(string: "https://randomuser.me/api/?results=1000")!
	var users: [User] = []

	func fetchUsers(completion: @escaping(Error?) -> Void) {
		URLSession.shared.dataTask(with: userURL) { (data, _, error) in
			if let error = error {
				NSLog("Error fetching users \(error)")
				completion(error)
				return
			}

			guard let data = data else {
				completion(error)
				return
			}

			do {
				let jsonDecoder = JSONDecoder()
				let resultData = try jsonDecoder.decode(UserResults.self, from: data)
				self.users = resultData.results
			} catch {
				NSLog("Error decoding users \(error)")
			}
		}.resume()
	}

	func fetchThumbnails(with url: URL, completion: @escaping(Error?) -> Void) {
		
	}
}
