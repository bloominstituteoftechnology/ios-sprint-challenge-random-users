//
//  APIController.swift
//  Random Users
//
//  Created by Tobi Kuyoro on 13/03/2020.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class APIController {
    
    // MARK: - Properties
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    typealias CompletionHandler = (Error?) -> Void
    
}
