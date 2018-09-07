//
//  Model.swift
//  Random Users
//
//  Created by William Bundy on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

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

		name = "\(title). \(first) \(last)"

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

class PersonController
{
	static var shared = PersonController()

	var people:[Person] = []
	var thumbs:Cache<URL, UIImage> = Cache()
	var images:Cache<URL, UIImage> = Cache()

	func load(_ completion:@escaping (String?)->Void)
	{
		// this is fine for now.
		people = [Person()]
		let baseURL = URL(string:"https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
		URLSession.shared.dataTask(with: baseURL) { data, _, error in
			if let error = error {
				NSLog("There was an error \(error)");
				completion("There was an error")
				return
			}

			guard let data = data else {
				NSLog("Error: no data")
				completion("No data")
				return
			}

			do {
				let results = try JSONDecoder().decode(Person.Results.self, from: data)
				self.people = results.results
				completion(nil)
				return
			} catch {
				NSLog("Error decoding json: \(error)")
				NSLog(String(data:data, encoding:.utf8) ?? "Couldn't encode json as utf8")
				completion("Couldn't decode json")
				return
			}
		}.resume()
	}
}

class FetchPhotoOperation:ConcurrentOperation
{
	var imageData:UIImage!
	var task:URLSessionDataTask!
	var url:URL

	init(_ url:URL)
	{
		self.url = url
		super.init()
	}

	override func start() {
		state = .isExecuting
		task = URLSession.shared.dataTask(with: self.url) { data, _, error in
			defer { self.state = .isFinished}
			if let error = error {
				NSLog("wb: Error loading image: \(error)")
				return
			}

			guard let data = data else {
				NSLog("wb: Error: no image data")
				return
			}

			if let img = UIImage(data: data) {
				self.imageData = img
				return
			} else {
				NSLog("wb: Couldn't decode image")
				return
			}
		}
		task.resume()
	}

	override func cancel() {
		if let task = task {
			task.cancel()
		}
	}
}
