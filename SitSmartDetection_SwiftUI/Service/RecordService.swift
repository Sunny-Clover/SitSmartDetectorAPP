//
//  RecordService.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/9/7.
//

import Foundation
import Combine
import SwiftUI

class RecordService {
//    @Published var records: [RecordCreate] = [] // 假設你的模型是叫 Record
    @Published var errorMessage: String? = nil
    
    let baseURL = Config.shared.baseURL
    private lazy var path: String = {
        return "\(baseURL)/records/"
    }()

    private var cancellables = Set<AnyCancellable>() // 存储所有的取消对象
    
    // API: 获取所有记录
    func fetchRecords(token: String, completion: @escaping (Result<[RecordResponse], Error>) -> Void) {
        print("RecordService fetchRecords called!")
        guard let url = URL(string: path) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // 2. 使用 URLSession 执行网络请求
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: [RecordResponse].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching records: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                case .finished:
                    print("Successfully fetched records")
                }
            }, receiveValue: { records in
                completion(.success(records))
            })
            .store(in: &cancellables)
    }
    
    /// 新增紀錄
    func createRecord(token: String, record: RecordCreate, completion: @escaping (Result<Void, Error>) -> Void) {
        print("RecordService's createRecord called")
        guard let url = URL(string: path) else {
            completion(.failure(URLError(.badURL)))
            return
        }
//        NetworkService.sendRequest(to: url, body: record, completion: completion)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Encode body
        do {
            let bodyData = try JSONEncoder().encode(record)
            request.httpBody = bodyData
        } catch {
            completion(.failure(SSDError.encodingFailed))
            return
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
    
    // API: 删除记录
//    func deleteRecord(recordID: String) {
//        // 1. 构建URL
//        guard let url = URL(string: "\(baseURL)/records/\(recordID)") else {
//            print("Invalid URL")
//            return
//        }
//        
//        // 2. 构建请求
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        
//        // 3. 使用 URLSession 执行网络请求
//        URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { output in
//                // 检查响应状态码是否是 200~299
//                guard let response = output.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
//            }
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    print("Error deleting record: \(error.localizedDescription)")
//                    self.errorMessage = error.localizedDescription
//                case .finished:
//                    print("Successfully deleted record")
//                }
//            }, receiveValue: { _ in
//                self.fetchRecords() // 重新获取最新的记录
//            })
//            .store(in: &cancellables)
//    }
}


enum SSDError: Error, Equatable {
    case missingToken
    case tokenExpired
    case unauthorized
    case encodingFailed
    case other(Error)
    
    static func ==(lhs: SSDError, rhs: SSDError) -> Bool {
        switch (lhs, rhs) {
        case (.missingToken, .missingToken),
             (.unauthorized, .unauthorized),
             (.tokenExpired, .tokenExpired),
             (.encodingFailed, .encodingFailed):
            return true
        case (.other(let lhsError), .other(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
