//
//  Cache.swift
//  Random Users
//
//  Created by Cameron Collins on 5/8/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

class Cache <Key: Hashable, Value> {

    //MARK: - Properties
    private var items: [Key: Value] = [:]

    //MARK: - Methods
    
    //Add Items
    func cache(value: Value, for key: Key) {
        items[key] = value
    }

    //Get Value: Returns an optional Value
    func value(for key: Key) -> Value? {
        return items[key]
    }

}
