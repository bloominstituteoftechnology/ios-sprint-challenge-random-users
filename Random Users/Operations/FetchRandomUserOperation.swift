//import Foundation
//
//class FetchRandomUserOperation: ConcurrentOperation {
//    
//    let largeImageURL: URL
//    let thumbnailURL: URL
//    let reference: RandomPerson
//    var imageData: Data?
//    
//
//    private var task: URLSessionDataTask?
//
//    init(reference: RandomPerson) {
//        //self.reference = reference
//        //self.thumbnailURL = (URL(string: reference.results[0].picture.thumbnail)?.usingHTTPS!)!
//        //self.largeImageURL = (URL(string: reference.results[0].picture.large)?.usingHTTPS!)!
////            reference.imageURL.usingHTTPS!
////        super.init()
////    }
//    
//    
//    override func start() {
//        self.state = .isExecuting
//        task = URLSession.shared.dataTask(with: largeImageURL, completionHandler: { (data, _, error) in
//            //unwrap the data
//            guard error == nil, let data = data else {
//                if let error = error {
//                    NSLog("Error unwarapping data: \(error)")
//                    return
//                }
//                NSLog("Unable to fetch data")
//                return
//            }
//            //test
//            print("no error and have data: \(data)")
//
//            self.imageData = data
//
//            defer{
//                self.state = .isFinished
//            }
//        })
//        task?.resume()
//    }
//
//    override func cancel() {
//        task?.cancel()
//        super.cancel()
//    }
//}

