//
//  HistoryView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/5.
//

import SwiftUI

// 主視圖
struct HistoryView: View {
    
    @StateObject var history: HistoryModel = {
            let currentYear = Calendar.current.component(.year, from: Date())
            return HistoryModel(currentTime: currentYear, averageScore: 0, initLineChartData: lineChartData, initPieChartData: pieChartData, timeUnit: .year)
        }()
    @State private var selectedPart: String? = nil
    @State private var timePeriods = ["Year", "Month", "Week", "Day"]
    @State private var parts = ["Head", "Neck", "Shoulder", "Back", "Leg"]
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 151/255, green: 181/255, blue: 198/255, alpha: 1)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }

    var body: some View {
        ScrollView {
            ZStack {
                BlueBackgroundView() // 覆盖整个顶部的蓝色背景
                GraySemicircleBackgroundView() // 灰色的半圆形背景
                VStack(spacing: 20) {
                        timeSelectionView
                        currentTime
                        scoreDisplay
                        emojiWithScore
                    
//                    partsSelection
//                    trendScoreChart
//                    accuracyDistributionChart
                }
            }
        }
    }
    
    struct BlueBackgroundView: View {
        var body: some View {
            Rectangle()
                .foregroundColor(Color(red: 178/255, green: 206/255, blue: 222/255))
                .edgesIgnoringSafeArea(.all)  // 使蓝色背景填满整个屏幕顶部
        }
    }
    
    struct GraySemicircleBackgroundView: View {
        var body: some View {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height * 0.9))  // 定义半圆的底部起点
                    path.addCurve(to: CGPoint(x: width, y: height * 0.9), control1: CGPoint(x: width / 3, y: 210), control2: CGPoint(x: 2 * width / 3, y: 210))
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                }
                .fill(Color.white)
            }
            .frame(height: 305)  // 根据需要调整高度
        }
    }
    
    var timeSelectionView: some View {
        Picker("Select Time", selection: $history.selectedTime) {
            ForEach(timePeriods, id: \.self) { period in
                Text(period).tag(timePeriods.firstIndex(of: period)!)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(Color(red: 151/255, green: 181/255, blue: 198/255)) // 设置整个Picker的背景色
        .cornerRadius(7)
        .onChange(of: history.selectedTime) { _, _ in
            history.touchTimeSegment()
            history.updateAvgScore()
        }
    }
    
    var currentTime: some View{
        HStack {
            Button {
                history.touchReduce()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
//            .padding(.horizontal)
            
            Text("\(history.currentTime)")
                .font(.title)
                .foregroundStyle(Color.white)
            
            Button {
                history.touchAdd()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
//            .padding(.horizontal)
        }
    }
    
    var scoreDisplay: some View{
        Text("\(Int(history.averageScore))")
            .font(.system(size: 100))
            .bold()
            .foregroundStyle(Color.white)
    }
    
    var emojiWithScore: some View{
        Image("good")
    }
    
}

struct HalfCircleBackgroundView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                path.move(to: CGPoint(x: 0, y: height))
                path.addQuadCurve(to: CGPoint(x: width, y: height), control: CGPoint(x: width / 2, y: 0))
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .frame(height: 300) // 根据需要调整高度
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
