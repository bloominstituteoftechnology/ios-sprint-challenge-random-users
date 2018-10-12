//
//  User.swift
//  Random Users
//
//  Created by Moin Uddin on 10/12/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation


struct Users: Decodable {
    enum CodingKeys: String, CodingKey {
        case users = "results"
    }
    
    var users: [User]
    
}

struct User: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case email
        case phone
        case picture
        case name
        
        enum NameCodingKeys: String, CodingKey {
            case first
            case last
        }
        
        enum ImageCodingKeys: String, CodingKey {
            case large
            case thumbnail
        }
        
    }
    
//    mutating func setImageData(imageURL: URL, completion: @escaping (Data?, Error?) -> Void) {
//        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
//            if let error = error {
//                NSLog("Error getting Image \(error)")
//                completion(nil, error)
//                return
//            }
//
//            guard let data =  data else {
//                NSLog("Error returning data \(error)")
//                completion(nil, nil)
//                return
//            }
//
//            do {
//                completion(data, nil)
//            } catch {
//                NSLog("Error decoding random users JSON \(error)")
//                completion(nil, error)
//                return
//            }
//
//        }.resume()
//    }
    
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let email = try container.decode(String.self, forKey: .email)
        
        let phoneNumber = try container.decode(String.self, forKey: .phone)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        
        let firstName = try nameContainer.decode(String.self, forKey: .first)
        
        let lastName = try nameContainer.decode(String.self, forKey: .last)
        
        let imageContainer = try container.nestedContainer(keyedBy: CodingKeys.ImageCodingKeys.self, forKey: .picture)
        
        let largeImageUrl = try imageContainer.decode(String.self, forKey: .large)
        
        let thumbnailImageUrl = try imageContainer.decode(String.self, forKey: .thumbnail)
        
//        setImageData(imageURL: URL(string: largeImageUrl)!) { (data, _) in
//            guard let data = data else { return }
//            self.largeImageData = data
//        }
//
//        setImageData(imageURL: URL(string: thumbnailImageUrl)!) { (data, _) in
//            self.thumbnailImageData = data
//        }
        
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.largeImageUrl = URL(string: largeImageUrl)!
        self.thumbnailImageUrl = URL(string: thumbnailImageUrl)!
        
    }
    
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var largeImageUrl: URL
    var thumbnailImageUrl: URL
//    var largeImageData: Data
//    var thumbnailImageData: Data
    
}
