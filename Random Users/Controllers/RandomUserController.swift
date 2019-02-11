import Foundation

class RandomUserController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    private(set) var randomUserResults: [RandomPerson] = []
    var thumbURL: String = ""
    
    ///"https://randomuser.me/api/?format=pretty&results=100"
    ///"https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=100"
    let requestURL = URL(string: "https://randomuser.me/api/?format=pretty&inc=name,email,phone,picture&results=100")!.usingHTTPS!
    
    
    func fetchRandomUsers(completion: @escaping CompletionHandler = { _ in }) {
        // create the GET request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, _, error in
            
            //Unwrap data
            guard error == nil, let data = data else {
                if let error = error {
                    NSLog("Could not unwrap data: \(error)")
                    completion(error)
                    return
                }
                return
            }
            print("We Have Data! \(data.hashValue)")
            //Decode the data
            
            do {
                //instantiate a JSONDecoder
                let decoder = JSONDecoder()
                
                // decode
                let randomUsers = try decoder.decode(RandomPerson.self, from: data)
                self.randomUserResults = [randomUsers]
                completion(nil)
            } catch {
                NSLog("Unable to decode data")
                completion(error)
                return
                
            }
        }
        dataTask.resume()
        
    }
    
}
