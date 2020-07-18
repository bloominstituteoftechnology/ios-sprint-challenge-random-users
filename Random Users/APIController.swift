//
//  APIController.swift
//  Random Users
//
//  Created by Bohdan Tkachenko on 7/18/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

final class APICOntroller {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData
    }
    
    private let baseURL = URL(string: "https://randomuser.me/api")!
    private lazy var multipleUsers = baseURL.appendingPathComponent("?results=5000")
    private lazy var photos = baseURL.appendingPathComponent("/portraits/")
    
}

