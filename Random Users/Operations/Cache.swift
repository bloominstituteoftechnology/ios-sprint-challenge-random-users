
import Foundation

class Cache<Key: Hashable, Value> {
    
    private var cacheDictionary = Dictionary<Key, Value>()
    
    // initialize property with a serial DispatchQueue
    private let q = DispatchQueue(label: "Cache<\(Key.self),\(Value.self)>", attributes: [.concurrent])
    
    init() {}
    
    // Get value for specific key
    func getValue(for key: Key) -> Value? {
        var value: Value?
        
        // Synchronous b/c need to return a value immediately - so everything else needs to wait for this to finish
        q.sync {
            value = cacheDictionary[key]
        }
        return value
    }
    
    // Add items to the cache
    func saveValue(_ value: Value?, for key: Key) {
        
        // Asynchronous b/c doesn't matter if this happens right away
        q.async {
            self.cacheDictionary[key] = value
        }
    }
    
    // Remove items from cache
    func removeValue(for key: Key) {
        // removing a value is the same as saving nil for the key
        saveValue(nil, for: key)
    }
    
}
