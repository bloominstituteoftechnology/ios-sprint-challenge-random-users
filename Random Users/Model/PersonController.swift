
import Foundation
import UIKit
import CoreData

class PersonController
{
	static var shared = PersonController()

	var people:[Person] = []
	var thumbs:Cache<URL, UIImage> = Cache()
	var images:Cache<URL, UIImage> = Cache()

	func load(_ completion:@escaping (String?)->Void)
	{
		people = [Person()]

		// this is fine for now.
		// we could do some fancy stuff but whatever
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
