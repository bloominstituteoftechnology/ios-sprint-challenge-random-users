import Foundation

struct RandomUser: Codable {
    
    let results: [Result]
    let info: Info
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case info = "info"
    }
}

struct Info: Codable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
    
    enum CodingKeys: String, CodingKey {
        case seed = "seed"
        case results = "results"
        case page = "page"
        case version = "version"
    }
}

struct Result: Codable {
    let name: Name
    let email: String
    let phone: String
    let id: ID
    let picture: Picture
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case phone = "phone"
        case id = "id"
        case picture = "picture"
        
    }
}

struct ID: Codable {
    let name: String?
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case value = "value"
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case first = "first"
        case last = "last"
    }
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case large = "large"
        case medium = "medium"
        case thumbnail = "thumbnail"
    }
}
