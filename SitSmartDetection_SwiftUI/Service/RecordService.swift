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
    
    let router = "\(Config.shared.baseURL)/detections"

    private var cancellables = Set<AnyCancellable>()
    
    // API: 获取所有记录
    func fetchRecords(completion: @escaping (Result<[RecordResponse], Error>) -> Void) {
        print("RecordService fetchRecords called!")
        let endpoint = "\(router)/"
        APIManager.shared.performRequest(endpoint: endpoint, method: .GET)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching records: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                case .finished:
                    print("Successfully fetched records")
                }
            }, receiveValue: { (records: [RecordResponse]) in
                completion(.success(records))
            })
            .store(in: &cancellables)
    }
    
    /// 新增紀錄
    func createRecord(record: RecordCreate, completion: @escaping (Result<RecordResponse, Error>) -> Void) {
        print("RecordService's createRecord called")
//        print(record)
        let endpoint = "\(self.router)/"
        
        // Encode body
        var bodyData: Data
        do {
            bodyData = try JSONEncoder().encode(record)
        } catch {
            completion(.failure(SSDError.encodingFailed))
            return
        }
        
        APIManager.shared.performRequest(endpoint: endpoint, method: .POST, body: bodyData)
            .receive(on: DispatchQueue.main)
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    print("fetchUserData failed", error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
            } receiveValue: { (record: RecordResponse) in
                DispatchQueue.main.async {
                    completion(.success(record))
                }
            }
            .store(in: &cancellables)

    }
    
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
