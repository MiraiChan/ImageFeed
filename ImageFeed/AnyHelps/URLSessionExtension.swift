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
            print(result)
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
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                 completion(result)
            }
        }
        let task = dataTask(with: request) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                if 200..<300 ~= response.statusCode {
        let decoder = JSONDecoder()
                    do {
                        let decodedModel = try decoder.decode(T.self, from: data)
                        fulfillCompletion(.success(decodedModel))
                    } catch {
                        fulfillCompletion(.failure(NetworkError.decodingError))
                    }
            } else {
                fulfillCompletion(.failure(NetworkError.httpStatusCode(response.statusCode)))
            }
        } else if let error {
            fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
        } else {
            fulfillCompletion(.failure(NetworkError.urlSessionError))
        }
    }
    task.resume()
    return task
}
}
