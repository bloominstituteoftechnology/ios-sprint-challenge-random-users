//Frulwinn

import Foundation

private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

class UserController {
    
    //MARK: - Properties
    static let shared = UserController()
    var users: [User] = []
    
    //get user method
    func getUsers(completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from the data task")
                completion(error)
                return
            }
            
            do {
                let userNew = try JSONDecoder().decode(UserResults.self, from: data)
                self.users = userNew.results
                completion(nil)
            } catch {
                NSLog("Unable to decode data: \(error)")
                completion(error)
            }
        }.resume()
    }
}
