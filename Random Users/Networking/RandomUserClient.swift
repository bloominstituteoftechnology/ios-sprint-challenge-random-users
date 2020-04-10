//
//  RandomUserClient.swift
//  Random Users
//
//  Created by Mark Gerrior on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserClient {
    
    func fetchRandomUser(number count: Int,
                         using session: URLSession = URLSession.shared,
                         completion: @escaping (User?, Error?) -> Void) {
        
        let url = self.url(count: count)
//        fetch(from: url, using: session) { (dictionary: [String : [RandomUser]]?, error: Error?) in
//            guard let rover = dictionary?["photo_manifest"] else {
//                completion(nil, error)
//                return
//            }
//            completion(rover, nil)
//        }
    }
    
    // MARK: - Private
    
    private func fetch<T: Codable>(from url: URL,
                           using session: URLSession = URLSession.shared,
                           completion: @escaping ([T]?, Error?) -> Void) {
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
                let decodedObject = try JSONDecoder().decode(T.self, from: data)

                completion([decodedObject], nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    // FIXME: Hard coded to 1000
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    private func url(count _: Int) -> URL {
        let url = baseURL
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        return urlComponents.url!
    }
}
