//
//  PeopleController.swift
//  Random Users
//
//  Created by Hector Steven on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class PeopleController {
	
	func fetch(completion: @escaping (Error?) -> ()) {
		
		let shared = URLSession.shared
		let _ = shared.dataTask(with: baseUrl) { data, response, error in
			if let response = response as? HTTPURLResponse {
				NSLog("Response Code: \(response.statusCode)")
			}
			
			if let error = error {
				NSLog("Error fetching data \(error)")
				completion(error)
				return
			}
			
			guard let data = data else { return }
			print(data)
			
			do {
				let peopleDecode = try JSONDecoder().decode([String: Person].self, from: data)
				print(peopleDecode.values)
				
				completion(nil)
			} catch {
				NSLog("Error Decoding people: \(error)")
				completion(error)
				return
			}
			
			
			
			
		}.resume()
		
		
		
	}
	
	
	
	var baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
	var poeple: [Person] = []
}
