import Foundation

// Decoding Names from JSON
struct Name: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case first
        case last
    }
    
    let title: String
    let first: String
    let last: String
    
    var fullName: String {
        return ("\(title) \(first) \(last)")//.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}

// Decoding Pictures from JSON
struct Picture: Codable {
    enum CodingKeys: String, CodingKey {
        case large
        case medium
        case thumbnail
    }
    
    let large: String
    let medium: String
    let thumbnail: String
}

// Preparing user from JSON
struct User: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
    }
    
    let name: Name
    
    let email: String
    let phone: String
    
    let picture: Picture
}

// Data from API
struct APIResults: Codable {
    let results: [User]
}
