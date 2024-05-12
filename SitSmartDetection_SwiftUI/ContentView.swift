//
//  ContentView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/4.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 0
    
    init(){
        UITabBar.appearance().backgroundColor = UIColor.white
    }

    var body: some View {
        ZStack {
//            Color.gray.edgesIgnoringSafeArea(.all) // 设置整个视图的背景颜色为白色
            TabView(selection: $selection) {
                HomeView()
                    .background(Color.clear)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                    
                HistoryView()
                    .background(Color.gray)
                    .tabItem {
                        Label("History", systemImage: "clock.arrow.circlepath")
                    }
                    .tag(1)
                
                PlayView()
                    .background(Color.clear)
                    .tabItem {
                        Label("Play", systemImage: "play.circle.fill")
                    }
                    .tag(2)
                    
                FriendsView()
                    .background(Color.clear)
                    .tabItem {
                        Label("Friends", systemImage: "person.2")
                    }
                    .tag(3)
                    
                ProfileView()
                    .background(Color.clear)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(4)
            }
            .background(Color.white)
        }
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home Screen")
    }
}

//struct HistoryView: View {
//    var body: some View {
//        Text("History Screen")
//    }
//}

struct PlayView: View {
    var body: some View {
        Text("Play Screen")
    }
}

struct FriendsView: View {
    var body: some View {
        Text("Friends Screen")
    }
}

struct ProfileView: View {
    var body: some View {
        Text("Profile Screen")
    }
}

// MARK: - Preview Providers
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}

//struct HistoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryView()
//    }
//}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}