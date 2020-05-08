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
    private var items: [Key: [Value]] = [:]
    private let cacheQueue = DispatchQueue(label: "com.org.app.cacheQueue")
    
    
    //MARK: - Methods
    //Add Items
    func cache(value: [Value], for key: Key) {
        cacheQueue.async {
            self.items[key]?.append(contentsOf: value)
        }
    }

    //Get Value: Returns an optional Value
    func value(for key: Key) -> [Value]? {
        return cacheQueue.sync { items[key] }
    }

}
