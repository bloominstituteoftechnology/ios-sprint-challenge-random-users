//
//  User.swift
//  Random Users
//
//  Created by Percy Ngan on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct UserReference: Codable {
	var results: [User]
}

struct User: Codable {
	var name: Name
	var email: String
	var id: ID
	var phone: String
	var cell: String
	var picture: Photos
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

struct ID: Codable {
	var name: String
	var value: String
}
