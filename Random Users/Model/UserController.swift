
import Foundation

class UserController {
    
    static let shared = UserController()

    // Data source for application
    var users: [User] = []
    
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
                let userNew = try JSONDecoder().decode(UserResults.self, from: data)
                self.users = userNew.results
                print(self.users)
                completion(nil)
                
            } catch {
                NSLog("Unable to decode data: \(error)")
                completion(error)
            }
        }.resume()
        
        
    }
    

    
}
