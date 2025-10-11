//
//  FriendsView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by Sunny Chan on 2024/5/23.
//

import SwiftUI

struct FriendsView: View {
    @State private var displayOptions = ["Level", "Score"]
    @State private var selectedDisplayOption = 0
    let me = FriendDTO(rank: 4, name: "Sunny", badge: 2, level: 2, progress: 0.3, score: 86)
    let friends = [FriendDTO(rank: 1, name: "Bryan", badge: 10, level: 3, progress: 0.6, score: 86),
                   FriendDTO(rank: 2, name: "Karry", badge: 8, level: 2, progress: 0.6, score: 86),
                   FriendDTO(rank: 3, name: "Roy", badge: 4, level: 1, progress: 0.9, score: 86),
                   FriendDTO(rank: 5, name: "Jackson", badge: 1, level: 1, progress: 0.3, score: 86),
                   FriendDTO(rank: 6, name: "Amy", badge: 1, level: 1, progress: 0.1, score: 86)
                    ]
    @StateObject private var viewModel = FriendViewModel()
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 151/255, green: 181/255, blue: 198/255, alpha: 1)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                        .frame(width: 20)
                    Text("LeaderBoard")
                        .foregroundStyle(.deepAccent)
                        .bold()
                        .font(.title)
                    Spacer()
                    NavigationLink {
                        FriendRequestView()
                    } label: {
                        Image(systemName: "person.fill.badge.plus")
                            .foregroundStyle(.accent)
                            .font(.largeTitle)
                    }
                    Spacer()
                        .frame(width: 20)
                }
                displayOptionPicker
                if selectedDisplayOption == 0 {
                    BadgeAndLevelView
                } else {
                    ScoreView
                    
                }
            }.onAppear {
                viewModel.fetchLeaderboard(for: selectedDisplayOption)
            }
            .onChange(of: selectedDisplayOption) {
                viewModel.fetchLeaderboard(for: selectedDisplayOption)
            }
        }
    }
    
    var displayOptionPicker: some View {
        Picker("Display Option", selection: $selectedDisplayOption) {
            ForEach(displayOptions.indices, id: \.self) { index in
                Text(displayOptions[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(Color(red: 151/255, green: 181/255, blue: 198/255))
        .cornerRadius(7)
        .padding()
    }
    
    var BadgeAndLevelView: some View {
        List {
            MeRow(friend: viewModel.myData ?? LeaderboardData(userID: -1, userName: "Error", photoUrl: "default.png", rank: -1, level: -1, progress: 0, allTimeScore: 0))
            ForEach(viewModel.friendsData) { friend in
                FriendsRow(friend: friend)
            }
        }
        .listStyle(.inset)
    }
    
    var ScoreView: some View {
        List {
            MeScoreRow(friend: viewModel.myData ?? LeaderboardData(userID: -1, userName: "Error", photoUrl: "default.png", rank: -1, level: -1, progress: 0, allTimeScore: 0))
            ForEach(viewModel.friendsData) { friend in
                FriendsScoreRow(friend: friend)
            }
        }
        .listStyle(.inset)
    }
}

#Preview {
    FriendsView()
}
