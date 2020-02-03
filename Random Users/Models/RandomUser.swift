//
//  RandomUser.swift
//  Random Users
//
//  Created by Michael Redig on 6/7/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

struct RandomUser: Codable {

	struct Name: Codable {
		let title: String
		let first: String
		let last: String
	}

	private let name: Name
	var title: String {
		return name.title.capitalized
	}
	var firstName: String {
		return name.first.capitalized
	}
	var lastName: String {
		return name.last.capitalized
	}
	var fullNameWithTitle: String {
		return "\(title) \(firstName) \(lastName)"
	}
	var fullName: String {
		return "\(firstName) \(lastName)"
	}

	struct PhotoURLs: Codable {
		let large: URL
		let medium: URL
		let thumbnail: URL
	}

	let picture: PhotoURLs

	let email: String
	let phone: String
	let cell: String

}
