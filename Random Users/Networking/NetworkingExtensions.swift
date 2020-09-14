//
//  NetworkingExtensions.swift
//  Random Users
//
//  Created by Shawn Gee on 4/11/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import Foundation

extension URLSession {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(.clientError(error)))
                return
            }

            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completionHandler(.failure(.invalidResponseCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            completionHandler(.success(data))
        }
    }
    
    func dataTask<T>(with request: URLRequest, completionHandler: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask where T: Decodable {
        return self.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(.clientError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                completionHandler(.failure(.invalidResponseCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            completionHandler(JSONDecoder().decodeResult(T.self, from: data))
        }
    }
}

extension JSONDecoder {
    func decodeResult<T>(_ type: T.Type, from data: Data) -> Result<T, NetworkError> where T : Decodable {
        do {
            let object = try decode(type, from: data)
            return .success(object)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
