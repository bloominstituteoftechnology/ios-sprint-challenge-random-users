//
//  Extensions.swift
//  Random Users
//
//  Created by Karen Rodriguez on 4/10/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

extension String {
    func getUrl() -> URL? {
        return URL(string: self)
    }
}
