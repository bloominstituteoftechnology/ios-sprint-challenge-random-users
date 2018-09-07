
import Foundation
import UIKit
import CoreData

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
