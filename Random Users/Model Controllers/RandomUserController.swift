//
//  RandomUserController.swift
//  Random Users
//
//  Created by Jordan Christensen on 10/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserController {
    
    var users: [RandomUser] = []
    
    private let baseURL = URL(string: "https://randomuser.me/api/")!
    
    func fetchResults(using session: URLSession = URLSession.shared,
                        completion: @escaping ([RandomUser]?, Error?) -> Void) {
        
        let url = self.url(forAmountOfResults: 1000)
        fetch(from: url, using: session) { (dictionary: [String : UsersList]?, error: Error?) in
            guard let userList: UsersList = dictionary?["photo_manifest"] else {
                completion(nil, error)
                return
            }
            completion(userList.results, nil)
            self.users.append(contentsOf: userList.results)
        }
    }
    
    private func fetch<T: Codable>(from url: URL,
                           using session: URLSession = URLSession.shared,
                           completion: @escaping (T?, Error?) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "com.LambdaSchool.Random-Users.ErrorDomain", code: -1, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(T.self, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    private func url(forAmountOfResults resultsCount: Int) -> URL {
        let urlComponents = NSURLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [URLQueryItem(name: "results", value: "\(resultsCount)")]
        return urlComponents.url!
    }
    
}
