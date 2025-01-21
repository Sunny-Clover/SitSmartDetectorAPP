//
//  AvatarView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2025/1/20.
//
import SwiftUI


struct AvatarView: View {
    var userID: Int
    var body: some View {
        let url = "\(Config.shared.baseURL)/users/avatar/\(userID)"
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
