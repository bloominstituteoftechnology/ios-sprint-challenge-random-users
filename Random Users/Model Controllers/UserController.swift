//
//  UserController.swift
//  Random Users
//
//  Created by Conner on 9/7/18.
//  Copyright © 2018 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class UserController {
    func getUsers(completion: @escaping (Error?) -> Void) {
        let url = UserController.baseURL
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error GETting randomUser data: \(error) - \(url)")
                completion(error)
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let randomUserJSON = try decoder.decode(Results.self, from: data)
        
                self.users = randomUserJSON.results.compactMap { $0 }
            } catch let error {
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func loadUserImageForCell(user: User, cell: UITableViewCell) {
        let url = URL(string: user.picture.thumbnail)!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error GETting randomUser photo: \(error) - \(url)")
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: data)
            }
        }.resume()
    }
    
    
    func loadUserImageForDetail(user: User, imageView: UIImageView) {
        let url = URL(string: user.picture.large)!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error GETting randomUser photo: \(error) - \(url)")
                return
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }.resume()
    }

    var users: [User] = []
    static var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
}
