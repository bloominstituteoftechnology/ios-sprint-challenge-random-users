//
//  UserResults.swift
//  Random Users
//
//  Created by Marlon Raskin on 9/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct UserResults: Codable {
	var results: [User]
}

struct User: Codable {
	var name: Name
	var email: String
	var phone: String
	var picture: Photos
//	var id: ID

}

struct Name: Codable {
	var title: String
	var first: String
	var last: String
}

struct Photos: Codable {
	var large: URL
	var medium: URL
	var thumbnail: URL
}

//struct ID: Codable {
//	var name: String
//	var value: String
//}
