import Foundation

struct User: Decodable {
    
    enum Keys: String, CodingKey {
        case results
        case large
        case thumbnail
        
        enum NameKeys: String, CodingKey {
            case name
            
            enum FullNameKeys: String, CodingKey {
                case first
                case last
            }
        }
        enum LocationKeys: String, CodingKey {
            case location
            
            enum EmailKeys: String, CodingKey {
                case email
            }
        }
        enum RegisteredKeys: String, CodingKey {
            case registered
            
            enum PhoneKeys: String, CodingKey {
                case phone
            }
        }
        
    }
    
    let results: [String]
    let email: String
    let phone: String
    let large: URL
    let thumbnail: URL
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        // Names
        var resultsContainer = try container.nestedUnkeyedContainer(forKey: .results)
        var fullNames: [String] = []
        
        while resultsContainer.isAtEnd == false {
            let namesContainer = try resultsContainer.nestedContainer(keyedBy: Keys.NameKeys.self)
            
            let fullNameContainer = try namesContainer.nestedContainer(keyedBy: Keys.NameKeys.FullNameKeys.self, forKey: .name)
            let firstName = try fullNameContainer.decode(String.self, forKey: .first)
            let lastName = try fullNameContainer.decode(String.self, forKey: .last)
            
            fullNames.append(firstName)
            fullNames.append(lastName)
        }
        results = fullNames
        
        // Email
        let locationContainer = try container.nestedContainer(keyedBy: Keys.LocationKeys.self, forKey: .results)
        let emailContainer = try locationContainer.nestedContainer(keyedBy: Keys.LocationKeys.EmailKeys.self, forKey: .location)
        email = try emailContainer.decode(String.self, forKey: .email)
        
        // Phone
        let registeredContainer = try container.nestedContainer(keyedBy: Keys.RegisteredKeys.self, forKey: .results)
        let phoneContainer = try registeredContainer.nestedContainer(keyedBy: Keys.RegisteredKeys.PhoneKeys.self, forKey: .registered)
        phone = try phoneContainer.decode(String.self, forKey: .phone)
        
        // Photos
        large = try container.decode(URL.self, forKey: .large)
        thumbnail = try container.decode(URL.self, forKey: .thumbnail)
    }
}
