//
//  BadgesView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/21.
//

import SwiftUI

struct BadgesAllView: View {
    @State private var parts = ["Head", "Neck", "Shoulder", "Back", "Leg"]
    @State private var title = ["Starter", "Explorer", "Master"]
    @State private var colors: [Color] = [
            Color(red: 121/255, green: 180/255, blue: 115/255),
            Color(red: 33/255, green: 118/255, blue: 174/255),
            Color(red: 130/255, green: 76/255, blue: 113/255)
        ]
    
    var body: some View {
        ScrollView {
            VStack{
                ForEach(parts.indices, id: \.self) { Pindex in
                    ScrollView(.horizontal) {
                        HStack {
                            Spacer()
                                .frame(width: 30)
                            ForEach(0..<3, id: \.self) { index in
                                NavigationLink {
                                    BadgesDetailView(partName: parts[Pindex], title: title[index], progress: 0.3, color: colors[index])
                                } label: {
                                    VStack {
                                        Image(parts[Pindex])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: StatCard_Width*0.4)
                                            .padding(10)
                                            .background(Circle().fill(colors[index]))
                                        Text("\(parts[Pindex]) \(title[index])")
                                            .foregroundStyle(Color(red: 40/255, green: 88/255, blue: 123/255))
                                            .bold()
                                        ProgressView(value: 0.3)
                                            .tint(.sysYellow)
                                    }
                                }
                                Spacer()
                                    .frame(width: 25)
                            }
                        }
                    }
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
    }
}

#Preview {
    BadgesAllView()
}
