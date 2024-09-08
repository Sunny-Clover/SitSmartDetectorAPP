//
//  HomeViewModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/9/3.
//

import Combine
import Foundation

class UserInfoViewModel: ObservableObject {
    
    @Published var userInfo: UserResponse?
    private let userService = UserService()
    private let tokenService = TokenService()
    private var retryTimes = 0
    
    func fetchUserData() {
        print("VM's fetchUserData called!")
        guard let token = self.tokenService.retrieveToken(for: .accessToken) else { return }
        userService.fetchUserData(token: token) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.userInfo = user // Data Binding automatically update UI
                }
            case .failure(let error):
                // TODO: 還未完成
                self?.retryTimes += 1
                if let times = self?.retryTimes{
                    if(times < Config.shared.maxRetryTimes){
                        if (error == .Unauthorized){
                            // token expire(?
                            self?.refreshToken()
                            self?.fetchUserData()
                        }
                    }else{
                        self?.tokenService.deleteToken(completion: {})
                        self?.retryTimes = 0
                    }
                }

            }
        }
    }
    
    func refreshToken(){
        self.tokenService.refreshToken { result in
            // Should make sure cover all .failure cases
            switch result{
            case .success():
                print("Sucessfully auto refresh token")
            case .failure(let error):
                print("Refresh token failed: \(error)")
            }
        }
    }
    
    func getUserLevel() -> Int { // TODO: 要算總共使用時間
        // Level ranking by accumulate Time
        let ranks = Config.shared.accumulateTime
        let minute = self.TimeStr2Min(timeStr: userInfo?.totalTime ?? "00:00")
        for (idx, t) in ranks.enumerated() {
            if minute < t {
                return idx
            }
        }
        return ranks.count
    }
    
    func getUserLevelProgress() -> Float {
        let ranks = Config.shared.accumulateTime
        let level = self.getUserLevel()
        if level == ranks.count{
            return 1
        }else{
            let minute = self.TimeStr2Min(timeStr: userInfo?.totalTime ?? "00:00")
            return Float(minute - ranks[level-1]) / Float(ranks[level] - ranks[level-1])
        }
    }
    
    
    // TODO: 抽出來當Lib或是Ext
    private func TimeStr2Min(timeStr: String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let time = dateFormatter.date(from: timeStr) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: time)
            var minute = calendar.component(.minute, from: time)
            minute = Int(hour*60 + minute)
            print("Hour: \(hour), Minute: \(minute)") // 输出: Hour: 14, Minute: 30
            
            return minute
        } else {
            print("Invalid time format")
            return 0
        }
    }
}
