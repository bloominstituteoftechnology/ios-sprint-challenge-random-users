//Frulwinn

import Foundation

class Cache<Key: Hashable, Value> {
    
    //MARK: - Properties
    private var cacheDictionary = Dictionary<Key, Value>()
    private let q = DispatchQueue(label: "com.Frulwinn.RandomUsers", attributes: [.concurrent])
    
    init() {}
    
    //get value for specific key
    func getValue(for key: Key) -> Value? {
        var value: Value?
        
        q.sync {
            value = cacheDictionary[key]
        }
        return value
    }
    
    //add items to the cache
    func saveValue(_ value: Value?, for key: Key) {
        q.async {
            self.cacheDictionary[key] = value
        }
    }
    
    //remove items from cache
    func removeValue(for key: Key) {
        saveValue(nil, for: key)
    }
}
