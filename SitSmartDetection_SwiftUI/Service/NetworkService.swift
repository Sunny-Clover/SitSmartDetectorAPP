//
//  NetworkService.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/9/7.
//

import Foundation
import Combine

class NetworkService {
    static func sendRequest<T: Codable>(
        to url: URL,
        method: String = "POST",
        body: T?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode body
        if let body = body {
            do {
                let bodyData = try JSONEncoder().encode(body)
                request.httpBody = bodyData
            } catch {
                completion(.failure(SSDError.encodingFailed))
                return
            }
        }
        
        // Execute request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Request failed with status code \(statusCode)"])
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
