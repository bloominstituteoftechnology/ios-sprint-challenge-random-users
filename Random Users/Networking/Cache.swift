import Foundation

/// Caching Queue
class Cache<Key: Hashable, Value> {
    private var dict: [Key: Value] = [:]
    private var queue = DispatchQueue(label: "Cache Queue")
    
    func cache(value: Value, for: Key) {
        queue.async {
            self.dict[`for`] = value
        }
    }
    
    func value(for: Key) -> Value? {
        queue.sync {
            return dict[`for`]
        }
    }
}
