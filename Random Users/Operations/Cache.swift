import Foundation

class Cache<Key: Hashable, Value> {
    
    //MARK: - Properties
    private var cachedDictionary: [Key: Value] = [:]
    
    
    func getValue(for key: Key) -> Value? {
        var value: Value?
        return value
    }
    
    func saveValue(value: Value, for key: Key) {
        cachedDictionary[key] = value
    }
}
