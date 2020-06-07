//
//  JsonParsing.swift
//  Random Users
//
//  Created by Kelson Hartle on 6/7/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

typealias JSONDict = [String: Any]

extension Dictionary where Key == String {
    func string(_ key: String) -> String? {
        if let value = self[key] as? String {
            return value
        } else {
            print("Missing parameter '\(key)'")
            return nil
        }
    }

    func array(_ key: String) -> [JSONDict] {
        if let value = self[key] as? [JSONDict] {
            return value
        } else {
            print("Missing parameter '\(key)'")
            return []
        }
    }

    func dict(_ key: String) -> JSONDict? {
        if let value = self[key] as? JSONDict{
            return value
        } else {
            print("Missing parameter '\(key)'")
            return nil
        }
    }
}
