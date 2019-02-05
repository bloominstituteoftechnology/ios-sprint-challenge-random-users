import Foundation

class RandomUserController {
    
    static let shared = RandomUserController()
    private init(){}
    
    ///"https://randomuser.me/api/?format=pretty&results=100"
    ///"https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=100"
    let requestURL = URL(string: "https://randomuser.me/api/?format=pretty&inc=name,email,phone,picture&results=100")!.usingHTTPS!
    var randomUserResults: [RandomPerson] = []
    var thumbURL: String = ""
    
    
    func fetchRandomUsers(with url: URL, completion: @escaping (String?, Error?) -> String) {
        // create the GET request
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            data, _, error in
            
            //Unwrap data
            guard error == nil, let data = data else {
                if let error = error {
                    NSLog("Could not unwrap data: \(error)")
                    completion(nil, error)
                }
                
                return
            }
            print("We Have Data! \(data.hashValue)")
            //Decode the data
            
            do {
                //instantiate a JSONDecoder
                let decoder = JSONDecoder()
                
                // decode
                self.randomUserResults = [try decoder.decode(RandomPerson.self, from: data)]
                print(self.randomUserResults)
               
                completion(nil, error)
                print("no completion")
                return
            } catch {
                    NSLog("Unable to decode data")
                    completion(nil, error)
                    
            }
        }
        dataTask.resume()
        print(self.thumbURL)
    }
   
}
