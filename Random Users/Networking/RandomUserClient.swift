//
//  RandomUserClient.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserClient {
    private let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (result: Result<UsersWrapper, NetworkError>) in
            completion(result.map({ (wrapper) -> [User] in
                wrapper.results
            }))
        }.resume()
    }
}





