//
//  HistoryClass.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/12.
//

import Foundation
import Combine
import SwiftData
import SwiftUI

class HistoryModel: ObservableObject{
    @Published var selectedTime: Int = 0
    @Published var selectedPartIndex: Int? = nil
    @Published var currentTime: Date = Date()
    @Published var displayDate: String = ""
    @Published var addTime: Bool = false
    @Published var averageScore: Double = 0
    @Published var currentTimeTextWidth: CGFloat = 60
    
    lazy var calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current  // Ensure the calendar uses the current time zone
        return cal
    }()
    
    @Published var timeUnit: Calendar.Component
    
    @Published var initLineChartData: [DataSeries] = []
    @Published var lineChartData: [DataSeries] = []
    @Published var initPieChartData: [PieDataSeries] = []
    @Published var pieChartData: [PieDataSeries] = []
    

    init(initLineChartData: [DataSeries], initPieChartData: [PieDataSeries], timeUnit: Calendar.Component) {
        self.initLineChartData = initLineChartData
        self.lineChartData = initLineChartData
        self.initPieChartData = initPieChartData
//        self.pieChartData = initPieChartData
        self.timeUnit = timeUnit
        self.currentTime = Date()
        self.selectedTime = 0 // 默认值
        
        // 初始化 pieChartData
               var allCorrectRatios: [RatioData] = []
               var partiallyCorrectRatios: [RatioData] = []

               for series in initPieChartData {
                   for ratioGroup in series.ratios {
                       for ratioData in ratioGroup {
                           switch (series.title, ratioData.title) {
                           case ("Back", "Neutral"),
                                ("Leg", "Flat"),
                                ("Head", "Neutral"),
                                ("Neck", "Neutral"),
                                ("Shoulder", "Neutral"):
                               allCorrectRatios.append(ratioData)
                           default:
                               partiallyCorrectRatios.append(ratioData)
                           }
                       }
                   }
               }

               let totalCount = Double(allCorrectRatios.count + partiallyCorrectRatios.count)
               let allCorrectRatio = Double(allCorrectRatios.count) / totalCount
               let partiallyCorrectRatio = Double(partiallyCorrectRatios.count) / totalCount

               let allCorrectData = RatioData(
                   title: "All Correct",
                   day: Date(),
                   ratio: allCorrectRatio,
                   uiColor: UIColor(Color(red: 0.549, green: 0.875, blue: 0.841))
               )
               
               let partiallyCorrectData = RatioData(
                   title: "Partially Correct",
                   day: Date(),
                   ratio: partiallyCorrectRatio,
                   uiColor: UIColor(Color(red: 0.940, green: 0.503, blue: 0.502))
               )

               self.pieChartData = [
                   PieDataSeries(title: "init", ratios: [[allCorrectData, partiallyCorrectData]])
               ]
        
        updateDisplayDate()
        updateAvgScore()
    }
//    init(averageScore: Double, timeUnit: Calendar.Component, modelContext:ModelContext) {
//        self.averageScore = averageScore
//        self.timeUnit = timeUnit
//        self.modelContext = modelContext
////        self.initLineChartData
////        self.initPieChartData
//        fetchData()
//        updateDisplayDate()
//    }
    func fetchData(from records: [DetectionRecord]){
        self.initLineChartData = createLineChartData(from: records)
        self.initPieChartData = createPieChartData(from: records)
    }
    func createLineChartData(from records: [DetectionRecord]) -> [DataSeries] {
        // init five dataseries for the five body part
        // iterate every record(detection) in query
        // append five part of record to corresponding dataseries
        // 明天就照上面的做
        var lineChartData: [DataSeries] = []

        var headDataSerie = DataSeries(title:"Head", scores: [])
        var neckDataSerie = DataSeries(title:"Neck", scores: [])
        var shoulderDataSerie = DataSeries(title:"Shoulder", scores: [])
        var bodyDataSerie = DataSeries(title:"Back", scores: [])
        var feetDataSerie = DataSeries(title:"Leg", scores: [])
    

        for record in records {
            let time = record.startDetectTimeStamp
            headDataSerie.scores.append(ScoreData(day: time, score: Double(record.head.score)))
            neckDataSerie.scores.append(ScoreData(day: time, score: Double(record.neck.score)))
            shoulderDataSerie.scores.append(ScoreData(day: time, score: Double(record.shoulder.score)))
            bodyDataSerie.scores.append(ScoreData(day: time, score: Double(record.body.score)))
            feetDataSerie.scores.append(ScoreData(day: time, score: Double(record.feet.score)))
        }
        lineChartData = [headDataSerie, neckDataSerie, shoulderDataSerie, bodyDataSerie, feetDataSerie]
//        print(lineChartData)
        return lineChartData
    }

    func createPieChartData(from records: [DetectionRecord]) -> [PieDataSeries] {
        var pieChartData: [PieDataSeries] = [
            PieDataSeries(title: "Back", ratios: []),
            PieDataSeries(title: "Leg", ratios: []),
            PieDataSeries(title: "head", ratios: []),
            PieDataSeries(title: "Neck", ratios: []),
            PieDataSeries(title: "Shoulder", ratios: [])
        ]

        for record in records {
            let time = record.startDetectTimeStamp
            let legData = [
                RatioData(title: "Flat", day: time, ratio: 100*(Double(record.feet.count["Flat", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
                RatioData(title: "Ankle-on-knee", day: time, ratio: 100*(Double(record.feet.count["Ankle-on-knee", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
            ]
            let backData = [
                RatioData(title: "Backward", day: time, ratio: 100*(Double(record.body.count["Backward", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
                RatioData(title: "Forward", day: time, ratio: 100*(Double(record.body.count["Forward", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
                RatioData(title: "Neutral", day: time, ratio: 100*(Double(record.body.count["Neutral", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
            ]
            let headData = [
                RatioData(title: "Bowed", day: time, ratio: 100*(Double(record.head.count["Bowed", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
                RatioData(title: "Neutral", day: time, ratio: 100*(Double(record.head.count["Neutral", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
                RatioData(title: "Tilt Back", day: time, ratio: 100*(Double(record.head.count["Tilt Back", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
            ]
            let neckData = [
                RatioData(title: "Forward", day: time, ratio: 100*(Double(record.neck.count["Forward", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
                RatioData(title: "Neutral", day: time, ratio: 100*(Double(record.neck.count["Neutral", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
            ]
            let shoulderData = [
                RatioData(title: "Hunched", day: time, ratio: 100*(Double(record.shoulder.count["Hunched", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
                RatioData(title: "Neutral", day: time, ratio: 100*(Double(record.shoulder.count["Neutral", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
                RatioData(title: "Shrug", day: time, ratio: 100*(Double(record.shoulder.count["Shrug", default: 0])/Double(record.totalCount)), uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
            ]
            pieChartData[0].ratios.append(backData)
            pieChartData[1].ratios.append(legData)
            pieChartData[2].ratios.append(headData)
            pieChartData[3].ratios.append(neckData)
            pieChartData[4].ratios.append(shoulderData)
        }
        return pieChartData
    }
    func changeTimeUnit_N_currentTimeTextWidth() {
        switch selectedTime {
        case 0:
            timeUnit = .year
            currentTimeTextWidth = 50
        case 1:
            timeUnit = .month
            currentTimeTextWidth = 150
        case 2:
            timeUnit = .weekOfMonth
            currentTimeTextWidth = 210
        case 3:
            timeUnit = .day
            currentTimeTextWidth = 180
        default:
            break
        }
    }
        
    func updateDisplayDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensure locale consistency
        formatter.timeZone = TimeZone.current
        
        switch selectedTime {
        case 1: // Month
            formatter.dateFormat = "MMMM yyyy"
        case 2: // Week
            formatter.dateFormat = "MMM d"
            if let endOfWeek = calendar.date(byAdding: .day, value: 6, to: currentTime) {
                let endOfWeekFormatted = formatter.string(from: endOfWeek)
                formatter.dateFormat = "MMM d, yyyy"
                let startOfWeekFormatted = formatter.string(from: currentTime)
                displayDate = "\(startOfWeekFormatted) - \(endOfWeekFormatted)"
                return
            }
        case 3: // Day
            formatter.dateFormat = "MMMM d, yyyy"
        default:
            formatter.dateFormat = "yyyy"
        }
        displayDate = formatter.string(from: currentTime)
    }

    func touchReduce() {
        switch selectedTime {
        case 1: // Month
            currentTime = calendar.date(byAdding: .month, value: -1, to: currentTime) ?? currentTime
        case 2: // Week
            currentTime = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentTime) ?? currentTime
        case 3: // Day
            currentTime = calendar.date(byAdding: .day, value: -1, to: currentTime) ?? currentTime
        default:
            currentTime = calendar.date(byAdding: .year, value: -1, to: currentTime) ?? currentTime
        }
    }
    
    func touchAdd() {
        let today = Date()
        
        // 檢查年份、月份、週和日是否超過今天
        let currentDateComponents = calendar.dateComponents([.year, .month, .day, .weekOfMonth], from: currentTime)
        let todayComponents = calendar.dateComponents([.year, .month, .day, .weekOfMonth], from: today)
        
        if currentDateComponents.year! < todayComponents.year! ||
            (currentDateComponents.year! == todayComponents.year! && currentDateComponents.month! < todayComponents.month!) ||
            (currentDateComponents.year! == todayComponents.year! && currentDateComponents.month! == todayComponents.month! && currentDateComponents.day! < todayComponents.day!) {
            
            var newDate: Date?
            switch selectedTime {
            case 1: // Month
                newDate = calendar.date(byAdding: .month, value: 1, to: currentTime)
            case 2: // Week
                newDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentTime)
            case 3: // Day
                newDate = calendar.date(byAdding: .day, value: 1, to: currentTime)
            default: // Year
                newDate = calendar.date(byAdding: .year, value: 1, to: currentTime)
            }
            currentTime = newDate!
        }
    }
    
    func checkTimeLimit(){
        let today = Date()
        let currentDateComponents = calendar.dateComponents([.year, .month, .day, .weekOfMonth], from: currentTime)
        let todayComponents = calendar.dateComponents([.year, .month, .day, .weekOfMonth], from: today)
        
//        print("-----")
//        print("current:", currentTime)
//        print("today:", todayComponents.year!)
        
        switch selectedTime {
        case 1: // Month
            if currentDateComponents.year! < todayComponents.year! || (currentDateComponents.year! == todayComponents.year! && currentDateComponents.month! < todayComponents.month!){
                addTime = true
            } else{
                addTime = false
            }
        case 2: // Week
            if currentDateComponents.year! <= todayComponents.year! && currentDateComponents.month! <= todayComponents.month! && currentDateComponents.weekOfMonth! < todayComponents.weekOfMonth!{
                addTime = true
            } else{
                addTime = false
            }
        case 3: // Day
            if currentDateComponents.year! < todayComponents.year! || (currentDateComponents.year! == todayComponents.year! && currentDateComponents.month! < todayComponents.month!) || (currentDateComponents.year! == todayComponents.year! && currentDateComponents.month! == todayComponents.month! && currentDateComponents.day! < todayComponents.day!){
                addTime = true
            } else{
                addTime = false
            }
        default: // Year
            if currentDateComponents.year! < todayComponents.year!{
                addTime = true
            } else{
                addTime = false
            }
        }
//        print("addTime: ", addTime)
    }
    
    func updateAvgScore(){
        let components = calendar.dateComponents([.year, .month, .weekOfMonth, .day], from: currentTime)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let week = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        
        switch self.selectedTime{
        case 0:
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: year) ?? 0
        case 1:
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: year, month: month) ?? 0
        case 2:
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: year, month: month, weekOfMonth: week) ?? 0
        case 3:
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: year, month: month, day: day) ?? 0
        default:
            break
        }
    }
    
    func averageScoreForPeriod(data: [DataSeries], year: Int? = nil, month: Int? = nil, weekOfMonth: Int? = nil, day: Int? = nil) -> Double? {
        let calendar = Calendar.current
        var filteredScores: [Double] = []
        
        for series in data {
            for scoreData in series.scores {
                let dateComponents = calendar.dateComponents([.year, .month, .weekOfMonth, .day], from: scoreData.day)
                
                if (year == nil || dateComponents.year == year) &&
                   (month == nil || dateComponents.month == month) &&
                   (weekOfMonth == nil || dateComponents.weekOfMonth == weekOfMonth) &&
                   (day == nil || dateComponents.day == day) {
                    filteredScores.append(scoreData.score)
                }
            }
        }
        
        guard !filteredScores.isEmpty else { return nil }
        
        let totalScore = filteredScores.reduce(0, +)
        let averageScore = totalScore / Double(filteredScores.count)
        
//        print(averageScore)
        return averageScore
    }
    
    func generateAllPartPieChartData(from data: [PieDataSeries]) -> [PieDataSeries] {
        var allCorrectRatios: [RatioData] = []
        var partiallyCorrectRatios: [RatioData] = []

        for series in data {
            for ratioGroup in series.ratios {
                for ratioData in ratioGroup {
                    switch (series.title, ratioData.title) {
                    case ("Back", "Neutral"),
                         ("Leg", "Flat"),
                         ("Head", "Neutral"),
                         ("Neck", "Neutral"),
                         ("Shoulder", "Neutral"):
                        allCorrectRatios.append(ratioData)
                    default:
                        partiallyCorrectRatios.append(ratioData)
                    }
                }
            }
        }

        let totalCount = Double(allCorrectRatios.count + partiallyCorrectRatios.count)
        let allCorrectRatio = Double(allCorrectRatios.count) / totalCount
        let partiallyCorrectRatio = Double(partiallyCorrectRatios.count) / totalCount

        let allCorrectData = RatioData(
            title: "All Correct",
            day: Date(),
            ratio: allCorrectRatio,
            uiColor: UIColor(Color(red: 0.549, green: 0.875, blue: 0.841))
        )
        
        let partiallyCorrectData = RatioData(
            title: "Partially Correct",
            day: Date(),
            ratio: partiallyCorrectRatio,
            uiColor: UIColor(Color(red: 0.940, green: 0.503, blue: 0.502))
        )

        return [
            PieDataSeries(title: "init", ratios: [[allCorrectData, partiallyCorrectData]])
        ]
    }

    
    func filterDataByCurrentTime() {
        let calendar = Calendar.current
        let startDate: Date
        let endDate: Date

        switch selectedTime {
        case 0: // Year
            startDate = calendar.dateInterval(of: .year, for: currentTime)?.start ?? currentTime
            endDate = calendar.dateInterval(of: .year, for: currentTime)?.end ?? currentTime
        case 1: // Month
            startDate = calendar.dateInterval(of: .month, for: currentTime)?.start ?? currentTime
            endDate = calendar.dateInterval(of: .month, for: currentTime)?.end ?? currentTime
        case 2: // Week
            startDate = calendar.dateInterval(of: .weekOfMonth, for: currentTime)?.start ?? currentTime
            endDate = calendar.dateInterval(of: .weekOfMonth, for: currentTime)?.end ?? currentTime
        case 3: // Day
            startDate = calendar.startOfDay(for: currentTime)
            endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? currentTime
        default:
            startDate = currentTime
            endDate = currentTime
        }


        pieChartData = initPieChartData.map { series in
            let filteredRatios = series.ratios.map { ratioArray in
                ratioArray.filter { ratio in
                    ratio.day >= startDate && ratio.day < endDate
                }
            }.filter { !$0.isEmpty }
            return PieDataSeries(title: series.title, ratios: filteredRatios)
        }
        
        lineChartData = initLineChartData.map { series in
            let filteredScores = series.scores.filter { score in
                score.day >= startDate && score.day < endDate
            }
            return DataSeries(title: series.title, scores: filteredScores)
        }
    }

    
    func updateChartData(){
        switch self.selectedPartIndex {
        case 0:
            self.pieChartData = pieChartData.filter { $0.title == "Head" }
            self.lineChartData = self.lineChartData.filter { $0.title == "Head" }
        case 1:
            self.pieChartData = pieChartData.filter { $0.title == "Neck" }
            self.lineChartData = self.lineChartData.filter { $0.title == "Neck" }
        case 2:
            self.pieChartData = pieChartData.filter { $0.title == "Shoulder" }
            self.lineChartData = self.lineChartData.filter { $0.title == "Shoulder" }
        case 3:
            self.pieChartData = pieChartData.filter { $0.title == "Back" }
            self.lineChartData = self.lineChartData.filter { $0.title == "Back" }
        case 4:
            self.pieChartData = pieChartData.filter { $0.title == "Leg" }
            self.lineChartData = self.lineChartData.filter { $0.title == "Leg" }
        // Add cases for other body parts
        default:
            self.pieChartData = generateAllPartPieChartData(from: pieChartData)
            self.lineChartData = self.lineChartData
        }
//        print(self.lineChartData)
    }
//    self.pieChartData = aggregateData()
}

