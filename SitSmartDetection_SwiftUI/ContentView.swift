//
//  ContentView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/4.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var authVM = AuthViewModel()
//    @State private var userInfo: UserResponse?
    @State private var selection = 0

    init(){
        UITabBar.appearance().backgroundColor = UIColor(.bg)
    }

    var body: some View {
        if authVM.isAuthenticated {
            // 有現存token，且已讀取到用戶資料
            if let userInfo = authVM.userInfo {
                MainView(userInfo: userInfo)
            } else {
                ProgressView()
                .onAppear {
                    authVM.fetchUserData()
                }
            }
        } else {
            AuthView()
                .environmentObject(authVM)
                .onAppear {
                    authVM.checkAuthentication()
                }
        }
    }
    
//    private func fetchUserData() {
//        guard !accessToken.isEmpty else {
//            // 如果沒有 access token，則導航至 AuthView 進行登入
//            isAuthenticated = false
//            return
//        }
//        
//        // 發送請求至 /user/me 獲取使用者資料
//        authViewModel.fetchUserData { result in
//            switch result {
//            case .success(let user):
//                userInfo = user
//                isAuthenticated = true
//            case .failure(let error):
//                // 處理錯誤，如果 access token 失效，則嘗試使用 refresh token 更新
//                if error.isTokenExpired {
//                    refreshAccessToken()
//                } else {
//                    isAuthenticated = false
//                }
//            }
//        }
//    }
//    
//    private func authenticateUser() {
//        if userService.accessToken.isEmpty {
//            isAuthenticated = false
//        } else {
//            userService.fetchUserData { result in
//                switch result {
//                case .success(let user):
//                    userInfo = user
//                    isAuthenticated = true
//                case .failure:
//                    isAuthenticated = false
//                }
//            }
//        }
//    }
}

struct MainView: View{
    @State private var selection = 0
    let userInfo: UserResponse

    var body: some View {
        ZStack {
            //.gray.edgesIgnoringSafeArea(.all) // 设置整个视图的背景颜色为白色
            TabView(selection: $selection) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                
                HistoryView()
                    .tabItem {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    }
                    .tag(1)
                
                DetectionView()
                    .tabItem {
                        Label("Detection", systemImage: "play.circle.fill")
                    }
                    .tag(2)
                
                FriendsView()
                    .tabItem {
                        Label("Friends", systemImage: "person.2")
                    }
                    .tag(3)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(4)
            }
            .tint(.accent)
        }
    }
}


// MARK: - Preview Providers
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
