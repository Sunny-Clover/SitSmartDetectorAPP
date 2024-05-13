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
        return HistoryModel(averageScore: 0, initLineChartData: lineChartData, initPieChartData: allPartPieChartData, timeUnit: .year)
    }()
    @State private var timePeriods = ["Year", "Month", "Week", "Day"]
    @State private var parts = ["Head", "Neck", "Shoulder", "Back", "Leg"]
    @State private var selectedTime = 0
    @State private var maxTextWidth: CGFloat = 0
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 151/255, green: 181/255, blue: 198/255, alpha: 1)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }

    var body: some View {
        ScrollView {
            ZStack {
                BlueBackgroundView()
                VStack(spacing: 8) {
                    timeSelectionView
                    currentTime
                    scoreDisplay
                        .padding(5)
                    emojiWithScore
                        .padding()
                }
                .background(GraySemicircleBackgroundView())
            }
            ZStack {
                VStack(spacing: 30) {
                    partsSelection
    //                HistoryLineChart(data: history.lineChartData, timeUnit: history.timeUnit)
                    HistoryLineChart(lineChart: LineChart(data: history.lineChartData, timeUnit: history.timeUnit))
                    HistoryPieChart(data: history.pieChartData, timeUnit: history.timeUnit)
                }
                .padding()
            }
        }
        .onAppear {
            history.updateAvgScore()
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
                    path.move(to: CGPoint(x: 0, y: height * 0.85))  // 定义半圆的底部起点
                    path.addCurve(to: CGPoint(x: width, y: height * 0.85), control1: CGPoint(x: width / 3, y: 225), control2: CGPoint(x: 2 * width / 3, y: 225))
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                }
                .fill(Color(red: 249/255, green: 249/255, blue: 249/255))
            }
            .frame(height: 333)  // 根据需要调整高度
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
            history.updateDisplayDate()
            history.updateAvgScore()
            history.changeTimeUnit()
            history.checkTimeLimit()
        }
        .padding()
    }
    
    var currentTime: some View {
        HStack {
            Spacer()
            
            Button {
                history.touchReduce()
                history.updateAvgScore()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
//            .frame(width: maxTextWidth)
            
            Text("\(history.displayDate)")
                .font(.title3)
                .foregroundStyle(Color.white)
            
            Button {
                history.touchAdd()
                history.updateAvgScore()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .imageScale(.large)
                    .opacity(history.addTime == true ? 1.0 : 0.5)
            }
//            .frame(width: maxTextWidth)
            
            Spacer()
        }
    }
    
    var scoreDisplay: some View {
        Text("\(Int(history.averageScore))")
            .font(.system(size: 100))
            .bold()
            .foregroundStyle(Color.white)
    }
    
    var emojiWithScore: some View {
        if history.averageScore < 60{
            Image("bad")
        }
        else if history.averageScore < 80{
            Image("not good")
        }
        else{
            Image("good")
        }
    }
    
    var partsSelection: some View {
        VStack(spacing: 10) {
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

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
