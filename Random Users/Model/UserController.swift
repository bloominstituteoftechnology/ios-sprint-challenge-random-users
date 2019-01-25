import Foundation

class UserController {
    private(set) var users: [User] = []

    let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!

    func fetchUsers(completion: @escaping ([User], Error?) -> Void ) {
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            var users = [User]()
            
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(users, NSError())
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching data. No data returned")
                completion(users, NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let userResults = try jsonDecoder.decode([String: User].self, from: data).map() { $0.value }
                users = userResults
                completion(users, nil)
                
            } catch {
                NSLog("Unable to decode data into search query \(error)")
                completion(users, NSError())
                return
            }
        }
        dataTask.resume()
    }
}
