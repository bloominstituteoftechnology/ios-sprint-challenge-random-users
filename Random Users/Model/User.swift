import Foundation

struct UserResults: Decodable {
    let results: [User]
}

struct User: Decodable {
    
    enum Keys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
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
        let first = try nameContainer.decode(String.self, forKey: .first)
        let last = try nameContainer.decode(String.self, forKey: .last)
        
        // Email
        let email = try container.decode(String.self, forKey: .email)
        
        // Phone
        let phone = try container.decode(String.self, forKey: .phone)
        
        // Photos
        let pictureContainer = try container.nestedContainer(keyedBy: Keys.PictureKeys.self, forKey: .picture)
        let large = try pictureContainer.decode(URL?.self, forKey: .large)
        let thumbnail = try pictureContainer.decode(URL?.self, forKey: .thumbnail)
        
        self.first = first
        self.last = last
        self.email = email
        self.phone = phone
        self.large = large
        self.thumbnail = thumbnail
    }
}
