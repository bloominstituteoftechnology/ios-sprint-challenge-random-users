//Frulwinn

import Foundation

class UserController {
    
    //MARK: - Properties
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    static let shared = UserController()
    var users: [User] = []
    typealias CompletionHandler = (Error?) -> Void
    
    
    //get user method
    func getUsers(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching users: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from the data task")
                completion(NSError())
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
