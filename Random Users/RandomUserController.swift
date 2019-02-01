import Foundation

class RandomUserController {
    
    static let shared = RandomUserController()
    
    let requestURL = URL(string: "https://randomuser.me/api/?format=pretty&results=100")!.usingHTTPS!
    var randomUserResults: [RandomUser?] = []
    
    func fetchRandomUsers(with url: URL, completion: @escaping (Error?) -> Void) {
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(error)
                return
            }
            
            print("we have data: \(Data(data))")

            
            do {
                let results = try JSONDecoder().decode(RandomUser.self, from: data)

                self.randomUserResults = [results]
                print(String(describing: self.randomUserResults))
                completion(nil)
                
            } catch {
                print("Error decoding JSON data: \(error)")
                completion(error)
            }
        }.resume()
    }
}
