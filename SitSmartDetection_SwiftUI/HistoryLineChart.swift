//
//  HistoryLineChart.swift
//  SitSmartDetection
//
//  Created by 詹採晴 on 2024/4/20.
//

import SwiftUI
import Charts

struct ScoreData: Identifiable {
    let id = UUID()
    let day: Date
    let score: Double
}

struct DataSeries: Identifiable {
    let id = UUID()
    let title: String
    let scores: [ScoreData]
}

//struct HistoryLineChart: View {
//    var data: [DataSeries]
//    var timeUnit: Calendar.Component
//
//    // State to handle the selected date
//    @State private var selectedDate: Date? = nil
//    @State private var rawSelectedDate: Date? = nil
//
//    var body: some View {
//        Chart {
//            ForEach(data) { series in
//                ForEach(series.scores.groupedBy(timeUnit)) { element in
//                    LineMark(
//                        x: .value("Time", element.day, unit: timeUnit),
//                        y: .value("Score", element.aggregateScore)
//                    )
//                }
//                .foregroundStyle(by: .value("Body Parts", series.title))
//                .symbol(by: .value("Body Parts", series.title))
//                .interpolationMethod(.catmullRom)
//            }
//            if let selected = selectedDate {
//                RuleMark(
//                    x: .value("Selected", selected, unit: .day)
//                )
//                .foregroundStyle(Color.gray.opacity(0.3))
//                .offset(yStart: -10)
//                .zIndex(-1)
//                .annotation(
//                    position: .top, spacing: 0,
//                    overflowResolution: .init(
//                        x: .fit(to: .chart),
//                        y: .disabled
//                    )
//                ) {
//                    valueSelectionPopover(selectedDate: selected)
//                }
//            }
//        }
//        .chartXSelection(value: $rawSelectedDate)
//        .onChange(of: rawSelectedDate) { oldValue, newValue in
//            selectedDate = newValue
//        }
//    }
//
//    private func aggregateScores(for timeUnit: Calendar.Component, scores: [ScoreData]) -> [ScoreData] {
//        let groupedScores = scores.groupedBy(timeUnit)
//        var aggregatedScores: [ScoreData] = []
//
//        for (date, scoreDatas) in groupedScores {
//            let totalScore = scoreDatas.map { $0.score }.reduce(0, +)  // Sum of scores
//            let averageScore = totalScore / Double(scoreDatas.count)   // Average score
//            let aggregatedScoreData = ScoreData(day: date, score: averageScore)
//            aggregatedScores.append(aggregatedScoreData)
//        }
//
//        return aggregatedScores.sorted { $0.day < $1.day }  // Sort by date for proper charting
//    }
//
//    @ViewBuilder
//    private func valueSelectionPopover(selectedDate: Date) -> some View {
//        Text("Score: \(data.first(where: { $0.scores.contains(where: { $0.day == selectedDate }) })?.scores.first(where: { $0.day == selectedDate })?.score ?? 0)")
//            .padding()
//            .background(Color.white)
//            .cornerRadius(5)
//            .shadow(radius: 3)
//    }
//}
//
//// Formatter for the date
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    return formatter
//}()
//
//extension Array where Element == ScoreData {
//    func groupedBy(_ component: Calendar.Component) -> [Date: [ScoreData]] {
//        let calendar = Calendar.current
//        let groupedDictionary = Dictionary(grouping: self) { (element) -> Date in
//            let date = calendar.startOfDay(for: element.day)
//            return calendar.dateInterval(of: component, for: date)?.start ?? date
//        }
//        return groupedDictionary
//    }
//}



struct HistoryLineChart: View {
    var data: [DataSeries]
    var timeUnit: Calendar.Component

    @State private var selectedDate: Date? = nil
    @State private var rawSelectedDate: Date? = nil

    var body: some View {
        Chart {
            ForEach(data) { series in
                ForEach(aggregateScores(for: timeUnit, scores: series.scores), id: \.day) { scoreData in
                    LineMark(
                        x: .value("Time", scoreData.day, unit: timeUnit),
                        y: .value("Score", scoreData.score)
                    )
                    .foregroundStyle(by: .value("Body Parts", series.title))
                    .symbol(by: .value("Body Parts", series.title))
                    .interpolationMethod(.catmullRom)
                }
            }
            if let selected = selectedDate {
                RuleMark(
                    x: .value("Selected Date", selected)
                )
                .foregroundStyle(Color.gray.opacity(0.3))
                .offset(yStart: -10)
                .zIndex(-1)
                .annotation(position: .top, spacing: 0) {
                    Text("Selected Score: \(selectedScoreText(for: selected))")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 3)
                }
            }
        }
        .chartXSelection(value: $rawSelectedDate)
        .onChange(of: rawSelectedDate) { oldValue, newValue in
            selectedDate = newValue
        }
    }
    
    private func aggregateScores(for timeUnit: Calendar.Component, scores: [ScoreData]) -> [ScoreData] {
        let groupedScores = scores.groupedBy(timeUnit)
        var aggregatedScores: [ScoreData] = []

        for (date, scoreDatas) in groupedScores {
            let totalScore = scoreDatas.map { $0.score }.reduce(0, +)
            let averageScore = totalScore / Double(scoreDatas.count)
            let aggregatedScoreData = ScoreData(day: date, score: averageScore)
            aggregatedScores.append(aggregatedScoreData)
        }

        return aggregatedScores.sorted { $0.day < $1.day }
    }
    
    private func selectedScore(for selectedDate: Date) -> Double {
        let calendar = Calendar.current
        // 確保 startDate 調整到正確的聚合單位
        let startDate = calendar.dateInterval(of: timeUnit, for: selectedDate)?.start ?? calendar.startOfDay(for: selectedDate)

        // 尋找匹配的日期
        for series in data {
            for scoreData in series.scores {
                if calendar.isDate(scoreData.day, equalTo: startDate, toGranularity: timeUnit) {
                    print("score", scoreData.day)
                    return scoreData.score
                }
//                print("selectedDate", selectedDate)
                
            }
        }
        
        return 0 // 如果沒有找到匹配的日期，返回0
    }
    
    private func selectedScoreText(for selectedDate: Date) -> String {
        let score = selectedScore(for: selectedDate)
        return String(format: "%.2f", score)
    }
}

extension Array where Element == ScoreData {
    func groupedBy(_ component: Calendar.Component) -> [Date: [ScoreData]] {
        let calendar = Calendar.current
        let groupedDictionary = Dictionary(grouping: self) { (element) -> Date in
            let date = calendar.startOfDay(for: element.day)
            return calendar.dateInterval(of: component, for: date)?.start ?? date
        }
        return groupedDictionary
    }
}
