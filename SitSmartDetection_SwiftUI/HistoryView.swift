//
//  HistoryView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/5.
//

import SwiftUI
import SwiftData
import TipKit

// 主視圖
struct HistoryView: View {
    @EnvironmentObject private var historyVM: HistoryViewModel

    @State private var timePeriods = ["Year", "Month", "Week", "Day"]
    @State private var parts = ["Head", "Neck", "Shoulder", "Back", "Leg"]
    @State private var selectedTime = 0
    @State private var maxTextWidth: CGFloat = 0
    @State private var displayOptions = ["Trend Score", "Accuracy Distribution"]
    @State private var selectedDisplayOption = 0
    private let emojiSize: CGFloat = 45
    
    var touchLandmarkTip = TouchLandmarkTip()
    var touchToAllLandmarkTip = TouchToAllLandmarkTip()
    
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
                VStack(spacing: 13) {
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
                Spacer()
                    .frame(height: 5)
                displayOptionPicker
                if selectedDisplayOption == 0 {
                    HistoryLineChart(lineChart: $historyVM.lineChart)
                } else {
                    HistoryPieChart(pieChart: $historyVM.pieChart)
//                    if !history.pieChartData.isEmpty {
//                        HistoryPieChart(pieChart: PieChart(data: history.pieChartData, timeUnit: history.timeUnit))
//                    } else {
//                        Text("No data available")
//                            .foregroundColor(.gray)
//                    }
                }
            }
            .padding()
        }
        .background(.bg)
        .ignoresSafeArea()
        .onAppear {
            historyVM.updateAvgScore()
            historyVM.fetchData()
        }
    }
    
    struct GraySemicircleBackgroundView: View {
        var body: some View {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height * 0.9))  // 定义半圆的底部起点
                    path.addCurve(to: CGPoint(x: width, y: height * 0.9), control1: CGPoint(x: width / 3, y: 275), control2: CGPoint(x: 2 * width / 3, y: 275))
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.addLine(to: CGPoint(x: 0, y: height))
                }
                .fill(.bg)
            }
            .frame(height: 360)  // 根据需要调整高度
        }
    }
    
    var timeSelectionView: some View {
        Picker("Select Time", selection: $historyVM.selectedTime) {
            ForEach(timePeriods, id: \.self) { period in
                Text(period).tag(timePeriods.firstIndex(of: period)!)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(Color(red: 151/255, green: 181/255, blue: 198/255)) // 设置整个Picker的背景色
        .cornerRadius(7)
        .onChange(of: historyVM.selectedTime) { _, _ in
            historyVM.updateDisplayDate()
            historyVM.changeTimeUnit_N_currentTimeTextWidth()
            historyVM.checkTimeLimit()
            historyVM.filterDataByCurrentTime()
            historyVM.updateChartData()
            historyVM.updateAvgScore()
        }
        .padding()
    }
    
    var currentTime: some View {
        HStack {
            Spacer()
            
            Button {
                historyVM.touchReduce()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
//            .frame(width: maxTextWidth)
            
            Text("\(historyVM.displayDate)")
                .font(.title3)
                .foregroundStyle(Color.white)
                .frame(width: historyVM.currentTimeTextWidth)
            
            Button {
                historyVM.touchAdd()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .imageScale(.large)
                    .opacity(historyVM.addTime == true ? 1.0 : 0.5)
            }
//            .frame(width: maxTextWidth)
            
            Spacer()
        }
        .onChange(of: historyVM.currentTime) { _, _ in
            historyVM.updateDisplayDate()
            historyVM.checkTimeLimit()
            historyVM.filterDataByCurrentTime()
            historyVM.updateChartData()
            historyVM.updateAvgScore()
        }
    }
    
    var scoreDisplay: some View {
        Text("\(Int(historyVM.averageScore))")
            .font(.system(size: 100))
            .bold()
            .foregroundStyle(Color.white)
    }
    
    var emojiWithScore: some View {
        if historyVM.averageScore < 60 {
            return AnyView(Image("bad")
                .resizable()
                .frame(width: emojiSize, height: emojiSize))
        } else if historyVM.averageScore < 80 {
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
            Text(historyVM.selectedPartIndex == nil ? "All Body Parts" : parts[historyVM.selectedPartIndex!])
                .font(.title3)
                .foregroundStyle(Color.gray)
//                .bold()
//            TipView(touchLandmarkTip, arrowEdge: .bottom)
            HStack(spacing: 6) {
                ForEach(parts.indices, id: \.self) { index in
                    Button(action: {
                        if(historyVM.selectedPartIndex == index){
                            historyVM.selectedPartIndex = nil
                        }else{
                            historyVM.selectedPartIndex = index  // Update selected index on tap
                        }
                        historyVM.filterDataByCurrentTime()
                        historyVM.updateChartData()
                        historyVM.updateAvgScore()
                        touchLandmarkTip.invalidate(reason: .actionPerformed)
                        TouchToAllLandmarkTip.hasTouchedButton = true
                    }) {
                        Image(parts[index])  // Assume image names match the parts array
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .padding(7)
                            .background(Circle().fill(Color(red: 178/255, green: 206/255, blue: 222/255)))
                            .opacity(historyVM.selectedPartIndex == nil ? 1.0 : (historyVM.selectedPartIndex == index ? 1.0 : 0.5))
                    }
                }
            }
            .popoverTip(touchLandmarkTip, arrowEdge: .leading)
            .popoverTip(touchToAllLandmarkTip, arrowEdge: .leading)
        }
    }
    
    struct TouchLandmarkTip: Tip {
        var title: Text {
            Text("Touch")
        }
        var message: Text? {
            Text("View the different body parts results")
        }
        var image: Image? {
            Image(systemName: "hand.point.up.left")
        }
    }
    
    struct TouchToAllLandmarkTip: Tip {
        var title: Text {
            Text("Touch Again")
        }
        var message: Text? {
            Text("View the all body parts results")
        }
        var image: Image? {
            Image(systemName: "hand.point.up.left")
        }
        
        var rules: [Rule] {
            #Rule(Self.$hasTouchedButton) { $0 == true }
        }
        @Parameter
        static var hasTouchedButton: Bool = false
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
            .task {
                try? Tips.resetDatastore()
                
                try? Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault)
                ])
            }
    }
}
