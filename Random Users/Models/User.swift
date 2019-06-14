//
//  User.swift
//  Random Users
//
//  Created by Hector Steven on 6/14/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation


struct Results: Decodable {
	let results: [User]
}

struct User: Decodable {
	let email: String
	let phone: String
	
	enum Codingkeys: String, CodingKey {
		case email
		case phone
	}
	
	init(from decoder: Decoder) throws {
		let contianer = try decoder.container(keyedBy: Codingkeys.self)
		email = try contianer.decode(String.self, forKey: .email)
		phone = try contianer.decode(String.self, forKey: .phone)
		
		
	}
}
