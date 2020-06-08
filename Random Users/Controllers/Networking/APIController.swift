//
//  APIController.swift
//  Random Users
//
//  Created by Cody Morley on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class APIController {
    //MARK: - Types -
    enum HTTPMethods: String {
        case get = "GET"
    }
    
    enum NetworkError: Error {
        case noData
        case noDecode
        case otherError
    }
    
    typealias UsersCompletionHandler = (Result<[User], NetworkError>) -> Void
    typealias ImageCompletionHandler = (Result<UIImage, NetworkError>) -> Void
    
    
    //MARK: - Properties -
    private let fetchURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    private lazy var decoder = JSONDecoder()
    
    
    //MARK: - Actions -
    func getUsers(completion: @escaping UsersCompletionHandler) {
        var request = URLRequest(url: fetchURL)
        request.httpMethod = HTTPMethods.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Something has gone horribly wrong with the getUsers function! Here's some more info: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let userData = data else {
                NSLog("No data returned from random users API.")
                completion(.failure(.noData))
                return
            }
            
            do {
                var fetchedUsers: [User]
                let results = try self.decoder.decode(UserBlock.self, from: userData)
                fetchedUsers = results.results
                completion(.success(fetchedUsers))
            } catch {
                NSLog("Something has gone horribly wrong while trying to decode the user data from the initial fetch! Here's some more info: \(error) \(error.localizedDescription)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func getDetail(url: URL, completion: @escaping ImageCompletionHandler) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                NSLog("Something has gone terribly wrong when trying to fetch the image at \(url). Here's some more info: \(error) \(error.localizedDescription)")
                completion(.failure(.otherError))
                return
            }
            
            guard let imageData = data else {
                NSLog("No data was returned from \(url) when fetching the detail view.")
                completion(.failure(.noData))
                return
            }
            let detailImage = UIImage(data: imageData)!
            completion(.success(detailImage))
        }.resume()
    }
}


