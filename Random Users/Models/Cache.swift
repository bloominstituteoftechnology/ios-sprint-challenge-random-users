import Foundation

class Cache<Key, Value> where Key: Hashable {

    func cache(forKey key: Key , forValue value: Value ) {
        queue.sync() {
            cacheDictionary[key] = value
        }
    }
    func value(for key: Key ) -> Value? {
        var lookUpValue: Value?
        queue.sync() {
            if let value = cacheDictionary[key] {
                lookUpValue = value
            }
        }
        return lookUpValue
    }
    func contains(key: Key) -> Bool {
        let filteredArray = cacheDictionary.map{ $0.key }
        for item in filteredArray {
            if item == key {
            return true
        }
    }
        return false
    }
    
    //MARK: Properties
    
    private let queue = DispatchQueue(label: "cacheQueue")
    private var cacheDictionary: [Key: Value] = [:]
    
}
