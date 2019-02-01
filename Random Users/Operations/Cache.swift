
import Foundation

class Cache<Key: Hashable, Value> {
    
    private var cacheDictionary = Dictionary<Key, Value>()
    
    // initialize property with a serial DispatchQueue
    private let q = DispatchQueue(label: "Cache<\(Key.self),\(Value.self)>", attributes: [.concurrent])
    
    init() {}
    
    // Get value for specific key
    func getValue(for key: Key) -> Value? {
        var value: Value?
        q.sync {
            value = cacheDictionary[key]
        }
        return value
    }
    
    // Add items to the cache
    func saveValue(_ value: Value?, for key: Key) {
        
        let work = DispatchWorkItem(flags: [.barrier], block: {
             self.cacheDictionary[key] = value
        })
        q.async(execute: work)
       
    }
    
    // Remove items from cache
    func removeValue(for key: Key) {
        saveValue(nil, for: key)
    }
    
}
