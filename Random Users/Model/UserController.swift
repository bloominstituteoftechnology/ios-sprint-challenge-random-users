
import Foundation

class UserController {
    
    static let shared = UserController()
    private init () {}
    
    // Data source for application
    var users: [User] = []
    var userResults: [UserResults] = []
    
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    typealias CompletionHandler = (Error?) -> Void
    
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
                let users = try JSONDecoder().decode(UserResults.self, from: data)
                self.users = users.results
//                self.users.append(users.results)
                print(users)
//                self.userResults.append(users)
//                print(self.userResults)
                completion(nil)
                return
            } catch {
                NSLog("Unable to decode data: \(error)")
                completion(error)
                return
            }
        }.resume()
        
        
    }

    
}
