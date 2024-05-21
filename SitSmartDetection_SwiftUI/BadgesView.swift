//
//  BadgesView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/21.
//

import SwiftUI

struct BadgesView: View {
    @State private var parts = ["Head", "Neck", "Shoulder", "Back", "Leg"]
    @State private var title = ["Starter", "Explorer", "Master"]
    @State private var colors: [Color] = [
            Color(red: 121/255, green: 180/255, blue: 115/255),
            Color(red: 33/255, green: 118/255, blue: 174/255),
            Color(red: 130/255, green: 76/255, blue: 113/255)
        ]
    @State private var tmpBodyPartsTime = [400, 200, 50, 100, 460]
    
    func calculateProgress(partTime: Int, index: Int) -> Double {
        switch index {
        case 0: // Starter
            return min(Double(partTime) / 100.0, 1.0)
        case 1: // Explorer
            return min(max(Double(partTime - 100) / 200.0, 0.0), 1.0)
        case 2: // Master
            return min(max(Double(partTime - 300) / 200.0, 0.0), 1.0)
        default:
            return 0.0
        }
    }
    
    var body: some View {
        ScrollView {
            VStack{
                ForEach(parts.indices, id: \.self) { Pindex in
                    ScrollView(.horizontal) {
                        HStack {
                            Spacer()
                                .frame(width: 30)
                            ForEach(0..<3, id: \.self) { index in
                                let progressRatio = calculateProgress(partTime: tmpBodyPartsTime[Pindex], index: index)
                                NavigationLink {
                                    BadgesDetailView(partName: parts[Pindex], title: title[index], progress: progressRatio, color: colors[index])
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
//                                            .bold()
                                        ProgressView(value: progressRatio)
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
    BadgesView()
}
