import Foundation

class Cache<Key, Value> where Key: Hashable {
    
    private var cache: [Key: Value] = [:]
    private let q = DispatchQueue(label: "Cache<\(Key.self), \(Value.self)>")
    
    func cache(value: Value, forKey: Key) {
        
        q.async {
            self.cache[forKey] = value
        }
    }
    
    func value(forKey: Key) -> Value? {
        return q.sync {
            self.cache[forKey]
        }
    }
}
