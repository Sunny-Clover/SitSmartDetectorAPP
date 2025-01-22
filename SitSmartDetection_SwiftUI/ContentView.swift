//
//  ContentView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/4.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject private var authManager: AuthManager
    @EnvironmentObject private var userInfoVM: UserInfoViewModel
//    @StateObject private var userInfoVM = UserInfoViewModel()
    @EnvironmentObject private var historyVM: HistoryViewModel
    
    init(){
        UITabBar.appearance().backgroundColor = UIColor(.bg)
    }

    var body: some View {
        if authManager.isAuthenticated {
            MainView()
                .task {
                    userInfoVM.fetchUserData()
                    historyVM.fetchData()
                }
        } else {
            AuthView()
        }
    }
    
}

struct MainView: View{
    @State private var selection = 0
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
