//
//  NetworkService.swift
//  MVP test Project
//
//  Created by eduard.stern on 27.10.2021.
//

import Foundation

typealias NetworkResponseClosure<T: Decodable> = (Swift.Result<T, Error>) -> ()

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

protocol NetworkServiceInterface {
    func fetch<T: Decodable>(_ request: APIMapping, completion: @escaping NetworkResponseClosure<T>)
    func downloadImage(url: URL, completion: @escaping (Result<Data>) -> Void)
}

class NetworkService: NetworkServiceInterface {
    
    func fetch<T: Decodable>(_ request: APIMapping, completion: @escaping NetworkResponseClosure<T>) {

        URLSession.shared.dataTask(with: request.urlRequest) { data, response, error in
            do {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    preconditionFailure("No error was received but we also don't have data...")
                }

                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(decodedObject))
            } catch (let error) {
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }

    func downloadImage(url: URL, completion: @escaping (Result<Data>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async() {
                completion(.success(data))
            }
        }.resume()
    }
}
