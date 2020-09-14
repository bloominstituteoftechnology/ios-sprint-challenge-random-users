//
//  Cache.swift
//  Random Users
//
//  Created by Shawn Gee on 4/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

typealias Bytes = Int

class Cache<Key: Hashable, Value> {
    
    // MARK: - Public

    func cache(_ value: Value, ofSize bytes: Bytes, for key: Key) {
        queue.async {
            guard self.store[key] == nil else { return }
            self.store[key] = (value, bytes)
            self.chronologicalKeys.append(key)
            
            self.storeSize += bytes
            if self.storeSize > self.limit {
                self.evictOldEntries()
            }
        } 
    }
    
    func value(for key: Key) -> Value? {
        queue.sync { store[key]?.value }
    }
    
    // MARK: - Init
    
    init(size: Bytes) {
        self.limit = size
    }
    
    // MARK: - Private
    
    private var store: [Key: (value: Value, size: Bytes)] = [:]
    private var chronologicalKeys: [Key] = []
    private let queue = DispatchQueue(label: "Cache Queue")
    private var storeSize: Bytes = 0
    private var limit: Bytes = 0
    
    private func evictOldEntries() {
        while storeSize > limit / 2 {
            guard !chronologicalKeys.isEmpty else { break }
            let key = chronologicalKeys.removeFirst()
            guard let value = store.removeValue(forKey: key) else { continue }
            storeSize -= value.size
        }
    }
}
