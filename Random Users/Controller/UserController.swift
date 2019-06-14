//
//  UserController.swift
//  Random Users
//
//  Created by Hector Steven on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


class UserController {
	
	init() {
		fetchUsers { _ in}
	}
	
	
	func fetchUsers(completion: @escaping (Error?) -> ()) {
		guard let url = baseUrl else { return }
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			if let response = response as? HTTPURLResponse {
				print("fetchUsers Response: \(response.statusCode)")
			}
			
			if let error = error {
				print("fetchUsers Error: \(error)")
			}
			
			guard let data = data else { return }
			print(data)
			
			do {
				let decoded = try JSONDecoder().decode(Results.self, from: data)
				print(decoded.results)
			} catch {
				print("Error decoding json: \(error)")
			}
			
			
			
		}.resume()
		
		
	}
	
	
	
	private let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
	private (set) var users: [User] = []
}
