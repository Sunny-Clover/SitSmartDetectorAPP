//
//  HomeViewModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/9/3.
//

import Combine
import SwiftUI
import Foundation

class UserInfoViewModel: ObservableObject {
    @Published var user: UserResponse? = nil
    private let tokenService = TokenService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 監聽 UserService 中的 currentUser 變化
        UserService.shared.$userInfo
            .sink { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
    
    var userTotalTime: String {
        guard let user = user else {
            return "0 h 0 m" // 預設值
        }
        var minutes = TimeStr2Min(timeStr: user.totalDetectionTime)
        let hour = minutes / 60
        minutes = minutes % 60
        return String(format: "%d h %d m", hour, minutes)
    }

    var userTotalTimePieDataSource: [PieDataSeries]{
        // TODO: 這邊先照Sunny寫的格式吧，有空再重構
        return [
            PieDataSeries(title: "init", ratios: [
                [
                    RatioData(
                        title: "All Correct",
                        day: Date(timeIntervalSince1970: 1711309674.574878),
                        ratio: self.getAllTimeScore(),
                        uiColor: UIColor(Color(red: 0.966, green: 0.887, blue: 0.496))
                    ),
                    RatioData(
                        title: "Partially Correct",
                        day: Date(timeIntervalSince1970: 1711396074.574878),
                        ratio: 100-self.getAllTimeScore(),
                        uiColor: UIColor(Color(red: 1.0, green: 0.792, blue: 0.831))
                    )
                ]
            ])
        ]
    }
    func fetchUserData() {
        print("VM's fetchUserData called!")
        UserService.shared.fetchUserData(){ result in
            switch result {
            case .success(let user):
                print(user)
                break
            case .failure(let error):
                // TODO:
                print("VM fetchUserData failed ", error)
                break
            }
        }
    }
    
    func getAllTimeScore() -> Int {
        return Int((self.user?.allTimeScore ?? 0) * 100)
    }
    
    
    // TODO: 抽出來當Lib或是Ext
    private func TimeStr2Min(timeStr: String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let time = dateFormatter.date(from: timeStr) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: time)
            var minute = calendar.component(.minute, from: time)
            minute = Int(hour*60 + minute)
            // print("Hour: \(hour), Minute: \(minute)") // 输出: Hour: 14, Minute: 30
            
            return minute
        } else {
            print("Invalid time format")
            return 0
        }
    }
}
