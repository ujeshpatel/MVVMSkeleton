//
//  APIService.swift
//  DemoAPICall
//
//  Created by Ujesh Patel on 16/04/25.
//
import Foundation

protocol NetworkService {
    func request<T: Decodable>(
        endpoint: String,
        method: String,
        parameters: [String: Any]?,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final class URLSessionNetworkService: NetworkService {

    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let parameters = parameters, method == "POST" {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 0)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }

        }.resume()
    }
}
