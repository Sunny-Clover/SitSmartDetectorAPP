//
//  SitSmartDetection_SwiftUIApp.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/4.
//

import SwiftUI
import Firebase
import SwiftData
import TipKit

@main
struct SitSmartDetection_SwiftUIApp: App {
//    let container: ModelContainer
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var userInfoVM = UserInfoViewModel()
    @StateObject private var historyVM = HistoryViewModel(timeUnit: .year)

    
    init() {
//        do {
//            let models = [DetectionRecord.self]
//            container = try ModelContainer(for: DetectionRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//
//        } catch {
//            fatalError("Failed to create ModelContainer for DetectionRecord.")
//        }
//        _userInfoVM = StateObject(wrappedValue: UserInfoViewModel(authViewModel: AuthViewModel()))
        FirebaseApp.configure()
        ProgressCalculator.run()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color(UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)))
                .edgesIgnoringSafeArea(.all)
                .task {
                    // Configure and load your tips at app launch.
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
                .environmentObject(authVM)
                .environmentObject(userInfoVM)
                .environmentObject(historyVM)
        }.modelContainer(for: [DetectionRecord.self], inMemory: true)
//        }.modelContainer(container)
    }
}
