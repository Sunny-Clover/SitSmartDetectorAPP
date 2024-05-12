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
    @Published var currentTime: Int
    @Published var averageScore: Double
    
    // Make the calendar a lazy property so it is not initialized until it's actually accessed
    lazy var calendar: Calendar = {
        return Calendar.current
    }()
    
    @Published var timeUnit: Calendar.Component
    // Define the time properties as lazy to ensure they are not accessed until needed
    lazy var currentYear: Int = calendar.component(.year, from: Date())
    lazy var currentMonth: Int = calendar.component(.month, from: Date())
    lazy var currentWeekOfMonth: Int = calendar.component(.weekOfMonth, from: Date())
    lazy var currentDay: Int = calendar.component(.day, from: Date())
    
    lazy var selectYear: Int = currentYear
    lazy var selectMonth: Int = currentMonth
    lazy var selectWeekOfMonth: Int = currentWeekOfMonth
    lazy var selectDay: Int = currentDay
    
    @Published var initLineChartData: [DataSeries] = []
    @Published var lineChartData: [DataSeries] = []
    @Published var initPieChartData: [PieDataSeries] = []
    @Published var pieChartData: [PieDataSeries] = []
    

    init(currentTime: Int, averageScore: Double, initLineChartData: [DataSeries], initPieChartData: [PieDataSeries], timeUnit: Calendar.Component) {
        self.currentTime = currentTime
        self.averageScore = averageScore
        self.initLineChartData = initLineChartData
        self.lineChartData = initLineChartData
        self.initPieChartData = initPieChartData
        self.pieChartData = initPieChartData
        self.timeUnit = timeUnit
    }
    
    func updateTime(with newTime: Int) {
        currentTime = newTime
    }

    func updatePartIndex(with newIndex: Int?) {
        selectedPartIndex = newIndex
    }
    
    func touchTimeSegment() {
        switch self.selectedTime {
        case 0:
            self.currentTime = currentYear
            self.timeUnit = .year
        case 1:
            self.currentTime = currentMonth
            self.timeUnit = .month
        case 2:
            self.currentTime = currentWeekOfMonth
            self.timeUnit = .weekOfMonth
        case 3:
            self.currentTime = currentDay
            self.timeUnit = .day
        default:
            break
        }
    }
    
    func touchReduce() {
        let currentTime = self.currentTime
        let newTime = max(currentTime - 1, 1) // 减去1但不小於0
        self.currentTime = newTime
    }
    
    func touchAdd(){
        var currentWhich = 0
        switch self.selectedTime{
        case 0:
            currentWhich = currentYear
        case 1:
            currentWhich = currentMonth
        case 2:
            currentWhich = currentWeekOfMonth
        case 3:
            currentWhich = currentDay
        default:
            break
        }
        
        let currentTime = Int(self.currentTime)
        let newTime = currentTime + 1  // Attempt to add 1 to the current time
        if newTime <= currentWhich {
            self.currentTime = newTime
        } else {
            print("The year cannot exceed the current year.")
            self.currentTime = currentWhich
        }
    }
    
    func updateAvgScore(){
        switch self.selectedTime{
        case 0:
            selectYear = self.currentTime
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: self.selectYear) ?? 0
        case 1:
            selectMonth = self.currentTime
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: self.selectYear, month: self.selectMonth) ?? 0
        case 2:
            selectWeekOfMonth = self.currentTime
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: self.selectYear, month: self.selectMonth, weekOfMonth: self.selectWeekOfMonth) ?? 0
        case 3:
            selectDay = self.currentTime
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: self.selectYear, month: self.selectMonth, day: self.selectDay) ?? 0
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
        
        print(averageScore)
        return averageScore
    }
    
    func updateChart(){
        switch self.selectedPartIndex {
        case 0:
            self.pieChartData = self.initPieChartData.filter { $0.title == "Head" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Head" }
        case 1:
            self.pieChartData = self.initPieChartData.filter { $0.title == "Neck" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Neck" }
        case 2:
            self.pieChartData = self.initPieChartData.filter { $0.title == "Shoulder" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Shoulder" }
        case 3:
            self.pieChartData = self.initPieChartData.filter { $0.title == "Back" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Back" }
        case 4:
            self.pieChartData = self.initPieChartData.filter { $0.title == "Leg" }
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

