//
//  PersonController.swift
//  Random Users
//
//  Created by Jerry haaser on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class PersonController {
    
    let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetch(using session: URLSession = URLSession.shared, completion: @escaping (People?, Error?) -> Void) {
        
        fetch(from: self.url) { (array: People?, error: Error?) in
            guard let people = array else {
                completion(nil, error)
                return
            }
            completion(people, nil)
        }
    }
    
    private func fetch<T: Codable>(from url: URL, using session: URLSession = URLSession.shared, completion: @escaping (T?, Error?) -> Void) {
        
        session.dataTask(with: url) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print(response.statusCode)
                completion(nil, error)
                return
            }
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "com.labmbdaSchool.RandomUser.ErrorDomain", code: -1, userInfo: nil))
                return
            }
            
            do {
                let jsonDecoder = Person.jsonDecoder
                let decodedObject = try jsonDecoder.decode(T.self, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
}
