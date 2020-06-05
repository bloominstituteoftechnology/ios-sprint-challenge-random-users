//
//  HelperEnums.swift
//  Random Users
//
//  Created by Marissa Gonzales on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case noData
    case failedEncode(Error)
    case failedDecode(Error)
    case invalidResponseCode(Int)
    case invalidData
    case clientError(Error)
}
