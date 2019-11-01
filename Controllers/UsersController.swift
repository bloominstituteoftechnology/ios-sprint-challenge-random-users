//
//  UsersController.swift
//  Random Users
//
//  Created by macbook on 11/1/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class UsersController {
    
    let baseURL = URL(string: "https://randomuser.me/api/")!
    var users: [User] = []
    
//
//    // Using this initializer as the "viewDidLoad" of the VC
//    init() {
//        fetchUsers()
//    }
    
    
    
    private func cleanURL(numberOfUsers results: Int) -> URL {
        var url = baseURL
        let resultsCountString = String(results)
        let infoLimiter = "name,email,phone,picture"
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!

        urlComponents.queryItems = [URLQueryItem(name: "results", value: resultsCountString),
                                    URLQueryItem(name: "inc", value: infoLimiter)]
        
        return urlComponents.url!
    }
    
    
    
    // Fetch Users
    func fetchUsers(session: URLSession = URLSession.shared, completion: @escaping ([User]?, Error?) -> Void) {
        
        
        
        let request = URLRequest(url: cleanURL(numberOfUsers: 1_000))
            print("\(request)")
            session.dataTask(with: request) { (data, _, error) in
                
                if let error = error {
                    NSLog("error fetching user:\(error)")
                    return
                }

                guard let data = data else {
                    NSLog("bad data")
                    return
                }

                do{
                    let results = try JSONDecoder().decode(Results.self, from: data)

                    self.users = results.results
                } catch {
                    NSLog("Unable to decode users:\(error)")
                }
                completion(self.users, nil)
            }.resume()
        }

}

enum HTTPMethod: String {
     case get = "GET"
     case put = "PUT"
     case post = "POST"
     case delete = "DELETE"
 }

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError(Error)
    case badData
    case noDecode
    case noEncode
    case badResponse
}
