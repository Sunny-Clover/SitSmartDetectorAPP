//
//  HomeView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/14.
//

import SwiftUI
import TipKit

var StatCard_Width = UIScreen.main.bounds.width * 0.44
var StatCard_Height = UIScreen.main.bounds.width * 0.4

struct HomeView: View {
    //    private let favoriteLandmarkTip = FavoriteLandmarkTip()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.bg)
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .center, spacing: 25) {
                        HeaderView()
                        StatCardsView()
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}



struct HeaderView: View {
    @EnvironmentObject private var userInfoVM: UserInfoViewModel
    var body: some View {
        HStack {
            Spacer()
            Image("Sunny")
            VStack(alignment: .leading) {
                Text("Hi, \(userInfoVM.userInfo?.userName ?? "Guest")!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Spacer()
                HStack {
                    Text("Lv.\(userInfoVM.getUserLevel())")
                        .foregroundStyle(.white)
                    .bold()
                    ProgressView(value: userInfoVM.getUserLevelProgress(), total: 1)
                        .tint(.sysYellow)
                }
            }
            .padding()
            Spacer()
        }
        .padding(EdgeInsets(top: 50, leading: 15, bottom: 9, trailing: 15))
        .background(.accent)
        .clipShape(.rect(cornerRadius: 35))
        
    }
}

struct StatCardsView: View {
    var body: some View {
        VStack {
            HStack{
                AverageScore()
                TotalTime()
            }
            HStack{
                Level()
                ReachedGoal()
            }
            
            NavigationLink {
                BadgesView()
            } label: {
                Badges()
            }
            
            NavigationLink {
                SittingStandardView()
            } label: {
                SittingStandard()
            }
        }
    }
}

struct AverageScore: View {
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Image(systemName: "deskclock.fill")
                    .frame(width: 11)
                    .foregroundStyle(.white)

                Text("Average Score")
                    .font(.system(size: 17))
//                    .dynamicTypeSize(..<DynamicTypeSize.accessibility1)
                    .foregroundColor(.white)
                    .bold()
            }
            Spacer()
            Text("89")
                .font(.system(size: 60))
                .foregroundColor(.white)
                .fontWeight(.bold)
            Spacer()
            Text("Better than 86% of users")
                .font(.system(size: 11))
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: StatCard_Width, height: StatCard_Height)
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
        
    }
}

struct TotalTime: View {
    var body: some View {
        HomeView_PieChart(data: home_allPartPieChartData, StatCard_Width: StatCard_Width)
            .padding()
            .frame(width: StatCard_Width, height: StatCard_Height)
            .background(.accent)
            .cornerRadius(10)
            .shadow(radius: 3)
    }
}

struct Level: View {
    var touchLandmarkTip = TouchLandmarkTip()
    @State private var showSheet = false
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.white)
                Spacer()
                Text("Level")
                    .font(.title3)
                    .foregroundColor(.white)
                    .bold()
                Spacer()
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundStyle(.white)
                        .opacity(0.8)
                        .popoverTip(touchLandmarkTip, arrowEdge: .bottom)
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $showSheet) {
                    Text("Accumulate by average score multiplied by total detection time.")
                        .presentationDetents([.medium, .large])
                }
            }
            Spacer()
            Text("2")
                .font(.system(size: 70))
                .foregroundColor(.white)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
        .frame(width: StatCard_Width, height: StatCard_Height)
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct TouchLandmarkTip: Tip {
    var title: Text {
        Text("Touch")
    }
    var message: Text? {
        Text("View the rules for the level")
    }
    var image: Image? {
        Image(systemName: "hand.point.up.left")
    }
}

struct ReachedGoal: View {
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Image(systemName: "flag.fill")
                    .foregroundStyle(.white)
                Text("Reached Goal")
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .bold()
            }
            Spacer()
            HStack {
                Text("6")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Text("/10")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            Text("Times")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(width: StatCard_Width, height: StatCard_Height)
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct Badges: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "medal.fill")
                    .foregroundStyle(.white)
                Text("Badges")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .bold()
                Spacer()
                Text("Show more")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .bold()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)

            }
            Spacer()
            HStack {
                Spacer()
                    .frame(width: StatCard_Width*0.1)
                Text("\(achievedPartsStages.count)")
                    .font(.system(size: 70))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Array(achievedPartsStages.keys), id: \.self) { part in
                            if let stage = achievedPartsStages[part],
                               let stageIndex = stages.firstIndex(of: stage) {
                                    Image(part) // 確保圖片名稱與部位名稱一致
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: StatCard_Width * 0.2)
                                        .padding(10)
                                        .background(Circle().fill(colors[stageIndex]))
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: StatCard_Width*2.05, height: StatCard_Height)
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

struct SittingStandard: View {
    var body: some View {
        HStack {
            Image("Sitting")
                .foregroundStyle(.white)
            Spacer()
            Text("How to sit correctly?")
                .foregroundStyle(.white)
                .font(.title2)
                .bold()
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.white)
        }
        .padding()
        .frame(width: StatCard_Width*2.05, height: StatCard_Height*0.5)
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}

#Preview {
    HomeView()
        .task {
            try? Tips.resetDatastore()
            
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
}
