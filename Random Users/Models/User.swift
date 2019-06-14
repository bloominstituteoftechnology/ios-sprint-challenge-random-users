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
	let name: String
	let picture: [String]
	
	enum Codingkeys: String, CodingKey {
		case email
		case phone
		case name
		case picture

		enum NameCodingKeys: String, CodingKey {
			case title
			case first
			case last
		}
		
		enum PictureCodingKeys: String, CodingKey {
			case large
			case medium
			case thumbnail
		}
	}
	
	init(from decoder: Decoder) throws {
		let contianer = try decoder.container(keyedBy: Codingkeys.self)
		email = try contianer.decode(String.self, forKey: .email)
		phone = try contianer.decode(String.self, forKey: .phone)
		
		let nameContainer = try contianer.nestedContainer(keyedBy: Codingkeys.NameCodingKeys.self, forKey: .name)
		let title = try nameContainer.decode(String.self, forKey: .title)
		let first = try nameContainer.decode(String.self, forKey: .first)
		let last = try nameContainer.decode(String.self, forKey: .last)
		name = "\(title) \(first) \(last)"
		
		let pictureContainer = try contianer.nestedContainer(keyedBy: Codingkeys.PictureCodingKeys.self, forKey: .picture)
		let thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
		let medium = try pictureContainer.decode(String.self, forKey: .medium)
		let large = try pictureContainer.decode(String.self, forKey: .large)
		picture = [thumbnail, medium, large]
		
	}
}
