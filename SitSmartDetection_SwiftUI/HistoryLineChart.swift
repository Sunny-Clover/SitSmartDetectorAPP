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
    var scores: [ScoreData]
}

struct LineChart: Identifiable{
    let id = UUID()
    var data: [DataSeries]
    var timeUnit: Calendar.Component
}

struct HistoryLineChart: View {
//    var data: [DataSeries]
//    var timeUnit: Calendar.Component
    
    let lineChart: LineChart
    @State private var selectedDate: Date? = nil
    @State private var rawSelectedDate: Date? = nil

    var body: some View {
        VStack {
//            HStack {
//                Spacer()
//                Text("Trend Score")
//                    .foregroundStyle(Color.gray)
//                .bold()
//                Spacer()
//            }
            Chart {
                ForEach(lineChart.data) { series in
                    ForEach(aggregateScores(for: lineChart.timeUnit, scores: series.scores), id: \.day) { scoreData in
                        LineMark(
                            x: .value("Time", scoreData.day, unit: lineChart.timeUnit),
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
            .frame(height: 200)
            .shadow(radius: 10)
            Spacer()
                .frame(height: 30)
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
        let startDate = calendar.dateInterval(of: lineChart.timeUnit, for: selectedDate)?.start ?? calendar.startOfDay(for: selectedDate)

        // 尋找匹配的日期
        for series in lineChart.data {
            for scoreData in series.scores {
                if calendar.isDate(scoreData.day, equalTo: startDate, toGranularity: lineChart.timeUnit) {
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

extension LineChart{
    static let demoLineChart = LineChart(data: lineChartDataDummy, timeUnit: .year)
}

struct HistoryLineChart_Previews: PreviewProvider {
    static var previews: some View {
        HistoryLineChart(lineChart: .demoLineChart)
    }
}
