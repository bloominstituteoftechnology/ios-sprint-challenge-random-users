import Foundation

struct UserResults: Codable {
    let results: [User]
}

struct User: Codable {
    
    let title: String
    let first: String
    let last: String
    let email: String
    let phone: String
    let large: URL?
    let thumbnail: URL?
    
    enum UserKeys: String, CodingKey {
        case name
        case phone
        case email
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum PictureKeys: String, CodingKey {
            case large
            case thumbnail
        }
    }
    
    var name: String {
        
        return "\(title.capitalize()) \(first.capitalize()) \(last.capitalize())"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        title = try nameContainer.decode(String.self, forKey: .title)
        first = try nameContainer.decode(String.self, forKey: .first)
        last = try nameContainer.decode(String.self, forKey: .last)
        
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        
        let pictureContainer = try container.nestedContainer(keyedBy: UserKeys.PictureKeys.self, forKey: .picture)
        large = try pictureContainer.decode(URL.self, forKey: .large)
        thumbnail = try pictureContainer.decode(URL.self, forKey: .thumbnail)
    }
    
}

extension String {
    func capitalize() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalize() {
        self = self.capitalize()
    }
}
