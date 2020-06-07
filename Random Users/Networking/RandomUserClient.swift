//
//  FetchPictureOperation.swift
//  RandomUserOperation
//
//  Created by Enzo Jimenez-Soto on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class RandomUserClient {
    
    // MARK: - Public Methods
        
    func fetchRandomUsers(numberOfUsers: Int = 1000,
                          using session: URLSession = URLSession.shared,
                          completion: @escaping ([User]?, Error?) -> Void) {
        
        let numberOfResults = (numberOfUsers > 0 && numberOfUsers <= 5000) ? numberOfUsers : 1000
        let url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=\(numberOfResults)")!
        
        fetch(from: url, using: session) { (dictionary: RandomUsersResult?, error: Error?) in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            guard let users = dictionary?.results else {
                completion(nil, NSError())
                return
            }
            completion(users, nil)
        }
    }
    
    func fetchPicture(at pictureURL: URL,
                      using session: URLSession = URLSession.shared,
                      completion: @escaping (UIImage?, Error?) -> Void) {
        
        fetch(from: pictureURL, using: session) { (imageData: Data?, error: Error?) in
            guard let imageData = imageData,
                let picture = UIImage(data: imageData) else {
                    completion(nil, error)
                    return
            }
            completion(picture, nil)
        }
    }
    
    // MARK: - Private Methods
    
    private func fetch<T: Codable>(from url: URL,
                                   using session: URLSession = URLSession.shared,
                                   completion: @escaping (T?, Error?) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "com.LambdaSchool.RandomUsers.ErrorDomain", code: -1, userInfo: nil))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
