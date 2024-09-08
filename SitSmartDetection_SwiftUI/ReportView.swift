//
//  ReportView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/6/9.
//

import SwiftUI

struct ReportView: View {
    @StateObject var report = HistoryModel(initLineChartData: lineChartDataDummy, initPieChartData: allPartPieChartData, timeUnit: .year)
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
                    .frame(height: 30)
                Text("Accuracy Distribution")
                    .font(.title3)
                    .foregroundStyle(Color.gray)
                    .bold()
                    .padding()
                // TODO: 這邊要改掉
//                HistoryPieChart(pieChart: PieChart(data: report.pieChartData, timeUnit: report.timeUnit))
            }
            .padding()
        }
        .background(.bg)
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
        Text("\(Int(report.averageScore))")
            .font(.system(size: 100))
            .bold()
            .foregroundStyle(Color.white)
    }
    
    var emojiWithScore: some View {
        if report.averageScore < 60 {
            return AnyView(Image("bad")
                .resizable()
                .frame(width: emojiSize, height: emojiSize))
        } else if report.averageScore < 80 {
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
            Text(report.selectedPartIndex == nil ? "All Body Parts" : parts[report.selectedPartIndex!])
                .foregroundStyle(Color.gray)
                .font(.title3)
//                .bold()
            HStack(spacing: 6) {
                ForEach(parts.indices, id: \.self) { index in
                    Button(action: {
                        if(report.selectedPartIndex == index){
                            report.selectedPartIndex = nil
                        }else{
                            report.selectedPartIndex = index  // Update selected index on tap
                        }
                        report.updateChartData_ReportView()
                        report.updateAvgScore()
                    }) {
                        Image(parts[index])  // Assume image names match the parts array
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .padding(7)
                            .background(Circle().fill(Color(red: 178/255, green: 206/255, blue: 222/255)))
                            .opacity(report.selectedPartIndex == nil ? 1.0 : (report.selectedPartIndex == index ? 1.0 : 0.5))
                    }
                }
            }
        }
    }
}

#Preview {
//    ReportView(report: HistoryModel(initLineChartData: lineChartData, initPieChartData: allPartPieChartData, timeUnit: .year))
    ReportView()
}
