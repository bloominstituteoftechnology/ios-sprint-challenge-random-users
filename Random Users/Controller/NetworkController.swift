//
//  NetworkController.swift
//  Random Users
//
//  Created by Cameron Collins on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

/* Call this URL: https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000
    Get and Store 1000 Users
 */
class NetworkController {
    
    //MARK: - Properties
    var users: Results?
    var images: [IndexPath: UIImage] = [:]
    var url = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")
    
    
    //MARK: - Functions
    
    //Requests 100 Users
    func getUsers(completion: @escaping () -> Void) {
        
        guard let url = url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            //Error Checking
            if let error = error {
                print("Error Getting Users in \(#function): \(error)")
                completion()
                return
            }
            
            guard let tempData = data else {
                print("Bad data in \(#function)")
                completion()
                return
            }
            
            //Decode Data
            do {
                self.users = try JSONDecoder().decode(Results.self, from: tempData)
                completion()
            } catch {
                print("Error Decoding JSON in \(#function)")
            }
            
            print("Finished")
            
        }.resume()
    }
    
    func fetchImage(imageURL: URL?, indexPath: IndexPath, cache: Cache<IndexPath, Data>, completion: @escaping () -> Void) {
            guard let tempImageURL = imageURL else {
                return
            }

        
        URLSession.shared.dataTask(with: tempImageURL) { (data, response, error) in
            
            //Error Checking
            if let error = error {
                print("Error Getting Users in \(#function): \(error)")
                completion()
                return
            }
            
            guard let tempData = data else {
                print("Bad data in \(#function)")
                completion()
                return
            }
            
            //Store Image in Cache
            cache.cache(value: tempData, for: indexPath)
            completion()
            //self.images[indexPath] = UIImage(data: tempData)
            
            print("Got image!")
                
        }.resume()
    }
    
    func fetchImageLarge(imageURL: URL?, completion: @escaping (Data?) -> Void) {
        guard let tempImageURL = imageURL else {
            return
        }
        
        URLSession.shared.dataTask(with: tempImageURL) { (data, response, error) in
            
            //Error Checking
            if let error = error {
                print("Error Getting Users in \(#function): \(error)")
                completion(nil)
                return
            }
            
            guard let tempData = data else {
                print("Bad data in \(#function)")
                completion(nil)
                return
            }
            
            //Store Image in Cache
            completion(tempData)
            //self.images[indexPath] = UIImage(data: tempData)
            
            print("Got image!")
            
        }.resume()
    }
}
