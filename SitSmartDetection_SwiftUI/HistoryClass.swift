//
//  HistoryClass.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 詹採晴 on 2024/5/12.
//

import Foundation

class HistoryModel: ObservableObject{
    @Published var selectedTime: Int = 0
    @Published var selectedPartIndex: Int? = nil
    @Published var currentTime: Date = Date()
    @Published var displayDate: String = ""
    @Published var addTime: Bool = false
    @Published var averageScore: Double
    
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
    

    init(averageScore: Double, initLineChartData: [DataSeries], initPieChartData: [PieDataSeries], timeUnit: Calendar.Component) {
        self.averageScore = averageScore
        self.initLineChartData = initLineChartData
        self.lineChartData = initLineChartData
        self.initPieChartData = initPieChartData
        self.pieChartData = initPieChartData
        self.timeUnit = timeUnit
        updateDisplayDate()
    }
    
    func changeTimeUnit() {
        switch selectedTime {
        case 0:
            timeUnit = .year
        case 1:
            timeUnit = .month
        case 2:
            timeUnit = .weekOfMonth
        case 3:
            timeUnit = .day
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
        updateDisplayDate()
        checkTimeLimit()
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
            updateDisplayDate()
            checkTimeLimit()
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
    
    func updateChartData(){
        switch self.selectedPartIndex {
        case 0:
            self.pieChartData = initNoneFilteredPieChartData.filter { $0.title == "Head" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Head" }
        case 1:
            self.pieChartData = initNoneFilteredPieChartData.filter { $0.title == "Neck" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Neck" }
        case 2:
            self.pieChartData = initNoneFilteredPieChartData.filter { $0.title == "Shoulder" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Shoulder" }
        case 3:
            self.pieChartData = initNoneFilteredPieChartData.filter { $0.title == "Back" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Back" }
        case 4:
            self.pieChartData = initNoneFilteredPieChartData.filter { $0.title == "Leg" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Leg" }
        // Add cases for other body parts
        default:
            self.pieChartData = [
                PieDataSeries(title: "init", ratios: [
                    RatioData(
                        title: "All Correct",
                        day: Date(timeIntervalSince1970: 1711309674.574878),
                        ratio: 0.6,
                        uiColor: #colorLiteral(red: 0.5488034487, green: 0.8750266433, blue: 0.8405518532, alpha: 1)
                    ),
                    RatioData(
                        title: "Partially Correct",
                        day: Date(timeIntervalSince1970: 1711396074.574878),
                        ratio: 0.4,
                        uiColor: #colorLiteral(red: 0.9399127364, green: 0.5029041767, blue: 0.5018365979, alpha: 1)
                    )
                ])
            ]
            self.lineChartData = self.initLineChartData
        }
//        print(self.lineChartData)
    }
}

