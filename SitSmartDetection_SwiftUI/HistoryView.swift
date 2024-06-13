//
//  HistoryView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/5.
//

import SwiftUI
import SwiftData

// 主視圖
struct HistoryView: View {
    @Query private var records: [DetectionRecord]
    @Environment (\.modelContext) private var modelContext
    @StateObject var history: HistoryModel = {
        return HistoryModel(averageScore: 0, initLineChartData: lineChartData, initPieChartData: allPartPieChartData, timeUnit: .year)
    }()
    @State private var timePeriods = ["Year", "Month", "Week", "Day"]
    @State private var parts = ["Head", "Neck", "Shoulder", "Back", "Leg"]
    @State private var selectedTime = 0
    @State private var maxTextWidth: CGFloat = 0
    @State private var displayOptions = ["Trend Score", "Accuracy Distribution"]
    @State private var selectedDisplayOption = 0
    private let emojiSize: CGFloat = 45
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(red: 151/255, green: 181/255, blue: 198/255, alpha: 1)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }

    var body: some View {
        ScrollView {
            ZStack {
                Color(.accent)
                    .ignoresSafeArea()
                VStack(spacing: 3) {
                    Spacer()
                        .frame(height: 40)
                    timeSelectionView
                    currentTime
                    scoreDisplay
                    emojiWithScore
                }
                .background(GraySemicircleBackgroundView())
            }

            VStack(spacing: 3) {
                partsSelection
                displayOptionPicker
                if selectedDisplayOption == 0 {
                    HistoryLineChart(lineChart: LineChart(data: history.lineChartData, timeUnit: history.timeUnit))
                } else {
                    HistoryPieChart(data: history.pieChartData, timeUnit: history.timeUnit)
                }
            }
            .padding()
            .background(.bg)
        }
        .ignoresSafeArea()
        .onAppear {
            history.updateAvgScore()
            history.fetchData(from: records)
        }
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
            history.changeTimeUnit_N_currentTimeTextWidth()
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
                .frame(width: history.currentTimeTextWidth)
            
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
    
    var displayOptionPicker: some View {
        Picker("Display Option", selection: $selectedDisplayOption) {
            ForEach(displayOptions.indices, id: \.self) { index in
                Text(displayOptions[index]).tag(index)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(Color(red: 151/255, green: 181/255, blue: 198/255)) // 设置整个Picker的背景色
        .cornerRadius(7)
        .padding()
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
