//
//  BadgesDetailView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/21.
//

import SwiftUI

struct BadgesDetailView: View {
    var partName: String
    var title: String
    var progress: Float
    var color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            Image(partName)
                .resizable()
                .scaledToFit()
                .frame(width: StatCard_Width*0.4)
                .padding(30)
                .background(Circle().fill(color))
            Text("\(partName) \(title)")
                .foregroundStyle(.deepAccent)
                .font(.largeTitle)
                .bold()
            Text("Achieving Correct Posture for")
                .foregroundStyle(.deepAccent)
            HStack {
                Text("100")
                    .foregroundStyle(.deepAccent)
                    .font(.largeTitle)
                .bold()
                Text("Minutes")
                    .foregroundStyle(.deepAccent)
            }
            
            ProgressView(value: 0.3){}
            currentValueLabel: {
                Text("30%")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .tint(.sysYellow)
            .frame(width: StatCard_Width*1.5)
        }
    }
}

#Preview {
    BadgesDetailView(partName: "Head", title: "Starter", progress: 0.3, color: Color(red: 121/255, green: 180/255, blue: 115/255))
}
