// Frulwinn

import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    
    //MARK: - Properties
    var imageData: Data?
    let url: URL
    
    private var task: URLSessionDataTask?
    private let completion: (UIImage?) -> Void
    
    
    init(url: URL, completion: @escaping (UIImage?) -> Void) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        
        defer {
            state = .isFinished
        }
        
        task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            
            if let error = error {
                NSLog("Error loading image: \(error)")
                self.completion(nil)
                return
            }
            
            guard let imageData = data else {
                print("Missing data for url")
                self.completion(nil)
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                print("Data is not image data")
                self.completion(nil)
                return
            }
            
            self.completion(image)
            self.task = nil
        })
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
}
