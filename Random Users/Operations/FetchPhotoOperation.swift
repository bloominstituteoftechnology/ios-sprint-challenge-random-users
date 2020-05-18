import Foundation
import UIKit

class FetchPhotoOperation: ConcurrentOperation {
    var imageURL: URL
    var imageData: UIImage?
    var theDataTask: URLSessionDataTask? = nil
    
    init(imageURL: URL, imageData: UIImage? = nil) {
        self.imageURL = imageURL
        self.imageData = imageData
    }
    
    override func start() {
        state = .isExecuting

        fetchImage(of: imageURL) { result in
            if let image = try? result.get() {
                self.imageData = image
                self.state = .isFinished
            }
        }
    }
    
    override func cancel() {
        if let dataTask = theDataTask {
            dataTask.cancel()
            print("Data Task was Canceled" )
        }
    }


    // MARK: - Functions
    
    private func fetchImage(of imageUrl: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        var request = URLRequest(url: imageUrl)
        request.httpMethod = HTTPMethod.get.rawValue
        
        theDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("\(error)")
                completion(.failure(.otherNetworkError))
                return
            }
            
            guard let data = data else {
                print("No data")
                completion(.failure(.badData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("No data")
                completion(.failure(.badData))
                return
            }

            completion(.success(image))

        }
        theDataTask!.resume()
    }
}
