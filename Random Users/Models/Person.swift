//
//  Person.swift
//  Random Users
//
//  Created by Hector Steven on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation





struct Person: Codable, Equatable {
	
	let name: String
	let picture: String

	
	enum CodingKeys: String, CodingKey {
		case name
		case picture
		
		enum NameCodingKey: String, CodingKey {
			case name
		}
		
		enum PictureCodingKey: String, CodingKey {
			case thumbnail
		}
		
		
	}
	
	
	
}
