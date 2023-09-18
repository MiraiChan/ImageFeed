//
//  URLSessionExtension.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 05.09.23.
//
import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decodingError
}

extension URLSession {
    /// Вспомогательный метод для выполнения сетевого запроса
    func data (
        for request: URLRequest,
        complition: @escaping (Result<Data,Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data,Error>) -> Void = { result in
            DispatchQueue.main.async {
                complition(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
    
    func objectTask<T:Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<T, Error> in
                do {
                    let decodedModel = try decoder.decode(T.self, from: data)
                    return .success(decodedModel)
                } catch {
                    return .failure(NetworkError.decodingError)
                }
            }
            completion(response)
        }
    }
}
