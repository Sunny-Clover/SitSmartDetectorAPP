//
//  HomeScreen.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/14.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color(.bg)
                .ignoresSafeArea()
            ScrollView {
               VStack(alignment: .center, spacing: 25) {
                   HeaderView()
                   StatCardsView()
                   BadgesView()
                   NavigationLink(destination: Text("Sitting Tips")) {
                       Text("How to sit correctly?")
                           .foregroundColor(.blue)
                   }
                   Spacer()
               }
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
                Text("Lv.2")
                    .foregroundStyle(.white)
            }
            .padding()
            Spacer()
        }
        .padding()
        .background(.accent)
        .clipShape(.rect(cornerRadius: 20))
    }
}

struct StatCardsView: View {
    var body: some View {
        VStack {
            HStack{
                AverageScore()
                TotalTime()
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            HStack{
                Level()
                ReachedGoal()
            }
        }
    }
}

struct AverageScore: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Average Score")
                .font(.title3)
                .foregroundColor(.white)
                .bold()
            Text("89")
                .font(.system(size: 60))
                .foregroundColor(.white)
                .fontWeight(.bold)
            Text("Better than 86% of users")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.4)
    }
}

struct TotalTime: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Total Time")
                .font(.title3)
                .foregroundColor(.white)
                .bold()
            Text("662.5")
                .font(.system(size: 49))
                .foregroundColor(.white)
                .fontWeight(.bold)
            Text("hr")
                .font(.subheadline)
                .foregroundColor(.white)
            Text("All Correct")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.4)
    }
}

struct Level: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Level")
                .font(.title3)
                .foregroundColor(.white)
                .bold()
            Text("2")
                .font(.system(size: 49))
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        .padding()
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.4)
    }
}

struct ReachedGoal: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Reached Goal")
                .font(.title3)
                .foregroundColor(.white)
                .bold()
            Text("6/10")
                .font(.system(size: 60))
                .foregroundColor(.white)
                .fontWeight(.bold)
            Text("Times")
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding()
        .background(.accent)
        .cornerRadius(10)
        .shadow(radius: 3)
        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.4)
    }
}

struct BadgesView: View {
    var body: some View {
        HStack {
            Badge(icon: "music.note", title: "Music Lover")
            Badge(icon: "brain.head.profile", title: "Smart Thinker")
        }
    }
}

struct Badge: View {
    var icon: String
    var title: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
            Text(title)
        }
        .padding()
        .background(Color.green.opacity(0.2))
        .cornerRadius(10)
    }
}

#Preview {
    HomeView()
}
