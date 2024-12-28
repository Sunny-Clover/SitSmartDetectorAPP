//
//  HistoryViewModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/9/4.
//
import Foundation
import Combine
import SwiftData
import SwiftUI

class HistoryViewModel: ObservableObject {

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
    
    // DataSource for chart in view
    @Published var lineChart: LineChart = LineChart(data: [], timeUnit: .year)
    @Published var pieChart: PieChart = PieChart(data: [], timeUnit: .year)
    @Published var overallPieChart: PieChart = PieChart(data: [], timeUnit: .year)
    
    // Pure data from backend(db)
    @Published var initLineChartData: [DataSeries] = []
    @Published var initPieChartData: [PieDataSeries] = []
    
    // Filtered data from pure data
    @Published var lineChartData: [DataSeries] = []
    @Published var pieChartData: [PieDataSeries] = []
    @Published var overallPieChartData: [PieDataSeries] = []
    
    private var records:[RecordResponse] = []
    private var requestFailedCount = 0
    private let maxRetryTimes = 3
    private var recordService = RecordService()
    private let tokenService = TokenService()
    
    init(/*initLineChartData: [DataSeries], initPieChartData: [PieDataSeries],*/ timeUnit: Calendar.Component) {
//        self.initLineChartData = initLineChartData
//        self.lineChartData = initLineChartData
//        self.initPieChartData = initPieChartData
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

       let allCorrectRatio = allCorrectRatios.count
       let partiallyCorrectRatio = partiallyCorrectRatios.count

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
    func fetchData(/*from records: [DetectionRecord]*/){
//        self.initLineChartData = createLineChartData(from: records)
//        self.initPieChartData = createPieChartData(from: records)
//        
        guard let token = self.tokenService.retrieveToken(for: .accessToken) else { return }
        self.recordService.fetchRecords(token: token){ [weak self] result in
            switch result {
            case .success(let records):
                DispatchQueue.main.async {
                    self?.initLineChartData = records.toLineChartData()
                    self?.initPieChartData = records.toPieChartData()
                    self?.filterDataByCurrentTime()
                    self?.updateChartData()
                    self?.updateAvgScore()
                }
            case .failure(let error):
                // TODO: 還未完成
                // token expire(?
                guard var count = self?.requestFailedCount else { return }
                guard let maxRetryTimes = self?.maxRetryTimes else { return }
                count += 1
                self?.requestFailedCount = count

                if(count < maxRetryTimes){
                    self?.refreshToken()
                    self?.fetchData()
                }
            }
        }
//        print(self.initPieChartData.filter { $0.title == "Head" })
        
    }
    
    func refreshToken(){
        self.tokenService.refreshToken { result in
            // Should make sure cover all .failure cases
            switch result{
            case .success():
                print("Sucessfully auto refresh token")
            case .failure(let error):
                print("Refresh token failed: \(error)")
            }
        }
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
//            print("1, \(Date().formatted(.dateTime.hour().minute().second()))")
        case 1:
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: year, month: month) ?? 0
        case 2:
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: year, month: month, weekOfMonth: week) ?? 0
        case 3:
            self.averageScore = averageScoreForPeriod(data: lineChartData, year: year, month: month, day: day) ?? 0
        default:
//            print("4, \(Date().formatted(.dateTime.hour().minute().second()))")
            break
        }
//        print("Updated score \(self.averageScore)")
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
        let averageScore = Double(totalScore) / Double(filteredScores.count)
        
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
        print("allCorrectRatios:", allCorrectRatios)
        print("partiallyCorrectRatios", partiallyCorrectRatios)
        let allCorrectRatio = allCorrectRatios.count
        let partiallyCorrectRatio = partiallyCorrectRatios.count

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
        updateChartSrc()
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
        default:
            self.pieChartData = generateAllPartPieChartData(from: pieChartData)
            self.lineChartData = self.lineChartData
        }
        updateChartSrc()
//        print(self.lineChartData)
//        print(self.pieChartData)
//        print("-------------------------------------------")
    }
    
    func updateChartData_ReportView(){
        switch self.selectedPartIndex {
        case 0:
            self.pieChartData = initPieChartData.filter { $0.title == "Head" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Head" }
        case 1:
            self.pieChartData = initPieChartData.filter { $0.title == "Neck" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Neck" }
        case 2:
            self.pieChartData = initPieChartData.filter { $0.title == "Shoulder" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Shoulder" }
        case 3:
            self.pieChartData = initPieChartData.filter { $0.title == "Back" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Back" }
        case 4:
            self.pieChartData = initPieChartData.filter { $0.title == "Leg" }
            self.lineChartData = self.initLineChartData.filter { $0.title == "Leg" }
        default:
            self.pieChartData = generateAllPartPieChartData(from: pieChartData)
            self.lineChartData = self.initLineChartData
        }
    }
    
    private func updateChartSrc(){
        self.lineChart = LineChart(data: self.lineChartData, timeUnit: self.timeUnit)
        self.pieChart = PieChart(data: self.pieChartData, timeUnit: self.timeUnit)
        self.overallPieChart = PieChart(data: self.pieChartData, timeUnit: self.timeUnit)
    }
}



extension Array where Element == RecordResponse {
    func convertToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: dateString)
    }

    func toLineChartData() -> [DataSeries] {
        var headScores: [ScoreData] = []
        var neckScores: [ScoreData] = []
        var shoulderScores: [ScoreData] = []
        var bodyScores: [ScoreData] = []
        var feetScores: [ScoreData] = []

        for record in self {
            guard let time = convertToDate(record.startTime) else {
                print("Warning: Failed to parse date string: \(record.startTime)")
                continue
            }

            let headScore = Double(record.head.neutralCount) / Double(record.totalPredictions)
            let neckScore = Double(record.neck.neutralCount) / Double(record.totalPredictions)
            let shoulderScore = Double(record.shoulder.neutralCount) / Double(record.totalPredictions)
            let bodyScore = Double(record.body.neutralCount) / Double(record.totalPredictions)
            let feetScore = Double(record.feet.flatCount) / Double(record.totalPredictions)

            // *100: 0.xx -> xx %
            headScores.append(ScoreData(day: time, score: headScore*100))
            neckScores.append(ScoreData(day: time, score: neckScore*100))
            shoulderScores.append(ScoreData(day: time, score: shoulderScore*100))
            bodyScores.append(ScoreData(day: time, score: bodyScore*100))
            feetScores.append(ScoreData(day: time, score: feetScore*100))
        }

        return [
            DataSeries(title: "Head", scores: headScores),
            DataSeries(title: "Neck", scores: neckScores),
            DataSeries(title: "Shoulder", scores: shoulderScores),
            DataSeries(title: "Back", scores: bodyScores),
            DataSeries(title: "Leg", scores: feetScores)
        ]
    }

    func toPieChartData() -> [PieDataSeries] {
        var backData: [[RatioData]] = []
        var legData: [[RatioData]] = []
        var headData: [[RatioData]] = []
        var neckData: [[RatioData]] = []
        var shoulderData: [[RatioData]] = []

        for record in self {
            guard let time = convertToDate(record.startTime) else {
                print("Warning: Failed to parse date string: \(record.startTime)")
                continue
            }

//            let totalCount = Double(record.totalPredictions)

            backData.append([
                RatioData(title: "Backward", day: time, ratio: record.body.backwardCount, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
                RatioData(title: "Forward", day: time, ratio: record.body.forwardCount, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
                RatioData(title: "Neutral", day: time, ratio: record.body.neutralCount, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
            ])

            legData.append([
                RatioData(title: "Ankle-on-knee", day: time, ratio: record.feet.ankleOnKneeCount, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
                RatioData(title: "Flat", day: time, ratio: record.feet.flatCount, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1))
            ])

            headData.append([
                RatioData(title: "Bowed", day: time, ratio: record.head.bowedCount, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
                RatioData(title: "Neutral", day: time, ratio: record.head.neutralCount, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
                RatioData(title: "Tilt Back", day: time, ratio: record.head.tiltBackCount, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
            ])

            neckData.append([
                RatioData(title: "Forward", day: time, ratio: record.neck.forwardCount, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
                RatioData(title: "Neutral", day: time, ratio: record.neck.neutralCount, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
            ])

            shoulderData.append([
                RatioData(title: "Hunched", day: time, ratio: record.shoulder.hunchedCount, uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
                RatioData(title: "Neutral", day: time, ratio: record.shoulder.neutralCount, uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
                RatioData(title: "Shrug", day: time, ratio: record.shoulder.shrugCount, uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
            ])
        }

        return [
            PieDataSeries(title: "Back", ratios: backData),
            PieDataSeries(title: "Leg", ratios: legData),
            PieDataSeries(title: "Head", ratios: headData),
            PieDataSeries(title: "Neck", ratios: neckData),
            PieDataSeries(title: "Shoulder", ratios: shoulderData)
        ]
    }
}
