import Foundation

class RandomUserController {
    
    static let shared = RandomUserController()
    
    let requestURL = URL(string: "https://randomuser.me/api/?results=1")!.usingHTTPS!
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
            
            //    let results = try? JSONDecoder().decode(RandomUser.self, from: data)
            //    print("decoding: \(results)")
            //    randomUserResults = [results]
            //    print(randomUserResults)
            
            do {
                let results1 = try JSONDecoder().decode(RandomUser.self, from: data)
                print("decoding: \(String(describing: results1))")
                self.randomUserResults = [results1]
                print(self.randomUserResults)
                completion(nil)
                
            } catch {
                print("Error decoding JSON data: \(error)")
                completion(error)
            }
        }.resume()
    }
}
