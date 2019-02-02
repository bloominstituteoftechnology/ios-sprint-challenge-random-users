
import UIKit

// Create a download operation / FetchPhotoOperation

class DownloadImageOperation: ConcurrentOperation {
    
    var imageData: Data?
    
    // need a url to download
    let url: URL
    private var task: URLSessionDataTask?
    
    //private(set) var image: UIImage?
    
    private let completion: (UIImage?) -> Void
    
    // initializer
    // must give a url to the url property before calling super
    // task doesn't matter because it's optional, meaning it's okay if it's nil
    init(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        self.url = url
        self.completion = completionHandler
        
        // not allowed to call super until all of my properties have been given a value
        super.init()
    }
    
    // override start
    override func start() {
        
        self.state = .isExecuting
        
        //create my task and download it
        task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            // what should happen to the data parameter?
            
            if let error = error {
                NSLog("Error loading image: \(error)")
                // report that we weren't able to get an image
                self.completion(nil)
                return
            }
            
            guard let imageData = data else {
                print("Missing data for \(self.url)")
                self.completion(nil)
                return
            }
            
            // Create UIImage from received data
            guard let image = UIImage(data: imageData) else {
                print("Data is not image data for \(self.url)")
                self.completion(nil)
                return
            }
            
            print("Done downloading image for \(self.url)")
            
            // Need to know when this operation is done and whether it got an image or not
            // Create a completion and pass in the image
            self.completion(image)
            
            
            self.task = nil
            self.state = .isFinished
            
        })
        task?.resume()
    }
    
    override func cancel() {
        print("cancelling download for \(url)")
        // If I cancel the download operation, also download the task
        task?.cancel()
        super.cancel()
    }
}
