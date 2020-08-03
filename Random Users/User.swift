import Foundation


// MARK: - User

struct User: Codable {
  let results: [Result]
  let info: Info
}
// MARK: - Info
struct Info: Codable {
  let seed: String
  let results, page: Int
  let version: String
}
// MARK: - Result
struct Result: Codable {
  let name: Name
  let email: String
  let phone: String
  var picture: Picture
}
// MARK: - Name
struct Name: Codable {
  var title, first, last: String
}
// MARK: - Picture
struct Picture: Codable {
  let large, medium, thumbnail: String
  var imageData: Data?
}
