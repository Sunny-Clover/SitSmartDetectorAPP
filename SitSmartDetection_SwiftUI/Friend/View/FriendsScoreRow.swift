//
//  FriendsScoreRow.swift
//  SitSmartDetection_SwiftUI
//
//  Created by Sunny Chan on 2024/5/23.
//

import SwiftUI

struct FriendsScoreRow: View {
    let friend: Friend
    var body: some View {
        HStack{
            ZStack {
                if friend.rank < 4 {
                    Circle()
                        .frame(width: 40)
                        .foregroundStyle(.accent)
                    Text(String(friend.rank))
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                } else {
                    Circle()
                        .frame(width: 40)
                        .foregroundStyle(.clear)
                    Text(String(friend.rank))
                        .foregroundStyle(.textGray)
                        .font(.title)
                        .bold()
                }
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
                .foregroundStyle(.textGray)
                .font(.title)
                .bold()
            Spacer()
            Text(String(friend.score))
                .foregroundStyle(.textGray)
                .font(.largeTitle)
                .bold()
            Spacer()
                .frame(width: 10)
            Image(systemName: "triangle.fill")
                .foregroundStyle(.sysGreen)
            Spacer()
                .frame(width: 2)
        }
    }
}

extension Friend{
    static let demoFriendsScore = Friend(rank: 7, name: "Sunny", badge: 2, level: 2, progress: 0.5, score: 86)
}

#Preview {
    FriendsScoreRow(friend: .demoFriendsScore)
}
