//
//  Cache.swift
//  Random Users
//
//  Created by Marissa Gonzales on 6/5/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

typealias Bytes = Int

class Cache<Key: Hashable, Value> {

    init(size: Bytes) {
        self.limit = size
    }

    //MARK: - Public Methods

    func cache(_ value: Value, ofSize bytes: Bytes, for key: Key) {
        queue.async {
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
    
    //MARK: - Private

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
