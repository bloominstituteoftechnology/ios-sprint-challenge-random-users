import Foundation

struct RandomPersonResults: Decodable {
    let results: [RandomPerson]
}

struct RandomPerson: Decodable {
    
    var fullName: String = ""
    var first: String = ""
    var last: String = ""
    var email: String = ""
    var phone: String = ""
    var thumbnail: String = ""
    var large: String = ""

    
    enum RandomPersonKeys: String, CodingKey {
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


init(from decoder: Decoder) throws {
    
    let container = try decoder.container(keyedBy: RandomPersonKeys.self)
    
    let randomPersonNameContainer = try container.nestedContainer(keyedBy: RandomPersonKeys.NameKeys.self, forKey: .name)
    first = try randomPersonNameContainer.decode(String.self, forKey: .first)
    last = try randomPersonNameContainer.decode(String.self, forKey: .last)
    
    var nameArray: [String] = []
    nameArray.append(contentsOf: [first, last])
    fullName = (nameArray.joined(separator: " ").capitalized)
    nameArray = []
    
    email = try container.decode(String.self, forKey: .email)
    phone = try container.decode(String.self, forKey: .phone)
    
    let randomPersonPhotoContainer = try container.nestedContainer(keyedBy: RandomPersonKeys.PictureKeys.self, forKey: .picture)
    
    large = try randomPersonPhotoContainer.decode(String.self, forKey: .large)
    thumbnail = try randomPersonPhotoContainer.decode(String.self, forKey: .thumbnail)
    
    }

}
