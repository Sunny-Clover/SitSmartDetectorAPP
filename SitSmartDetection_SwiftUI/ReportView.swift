//
//  ReportView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/6/9.
//

import SwiftUI

struct ReportView: View {
    @StateObject var history: HistoryModel = {
        return HistoryModel(averageScore: 80, initLineChartData: lineChartData, initPieChartData: allPartPieChartData, timeUnit: .year)
    }()
    private let emojiSize: CGFloat = 45
    
    var body: some View {
        ScrollView {
            ZStack {
                Color(.accent)
                    .ignoresSafeArea()
                VStack(spacing: 24) {
                    Spacer()
                        .frame(height: 50)
                    HStack {
                        Spacer()
                        Text("Score")
                            .font(.system(size: 25))
                            .foregroundStyle(Color.white)
                            .bold()
                        Spacer()
                    }
                    scoreDisplay
                    emojiWithScore
                }
                .background(GraySemicircleBackgroundView())
            }

            VStack(spacing: 3) {
                partsSelection
                Spacer()
                Text("Accuracy Distribution")
                    .foregroundStyle(Color.gray)
                    .bold()
                    .padding()
                HistoryPieChart(data: history.pieChartData, timeUnit: history.timeUnit)
            }
            .padding()
            .background(.bg)
        }
        .ignoresSafeArea()
    }
    
    struct GraySemicircleBackgroundView: View {
        var body: some View {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height * 0.9))  // 定义半圆的底部起点
                    path.addCurve(to: CGPoint(x: width, y: height * 0.9), control1: CGPoint(x: width / 3, y: 260), control2: CGPoint(x: 2 * width / 3, y: 260))
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                }
                .fill(.bg)
            }
            .frame(height: 360)  // 根据需要调整高度
        }
    }
    
    var scoreDisplay: some View {
        Text("\(Int(history.averageScore))")
            .font(.system(size: 100))
            .bold()
            .foregroundStyle(Color.white)
    }
    
    var emojiWithScore: some View {
        if history.averageScore < 60 {
            return AnyView(Image("bad")
                .resizable()
                .frame(width: emojiSize, height: emojiSize))
        } else if history.averageScore < 80 {
            return AnyView(Image("not good")
                .resizable()
                .frame(width: emojiSize, height: emojiSize))
        } else {
            return AnyView(Image("good")
                .resizable()
                .frame(width: emojiSize, height: emojiSize))
        }
    }
    
    var partsSelection: some View {
        VStack(spacing: 13) {
            Text(history.selectedPartIndex == nil ? "All Body Parts" : parts[history.selectedPartIndex!])
                .font(.title3)
                .foregroundStyle(Color.gray)
                .bold()
            HStack(spacing: 6) {
                ForEach(parts.indices, id: \.self) { index in
                    Button(action: {
                        if(history.selectedPartIndex == index){
                            history.selectedPartIndex = nil
                        }else{
                            history.selectedPartIndex = index  // Update selected index on tap
                        }
                        history.updateChartData()
                        history.updateAvgScore()
                    }) {
                        Image(parts[index])  // Assume image names match the parts array
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .padding(7)
                            .background(Circle().fill(Color(red: 178/255, green: 206/255, blue: 222/255)))
                            .opacity(history.selectedPartIndex == nil ? 1.0 : (history.selectedPartIndex == index ? 1.0 : 0.5))
                    }
                }
            }
        }
    }
}

#Preview {
    ReportView()
}
