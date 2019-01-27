//
//  Model.swift
//  Random Users
//
//  Created by Austin Cole on 1/25/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import UIKit

class Model {
    
    let randomUserController = RandomUserController()
    
    func getImage(_ urlString: String) -> UIImage {
        guard !urlString.isEmpty else {return UIImage(named: "Lambda_Logo_Full")!}
        var data: Data?
        let url = URL(string: urlString)
        
        do {
            data = try Data(contentsOf: url!)
        } catch {
            print("failed to get data from url for image at Model.getImage")
        }
        return UIImage(data: data!)!
    }
    func getName(_ randomUser: RandomUser) -> String {
        return "\(randomUser.name.title). \(randomUser.name.first) \(randomUser.name.last)".capitalized
    }
    
    
    
    
    //MARK: Singleton
    static let shared = Model()
    private init(){}
    
    //MARK: Properties
    
    var randomUsers: RandomUsers?
    var randomUsersCount: Int {
        return (randomUsers?.results.count) ?? 1000
    }
    
}
