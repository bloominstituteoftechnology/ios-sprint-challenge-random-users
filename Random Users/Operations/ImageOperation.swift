import Foundation

class ImageOperation: ConcurrentOperation {
    
    var imageUrl: User
    var imageData: Data? = nil
    private var userDataTask: URLSessionDataTask?
    
    init(imageUrl: User) {
        self.imageUrl = imageUrl
    }
    
    override func start() {
        super.start()
        self.state = .isExecuting
        
        let url = URLRequest(url: imageUrl.thumbnail!)
        
        userDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching images from data task: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("Image data error from data task")
                return
            }
            self.imageData = data
            
            self.state = .isFinished
        })
        userDataTask?.resume()
    }
    
    override func cancel() {
        userDataTask?.cancel()
        super.cancel()
    }
}


