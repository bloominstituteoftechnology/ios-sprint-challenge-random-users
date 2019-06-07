//
//  Person.swift
//  Random Users
//
//  Created by Hector Steven on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation





//	{
//		"name": {
//			"title": "mr",
//			"first": "vilho",
//			"last": "joki"
//		},
//		"email": "vilho.joki@example.com",
//		"phone": "02-686-913",
//		"picture": {
//			"large": "https://randomuser.me/api/portraits/men/57.jpg",
//			"medium": "https://randomuser.me/api/portraits/med/men/57.jpg",
//			"thumbnail": "https://randomuser.me/api/portraits/thumb/men/57.jpg"
//		}
//}





struct Person: Codable {
//	let email: String
	
}


struct Name: Codable {
	let first: String
	let last: String
	
	
}


//struct Person: Codable {
//	let name: [String]
////	let picture: String
//
//
//	enum PerosnCodingKeys: String, CodingKey {
//		case name
////		case picture
//
//		enum NameCodingKey: String, CodingKey {
//			case first
//			case last
//		}
//
////		enum PictureCodingKey: String, CodingKey {
////			case thumbnail
////		}
//
//
//	}
//
//	init(from decoder: Decoder) throws {
//		let container = try decoder.container(keyedBy: PerosnCodingKeys.self)
//
//		let nameContainer = try container.nestedContainer(keyedBy: PerosnCodingKeys.NameCodingKey.self, forKey: .name)
//
//
//
//		name = []
//
//
////		let first  = try nameContainer.decode(String.self, forKey: .first)
////		let last = try nameContainer.decode(String.self, forKey: .last)
////		name = first + " " + last
////
////		let pictureContainer = try container.nestedContainer(keyedBy: PerosnCodingKeys.PictureCodingKey.self, forKey: .picture)
////		picture = try pictureContainer.decode(String.self, forKey: .thumbnail)
//	}
//
//
//}
