//
//  SitSmartDetection_SwiftUIApp.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/4.
//

import SwiftUI
import Firebase
import SwiftData

@main
struct SitSmartDetection_SwiftUIApp: App {
    let container: ModelContainer
    init() {
        do {
            container = try ModelContainer(for: DetectionRecord.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

        } catch {
            fatalError("Failed to create ModelContainer for DetectionRecord.")
        }
        FirebaseApp.configure()
        ProgressCalculator.run()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(Color(UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)))
                .edgesIgnoringSafeArea(.all)
        }.modelContainer(container)
    }
}
