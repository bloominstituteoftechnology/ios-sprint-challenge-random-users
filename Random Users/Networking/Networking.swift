//
//  Networking.swift
//  Random Users
//
//  Created by Breena Greek on 5/15/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case otherError
    case noAuth
    case noDecode
    case noData
}

class Networking {
    
    var users: [User] = []
    
    let baseURL = URL(string: "https://randomuser.me/api/")!
    
    func fetchUsers(named name: String, completion: @escaping (Result<User, NetworkError>) -> Void) {
        let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        guard let requestURL = components?.url else {
            NSLog("Request URL is nil")
            completion(.failure(.otherError))
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching data \(error)")
                completion(.failure(.noData))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let user = try self.jsonDecoder.decode([User].self, from: data)
                self.users = user
                completion(.success(user))
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(.failure(.noDecode))
            }
        } .resume()
    }
}

//    func fetchUsers(named name: String,
//                        using session: URLSession = URLSession.shared,
//                        completion: @escaping (User?, Error?) -> Void) {
//
//        let url = self.url(user: name)
//        fetch(from: url, using: session) { (dictionary: [String : User]?, error: Error?) in
//            guard let rover = dictionary?["photo_manifest"] else {
//                completion(nil, error)
//                return
//            }
//            completion(rover, nil)
//        }
//    }
//
//    private func fetch<T: Codable>(from url: URL,
//                              using session: URLSession = URLSession.shared,
//                              completion: @escaping (T?, Error?) -> Void) {
//           session.dataTask(with: url) { (data, response, error) in
//               if let error = error {
//                   completion(nil, error)
//                   return
//               }
//
//               guard let data = data else {
//                   completion(nil, NSError(domain: "com.LambdaSchool.Astronomy.ErrorDomain", code: -1, userInfo: nil))
//                   return
//               }
//
//               do {
//                   let jsonDecoder = User.jsonDecoder
//                   let decodedObject = try jsonDecoder.decode(T.self, from: data)
//                   completion(decodedObject, nil)
//               } catch {
//                   completion(nil, error)
//               }
//           }.resume()
//       }
//
//    private func url(user: String) -> URL {
//        var url = baseURL
//        url.appendPathComponent(user)
//        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
//        return urlComponents.url!
//    func fetchUsers(completion: @escaping(Result<[User], NetworkError>) -> Void) {
//
//        let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
//             guard let requestURL = components?.url else {
//                 NSLog("Request URL is nil")
//                 completion(.failure(.otherError))
//                 return
//             }
//             var request = URLRequest(url: requestURL)
//             request.httpMethod = HTTPMethod.get.rawValue
//             URLSession.shared.dataTask(with: request) { (data, _, error) in
//                 if let error = error {
//                     print("Error fetching data \(error)")
//                     completion(.failure(.noData))
//                     return
//                 }
//                 guard let data = data else {
//                     completion(.failure(.noData))
//                     return
//                 }
//                 do {
//                     let user = try self.jsonDecoder.decode([User].self, from: data)
//                     self.users = user
//                     completion(.success(user))
//                 } catch {
//                     NSLog("Error decoding data: \(error)")
//                     completion(.failure(.noDecode))
//                 }
//             } .resume()
//         }
//}


