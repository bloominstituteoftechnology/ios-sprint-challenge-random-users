//
//  URL+Secure.swift
//  Random Users
//
//  Created by brian vilchez on 12/6/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

extension URL {
    var usingHTTPS: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.scheme = "https"
        return components.url
    }
}
