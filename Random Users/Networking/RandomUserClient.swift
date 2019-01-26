//
//  RandomUserClient.swift
//  Random Users
//
//  Created by Benjamin Hakes on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserClient {
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Networking
    func fetchAllContent(using session: URLSession = URLSession.shared,
                        completion: @escaping (Results?, Error?) -> Void) {
        
        let url = baseURL
        fetch(from: url, using: session) { (results: Results?, error: Error?) in
            
            completion(results, nil)
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
//            print("Data: \(data), Response: \(response), Error: \(error)")
            
            guard let data = data else {
                completion(nil, NSError(domain: "com.benhakes.randomuser.ErrorDomain", code: -1, userInfo: nil))
                return
            }
            
            do {
                let jsonDecoder = Results.jsonDecoder
                let decodedObject = try jsonDecoder.decode(T.self, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
            }.resume()
    }
    
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    var cache = Cache<Int,RandomUser>()
}
