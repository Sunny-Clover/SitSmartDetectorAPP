//
//  BadgesView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/21.
//

import SwiftUI

struct BadgesView: View {
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
                                    BadgesDetailView(partName: parts[Pindex], stage: stages[index], timeStandard: timeStandard[index], progress: progressRatioList[Pindex][index], color: colors[index])
                                } label: {
                                    VStack {
                                        Image(parts[Pindex])
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: StatCard_Width*0.4)
                                            .padding(10)
                                            .background(Circle().fill(colors[index]))
                                        Text("\(parts[Pindex]) \(stages[index])")
                                            .foregroundStyle(Color(red: 40/255, green: 88/255, blue: 123/255))
//                                            .bold()
                                        ProgressView(value: progressRatioList[Pindex][index])
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
