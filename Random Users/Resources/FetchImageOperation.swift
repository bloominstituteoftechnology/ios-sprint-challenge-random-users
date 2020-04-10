//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Lambda_School_Loaner_268 on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.




import Foundation

// MARK: - FetchUserOperation
class FetchImageOperation: ConcurrentOperation {

// MARK: - Properties
    var imageData: Data?
    var imageURL: String
    var job: URLSessionDataTask?
    

// MARK: - Methods/Overrides
    // MARK: - Init
    init(imageURL: String) {
        self.imageURL = imageURL
    }
    // MARK: - Override Start
    override func start() {
        self.state = .isExecuting
        guard let request = URL(string: imageURL) else {return}
        
        job = URLSession.shared.dataTask(with: request) { (data, _, error) in
            defer { self.state = .isFinished }
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print("No data")
                return
            }
        self.imageData = data
        }
        job?.resume()
    }
    // MARK: - Override Cancel
    override func cancel() {
        self.state = .isFinished
        job?.cancel()
}

}



/*
 func fetchPhotos(from rover: MarsRover,
                 onSol sol: Int,
                 using session: URLSession = URLSession.shared,
                 completion: @escaping ([MarsPhotoReference]?, Error?) -> Void) {
    
    let url = self.url(forPhotosfromRover: rover.name, on: sol)
    fetch(from: url, using: session) { (dictionary: [String : [MarsPhotoReference]]?, error: Error?) in
        guard let photos = dictionary?["photos"] else {
            completion(nil, error)
            return
        }
        completion(photos, nil)
    }
}

// MARK: - Private

private func fetch<T: Codable>(from url: URL,
                       using session: URLSession = URLSession.shared,
                       completion: @escaping (T?, Error?) -> Void) {
    session.dataTask(with: url) { (data, response, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, NSError(domain: "com.LambdaSchool.Astronomy.ErrorDomain", code: -1, userInfo: nil))
            return
        }
        
        do {
            let jsonDecoder = MarsPhotoReference.jsonDecoder
            let decodedObject = try jsonDecoder.decode(T.self, from: data)
            completion(decodedObject, nil)
        } catch {
            completion(nil, error)
        }
    }.resume()
}
*/
