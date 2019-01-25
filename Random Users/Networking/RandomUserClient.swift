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
    
    
    // MARK: - Networking
    func getRandomUser(completion: @escaping CompletionHandler = { _ in }){
            URLSession.shared.dataTask(with: baseURL){(data, _, error) in
                
                if let error = error {
                    NSLog("Error GETting albums from server: \(error)")
                    completion(error)
                    return
                }
                
                guard let data = data else {
                    NSLog("No data was returned.")
                    completion(NSError())
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(Results.self, from: data)
                    
                    // add data to the cache
                    var count = 0
                    
                    
                    for randomUser in decodedObject.results{
                        
                        self.cache.cache(value: randomUser, for: count)
                        
                        if count < 2 {
                            print(randomUser)
                        }
                        count += 1
                        
                    }
                    
                    completion(nil)
                    return
                } catch {
                    NSLog("Error decoding albums: \(error)")
                    completion(error)
                    return
                }
                
        }.resume()
    }
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    var cache = Cache<Int,RandomUser>()
}
