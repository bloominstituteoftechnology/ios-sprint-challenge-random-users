//
//  UsersController.swift
//  Random Users
//
//  Created by Jeffrey Santana on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
	case badURL
	case noToken
	case noData
	case notDecoding
	case notEncoding
	case other(Error)
}

enum HTTPMethod: String {
	case get = "GET"
	case put = "PUT"
	case post = "POST"
	case delete = "DELETE"
}

typealias resultHandler = (Result<Bool, NetworkError>) -> Void

class UsersController {
	var baseUrlString = "https://randomuser.me/api"
	private(set) var users = [User]()
	
	func getUsers(completion: @escaping resultHandler) {
		var userComponents = URLComponents(string: baseUrlString)
		userComponents?.queryItems = [URLQueryItem(name: "format", value: "json"),
							   URLQueryItem(name: "inc", value: "login,name,email,phone,picture"),
							   URLQueryItem(name: "results", value: "1000")]
		guard let usersUrl = userComponents?.url else { return }
		
		URLSession.shared.dataTask(with: usersUrl) { (data, response, error) in
			if let error = error {
				completion(.failure(.other(error)))
			}
			
			guard let data = data else {
				completion(.failure(.noData))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				let results = try decoder.decode(UserResults.self, from: data)
				self.users = results.results
				completion(.success(true))
			} catch {
				completion(.failure(.notDecoding))
			}
		}.resume()
	}
}
