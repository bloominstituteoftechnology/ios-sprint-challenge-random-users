import Foundation
import UIKit

// HTTP Request Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// API Response Errors
enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherNetworkError
    case badData
    case noDecode
    case badURL
}

// Fetch, Decode, and Handle Errors from API Reponse
class RandomUserController {
    
    // Prepare URL
    private let baseURL = URL(string: "https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000")!
    
    func fetchRandomUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        
        let randomUserURL = baseURL
        
        var request = URLRequest(url: randomUserURL)
        request.httpMethod = HTTPMethod.get.rawValue
        
        // Actual API Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with API call... \(error)")
                completion(.failure(.otherNetworkError))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let users = try decoder.decode(APIResults.self, from: data).results
                completion(.success(users))
            } catch {
                completion(.failure(.noDecode))
            }
            
        }.resume()
    }
}
