//
//  AvatarView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2025/1/20.
//
import SwiftUI


struct AvatarView: View {
    var userID: Int
    var photoUrl: String? // 更新的圖片地址，觸發View的刷新
    
    var body: some View {
        // 加上時間戳記，確保AvatarView更新時，AsyncImage也會跟著刷新
        let url = "\(Config.shared.baseURL)/users/avatar/\(userID)?t=\(Date().timeIntervalSince1970)"
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                // 加載中的佔位圖像
                Image("Sunny")
                    .resizable()
            case .success(let image):
                // 成功加載的圖片
                image
                    .resizable()
            case .failure:
                // 加載失敗的佔位圖像
                Image("Sunny")
                    .resizable()
            @unknown default:
                // 未知情況下的佔位圖像
                Image("Sunny")
                    .resizable()
            }
        }
    }
}
