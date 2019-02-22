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
    }
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
            
        }
    
        enum PictureKeys: String, CodingKey {
            case large
    }

}
