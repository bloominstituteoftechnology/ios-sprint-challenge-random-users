
import Foundation
import UIKit
import CoreData

struct Person:Codable
{
	var name:String
	var email:String
	var phone:String

	var largeImg:URL!
	var thumbImg:URL!

	init()
	{
		name = "Loading..."
		email = ""
		phone = ""
		largeImg = nil
		thumbImg = nil
	}

	init(from decoder:Decoder) throws
	{
		let con = try decoder.container(keyedBy: TopLevelKeys.self)
		name = ""
		email = try con.decode(String.self, forKey: .email)
		phone = try con.decode(String.self, forKey: .phone)

		let nameCon = try con.nestedContainer(keyedBy: NameKeys.self, forKey: .name)
		let title = try nameCon.decode(String.self, forKey: .title).capitalized
		let first = try nameCon.decode(String.self, forKey: .first).capitalized
		let last = try nameCon.decode(String.self, forKey: .last).capitalized

		name = "\(title) \(first) \(last)"

		let photoCon = try con.nestedContainer(keyedBy: PhotoKeys.self, forKey: .picture)
		largeImg = try photoCon.decode(URL.self, forKey: .large)
		thumbImg = try photoCon.decode(URL.self, forKey: .thumbnail)
	}

	enum TopLevelKeys:String, CodingKey
	{
		case name
		case email
		case phone
		case picture
	}

	enum NameKeys:String, CodingKey
	{
		case title
		case first
		case last
	}

	enum PhotoKeys:String, CodingKey
	{
		case large
		case medium
		case thumbnail
	}

	struct Results:Codable
	{
		var results:[Person]
	}
}
