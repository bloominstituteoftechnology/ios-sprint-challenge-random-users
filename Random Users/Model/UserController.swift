import Foundation

class UserController {
    
    private(set) var users: [User] = []

    typealias CompletionHandler = (Error?) -> Void
    
    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    init() { fetchUsers() }
    
    func fetchUsers(completion: @escaping CompletionHandler = { _ in }) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(NSError())
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching data. No data returned")
                completion(NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let userResults = try jsonDecoder.decode(UserResults.self, from: data)
                self.users = userResults.results
                completion(nil)
                
            } catch {
                NSLog("Unable to decode data into search query \(error)")
                completion(NSError())
                return
            }
        }
        dataTask.resume()
    }
}
