//
//  UserClient.swift
//  Random Users
//
//  Created by Sammy Alvarado on 9/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

final class UserClient {

    enum HTTPMethod: String {
        case get = "GET"
    }

    enum NetworkError: Error {
        case tryAgain
        case noData
        case noURL
    }

    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    var usersResults: Results?

    func fetchUserDetails(completion: @escaping (Result<Results, NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL)
        request.httpMethod = HTTPMethod.get.rawValue

        let task = URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                print("Error occurred fetching Users Detail data: \(error)")
                completion(.failure(.tryAgain))
                return
            }

            guard let data = data else {
                print("No data was recieved to for the User detail views")
                completion(.failure(.noData))
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                let user = try jsonDecoder.decode(Results.self, from: data)
                print("Was successful in retreiving User: \(user)")
                completion(.success(user))
            } catch {
                print("An error occurred when decoiding User Detail data: \(error)")
                completion(.failure(.tryAgain))
            }
        }
        task.resume()
    }

    func fetchUserImage(at urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let image = URL(string: urlString)!
        var request = URLRequest(url: image)
        request.httpMethod = HTTPMethod.get.rawValue

        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error failed retreiving user image: \(urlString), error: \(error)")
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            let image = UIImage(data: data)!
            completion(.success(image))
        }
        task.resume()
    }

}
