//
//  URL+Extension.swift
//  Random Users
//
//  Created by Alex Shillingford on 2/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

extension URL {
    var usingHTTPS: URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        components.scheme = "https"
        return components.url
    }
}
