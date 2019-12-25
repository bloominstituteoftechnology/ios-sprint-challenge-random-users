import Foundation

class UserController {
    
    static let shared = UserController()
    
    var users: [User] = []
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func getUsers(completion: @escaping (Error?) -> Void = { _ in }) {
        
        let request = baseURL
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
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
