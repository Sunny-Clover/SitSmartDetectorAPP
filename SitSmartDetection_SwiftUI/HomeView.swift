//
//  HomeView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/14.
//

import SwiftUI

var StatCard_Width = UIScreen.main.bounds.width * 0.44
var StatCard_Height = UIScreen.main.bounds.width * 0.4

struct HomeView: View {
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
    var body: some View {
        HStack {
            Spacer()
            Image("Avatar")
            VStack(alignment: .leading) {
                Text("Hi, Sunny!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                Spacer()
                HStack {
                    Text("Lv.2")
                        .foregroundStyle(.white)
                    .bold()
                    ProgressView(value: 0.3)
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
                Image(systemName: "questionmark.circle.fill")
                    .foregroundStyle(.white)
                    .opacity(0.8)
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
}
