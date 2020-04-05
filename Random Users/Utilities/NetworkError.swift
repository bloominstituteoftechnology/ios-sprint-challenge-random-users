//
//  NetworkError.swift
//  Random Users
//
//  Created by Jessie Ann Griffin on 4/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case noData
    case decodeError
    case noImage
}
