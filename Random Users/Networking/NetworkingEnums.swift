//
//  NetworkingEnums.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case clientError(Error)
    case invalidResponseCode(Int)
    case noData
    case decodingError(Error)
    case encodingError(Error)
    case invalidData
}
