import Foundation

class UserController {
    
    private(set) var users: [User] = []
    
    typealias CompletionHandler = (Error?) -> Void
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                NSLog("Error fetching users from data task \(error)")
                completion(NSError())
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching user data. No User data returned")
                completion(NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let returnedUserData = try jsonDecoder.decode(UserResults.self, from: data)
                self.users = returnedUserData.results
                completion(nil)
                
            } catch {
                NSLog("Unable to decode data into Users")
                completion(NSError())
                return
            }
        }
        dataTask.resume()
    }
    
}
