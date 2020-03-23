//
//  RandomUserClient.swift
//  Random Users
//
//  Created by David Wright on 3/22/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class RandomUserClient {
    
    // MARK: - Public
    
    var numberOfResults = 1000
    
    // MARK: - Private Properties

    private lazy var baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=\(numberOfResults)")!
    
    // MARK: - Private Methods
    
    
}
