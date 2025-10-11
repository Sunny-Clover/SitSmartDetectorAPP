//
//  FriendsRow.swift
//  SitSmartDetection_SwiftUI
//
//  Created by Sunny Chan on 2024/5/23.
//

import SwiftUI

struct FriendsRow: View {
    let friend: LeaderboardData
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
            AvatarView(photoUrl: friend.photoUrl)
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipped()
            Spacer()
                .frame(width: 20)
            VStack(alignment: .leading){
                HStack {
                    Text(friend.userName)
                        .foregroundStyle(.textGray)
                        .font(.title)
                        .bold()
                    Spacer()
                    // TODO: Badge功能暫不處理
//                    Image(systemName: "medal.fill")
//                        .foregroundStyle(.textGray)
//                    Text(String(friend.badge))
//                        .font(.largeTitle)
//                        .foregroundStyle(.textGray)
                }
                HStack {
                    Text("Lv.\(friend.level)")
                        .foregroundStyle(.textGray)
                    ProgressView(value: friend.progress)
                        .tint(.sysYellow)
                }
            }
            Spacer()
        }
    }
}

struct FriendDTO: Identifiable{
    let id = UUID()
    let rank: Int
    let name: String
    let badge: Int
    let level: Int
    let progress: Double
    let score: Int
}

extension FriendDTO{
    static let demoFriend = FriendDTO(rank: 2, name: "Sunny", badge: 2, level: 2, progress: 0.5, score: 86)
}
//
//#Preview {
//    FriendsRow(friend: .demoFriend)
//}
