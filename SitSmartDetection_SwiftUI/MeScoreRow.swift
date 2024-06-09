//
//  MeScoreRow.swift
//  SitSmartDetection_SwiftUI
//
//  Created by Sunny Chan on 2024/5/23.
//

import SwiftUI

struct MeScoreRow: View {
    let friend: Friend
    var body: some View {
        HStack{
            ZStack {
                Circle()
                    .frame(width: 40)
                    .foregroundStyle(Color(red: 151/255, green: 181/255, blue: 198/255))
                Text(String(friend.rank))
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
            }
            Spacer()
                .frame(width: 20)
            Image(friend.name)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipped()
            Spacer()
                .frame(width: 10)
            Text(friend.name)
                .foregroundStyle(.white)
                .font(.title)
                .bold()
            Text(String(friend.score))
                .foregroundStyle(.white)
                .font(.largeTitle)
                .bold()
            Spacer()
                .frame(width: 10)
            Image(systemName: "triangle.fill")
                .foregroundStyle(.sysGreen)
        }
        .padding()
        .frame(width: StatCard_Width*2.05, height: StatCard_Height*0.7)
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

extension Friend{
    static let demoMeScore = Friend(rank: 7, name: "Sunny", badge: 2, level: 2, progress: 0.5, score: 86)
}

#Preview {
    MeScoreRow(friend: .demoMeScore)
}

