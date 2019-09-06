//
//  User.swift
//  Random Users
//
//  Created by Jeffrey Santana on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct User: Codable {
	struct PictureTypes: Codable {
		let thumbnail, medium, large: URL
	}
	
	struct NameParts: Codable {
		let title, first, last: String
		
	}
	
	let name: String
	let email: String
	let phone: String
	let picture: PictureTypes
	
	enum CodingKeys: String, CodingKey {
		case name, email, phone, picture
	}
	
	enum NameKeys: String, CodingKey {
		case title, first, last
	}
	
	enum PictureKeys: String, CodingKey {
		case thumbnail, medium, large
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let nameParts = try container.decode(NameParts.self, forKey: .name)
		name = [nameParts.title, nameParts.first, nameParts.last].joined(separator: " ")
		
		email = try container.decode(String.self, forKey: .email)
		phone = try container.decode(String.self, forKey: .phone)
		picture = try container.decode(PictureTypes.self, forKey: .picture)
		
//		let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
//		let title = try nameContainer.decode(String.self, forKey: .title)
//		let firstName = try nameContainer.decode(String.self, forKey: .first)
//		let lastName = try nameContainer.decode(String.self, forKey: .last)
//		name = [title,firstName,lastName].joined(separator: " ")
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(email, forKey: .email)
		try container.encode(phone, forKey: .phone)
		
		var nameContainer = container.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
		var nameParts = name.split(separator: " ")
		try nameContainer.encode(String(nameParts.removeFirst()), forKey: .title)
		try nameContainer.encode(String(nameParts.removeFirst()), forKey: .first)
		try nameContainer.encode(String(nameParts.removeFirst()), forKey: .last)
		
		var picturesContainer = container.nestedContainer(keyedBy: PictureKeys.self, forKey: .picture)
		try picturesContainer.encode(picture.thumbnail.absoluteString, forKey: .thumbnail)
		try picturesContainer.encode(picture.medium.absoluteString, forKey: .medium)
		try picturesContainer.encode(picture.large.absoluteString, forKey: .large)
		
	}
}

