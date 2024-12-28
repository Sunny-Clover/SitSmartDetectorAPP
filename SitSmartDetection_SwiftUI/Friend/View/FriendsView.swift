//
//  FriendsView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by Sunny Chan on 2024/5/23.
//

import SwiftUI

struct FriendsView: View {
    @State private var displayOptions = ["Badge & Level", "Score"]
    @State private var selectedDisplayOption = 0
    let me = Friend(rank: 4, name: "Sunny", badge: 2, level: 2, progress: 0.3, score: 86)
    let friends = [Friend(rank: 1, name: "Bryan", badge: 10, level: 3, progress: 0.6, score: 86),
                   Friend(rank: 2, name: "Karry", badge: 8, level: 2, progress: 0.6, score: 86),
                   Friend(rank: 3, name: "Roy", badge: 4, level: 1, progress: 0.9, score: 86),
                   Friend(rank: 5, name: "Jackson", badge: 1, level: 1, progress: 0.3, score: 86),
                   Friend(rank: 6, name: "Amy", badge: 1, level: 1, progress: 0.1, score: 86)
                    ]
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 151/255, green: 181/255, blue: 198/255, alpha: 1)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: 20)
                Text("LeaderBoard")
                    .foregroundStyle(.deepAccent)
                    .bold()
                .font(.title)
                Spacer()
                Image(systemName: "person.fill.badge.plus")
                    .foregroundStyle(.accent)
                    .font(.largeTitle)
                Spacer()
                    .frame(width: 20)
            }
            displayOptionPicker
            if selectedDisplayOption == 0 {
                BadgeAndLevelView
            } else {
                ScoreView
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
            MeRow(friend: me)
            ForEach(friends) { friend in
                FriendsRow(friend: friend)
            }
        }
        .listStyle(.inset)
    }
    
    var ScoreView: some View {
        List {
            MeScoreRow(friend: me)
            ForEach(friends) { friend in
                FriendsScoreRow(friend: friend)
            }
        }
        .listStyle(.inset)
    }
}

#Preview {
    FriendsView()
}
