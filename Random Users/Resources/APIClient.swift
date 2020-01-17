
//
//  APIClient.swift
//  Random Users
//
//  Created by Thomas Sabino-Benowitz on 12/8/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class userClient{
    
}
    
//        enum HTTPMethod: String {
//            case get = "GET"
//            case post = "POST"
//        }
//
//        enum NetworkError: Error {
//            case otherError
//            case badData
//            case noDecode
//        }
//
//        private let baseUrl = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
//
//        var users: [results] = []
//        var user: results?
//
////
//        func Search(completion: @escaping () -> ()) {
//
//
//            var request = URLRequest(url: baseUrl)
//            request.httpMethod = HTTPMethod.get.rawValue
//
//            URLSession.shared.dataTask(with: request) { (data, results, error) in
//                if let error = error {
//                    print("ERROR receiving data for this pokemon \(error)")
//                    completion()
//                }
//
//                guard let data = data else {
//                    completion()
//                    return
//                }
//                let decoder = JSONDecoder()
//                do{
//                    let pokemonData = try decoder.decode(user.self, from: data)
//                    self.user = Data
//                    completion()
//                } catch {
//                    print("ERROR decoding the pokemon \(error)")
//                    completion()
//                    return
//                }
//            }.resume()
//        }
//    }
//

