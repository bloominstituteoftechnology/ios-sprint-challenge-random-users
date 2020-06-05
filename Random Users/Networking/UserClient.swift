//
//  UserClient.swift
//  Random Users
//
//  Created by Marissa Gonzales on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class UserClient {
    private let url = URL(string:  "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    func fetchUsers(completion: @escaping (Result<[Users], NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.clientError(error)))
                return
            }

            if let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode) {
                completion(.failure(.invalidResponseCode(response.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let wrapper = try JSONDecoder().decode(UserWrapper.self, from: data)
                let users = wrapper.results
                completion(.success(users))
            } catch {
                completion(.failure(.failedDecode(error)))
            }
        }.resume()
    }
}
