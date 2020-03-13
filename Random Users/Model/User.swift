
import Foundation

struct User: Decodable {
        
    var title: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var picture: String
    
    enum UserKeys: String, CodingKey {
        
        case name
        case email
        case phone
        case picture
        
        enum Name: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum Picture: String, CodingKey {
            case large
        }
    }
    
    init(from decoder: Decoder) throws {
        
        // Get a container that represents the top level of information
        // Top level = dictionary -> keyed container
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        // Name is a dictionary -> keyed container
        let nameContainer = try container.nestedContainer(keyedBy: UserKeys.Name.self, forKey: .name)
        firstName = try nameContainer.decode(String.self, forKey: .first)
        lastName = try nameContainer.decode(String.self, forKey: .last)
        title = try nameContainer.decode(String.self, forKey: .title)
        
        // Picture is a dictionary -> keyed container
        let pictureContainer = try container.nestedContainer(keyedBy: UserKeys.Picture.self, forKey: .picture)
        picture = try pictureContainer.decode(String.self, forKey: .large)
        
        // Not nested inside anything
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
    }
}

struct UserResults: Decodable {
    
    var results: [User]
}
