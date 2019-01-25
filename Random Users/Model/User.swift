import Foundation

struct User: Decodable {
    
    enum Keys: String, CodingKey {
        case name
        case email
        case phone
        case large
        case thumbnail
        
        enum NameKeys: String, CodingKey {
            case first
            case last
        }
    
        enum PictureKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    let first: String
    let last: String
    let email: String
    let phone: String
    let large: URL?
    let thumbnail: URL?
    var name: String {
        return "\(first) \(last)"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        // Names
        let nameContainer = try container.nestedContainer(keyedBy: Keys.NameKeys.self, forKey: .name)
        first = try nameContainer.decode(String.self, forKey: .first)
        last = try nameContainer.decode(String.self, forKey: .last)
        
        // Email
        email = try container.decode(String.self, forKey: .email)
        
        // Phone
        phone = try container.decode(String.self, forKey: .phone)
        
        // Photos
        large = try container.decode(URL.self, forKey: .large)
        thumbnail = try container.decode(URL.self, forKey: .thumbnail)
    }
}
