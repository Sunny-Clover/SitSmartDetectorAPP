//
//  DetectionViewModel.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/7/27.
//

import Foundation
import SwiftUI
import Combine

class DetectionViewModel: ObservableObject {
    // observe data from UserService
    var user: UserResponse? = nil
    
    // For the detection results
    @Published var headResult = ResultData(icon: "headIcon", bodyPartName: "Head", result: nil, postureType: nil)
    @Published var neckResult = ResultData(icon: "neckIcon", bodyPartName: "Neck", result: nil, postureType: nil)
    @Published var shoulderResult = ResultData(icon: "shoulderIcon", bodyPartName: "Shoulder", result: nil, postureType: nil)
    @Published var backResult = ResultData(icon: "backIcon", bodyPartName: "Back", result: nil, postureType: nil)
    @Published var legResult = ResultData(icon: "legIcon", bodyPartName: "Leg", result: nil, postureType: nil)
    
    // observing the camera
    @ObservedObject var cameraManager = CameraManager()
    
    // var to be observed by view
    @Published var cameraImage: CGImage? // Realtime detection image
    // @Published var person: Person? // Movenet Detection results 目前View還不需要這個變數
    @Published var classifiedReslt:[String:[Float32]]? // Pose classification results from
    @Published var isDetecting = false // for UIButton

    // Cancellable storage for Combine subscribers.
    private var cancellables = Set<AnyCancellable>()
    private var isBound = false
    
    private var AccClassProbs = ["Head": [Float32](), "Neck": [Float32](), "Shoulder": [Float32](), "Body":[Float32](), "Feet":[Float32]()]
    
    private var record: DetectionRecord // 每個部位的姿勢計數
    private var warningManager = WarningManager() // TODO: Init by real user setting
    private var recordService = RecordService()
    private let tokenService = TokenService()
    
    private var timer: Timer? // a timer trigger event every second
    private var resetTimer: Timer?
    
    init(record: DetectionRecord) {
        self.record = record
        // 監聽 UserService 中的 currentUser 變化
        // TODO: Urgent1
//        UserService.shared.$userInfo
//            .sink { [weak self] user in
//                self?.user = user
//                if let time = user?.postureAlertDelayTime {
//                    self.warningManager.maxIncorrectCount = time
//                }
//            }
//            .store(in: &cancellables)
    }
    
    deinit {
        stopTimer()
    }
    
    // function to control the camera
    func stopDetection(){
        isDetecting = false
        self.cameraManager.isDetecting = false
        stopTimer()
        self.stopRecord()
        self.countScore()
        //self.createRecord()

    }
    func startDetection(){
        isDetecting = true
        self.cameraManager.isDetecting = true
        self.resetResults()
        record = DetectionRecord()

        startTimer()
    }
    func stopSeesion(){
        self.cameraManager.stopSession()
    }
    func startSession(){
        self.cameraManager.startSession()
    }
    
    // 開始定時器
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateResults()
        }
        resetTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            DispatchQueue.global().async { // exec in the background
                SpeechPlayer.shared.speak(speech: .sitTooLong)
            }
        }
    }
    func stopTimer(){
        timer?.invalidate()
        timer = nil
        resetTimer?.invalidate()
        resetTimer = nil
    }
    
    // Setup Combine bindings for handling publisher(camera)'s emit values
    func setupBindings() {
        guard !isBound else { return }
        isBound = true

        // 監聽 CameraManager 的 cgImage 變化，並更新自己的 cameraImage
        self.cameraManager.$cgImage
            .receive(on: DispatchQueue.main) //ㄊ
            .sink { [weak self] newImage in
                self?.cameraImage = newImage
            }
            .store(in: &cancellables)
        self.cameraManager.$classifiedReslt
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newResults in
                self?.classifiedReslt = newResults
                if self?.isDetecting == true {
                    // TODO: should catch this error
                    self?.accumProbs(from: newResults ?? [:])
                }
            }
            .store(in: &cancellables)
    }
    

    
    func getResults() -> [ResultData] {
        return [headResult, neckResult, shoulderResult, backResult, legResult]
    }
    func getRecord() -> DetectionRecord{
        return record
    }
    func stopRecord(){
        record.endDetectTimeStamp = Date()
        record.detectionInterval = record.endDetectTimeStamp.timeIntervalSince(record.startDetectTimeStamp)
        print("record start:\(record.startDetectTimeStamp), record end:\(record.endDetectTimeStamp)")
    }
    
    /// callback for receiving the new model output
    /// update UI result
    func updateResults() {
        for (part, probs) in AccClassProbs{
            let (cat, rst) = resultTransfer(part: part, probs: probs)
            DispatchQueue.main.async { [self] in
                switch part{
                case "Head":
                    headResult.postureType = cat
                    headResult.result = rst
                    record.head.count[cat, default: 0] += 1 // 分類結果計數->存入資料庫
                case "Neck":
                    neckResult.postureType = cat
                    neckResult.result = rst
                    record.neck.count[cat, default: 0] += 1
                case "Shoulder":
                    shoulderResult.postureType = cat
                    shoulderResult.result = rst
                    record.shoulder.count[cat, default: 0] += 1
                case "Body":
                    backResult.postureType = cat
                    backResult.result = rst
                    record.body.count[cat, default: 0] += 1
                case "Feet":
                    legResult.postureType = cat
                    legResult.result = rst
                    record.feet.count[cat, default: 0] += 1
                default:
                    break
                }
            }
        }
        // 重新累績機率分佈array
        AccClassProbs = ["Head": [Float32](), "Neck": [Float32](), "Shoulder": [Float32](), "Body":[Float32](), "Feet":[Float32]()]

        // 更新WarmingManager裡面的紀錄
         warningManager.updateResults(results: [headResult, neckResult, shoulderResult, backResult, legResult])
        
    }
    /// (postureType, postureCorrectOrNot)
    private func resultTransfer(part:String, probs:[Float32])->(String, String){
        guard let classes = modelCategories[part] else {
            return ("","")
        }
        
        let dictionary = Dictionary(uniqueKeysWithValues: zip(classes, probs))
        let sortedDictionary = dictionary.sorted { $0.value > $1.value } // sorted in descending order
        let topTwo = sortedDictionary.prefix(2) //
        
        if topTwo.count == 2 {
            // 計算差值
            let (one, two) = (topTwo[0], topTwo[1])
            let diff = one.value - two.value
            if (diff) > 0.1 * probs.reduce(0, +){ // 機率加總=總共累積的分類次數，希望單次分類結果最高的兩個類別機率差要超過0.1
                // 分類結果很明顯
                if part == "Feet"{
                    return (one.key, one.key == "Flat" ? "correct" : "wrong")
                }else{
                    return (one.key, one.key == "Neutral" ? "correct" : "wrong")
                }
            }else{
                return ("Ambiguous", "ambiguous") // should record in ambiguous and the icon must also in a /!\
            }
        } else {
            print("Less than two classes to compare the probabilities.")
            return ("", "")
        }

    }
    
    /// callback for receiving the new model output
    /// accumulate the classifed result probability
    func accumProbs(from classifiedResult: [String: [Float32]]) {
        for (part, probs) in classifiedResult {
            if AccClassProbs[part]?.count != probs.count {
                AccClassProbs[part] = Array(repeating: 0.0, count: probs.count)
            }
            for idx in probs.indices {
                AccClassProbs[part]?[idx] += probs[idx]
            }
        }
    }

    
    /// Count score
    /// Should only call after finishing detection
    func countScore() {
        record.head.score = calculateScore(for: record.head, neutralCategory: "Neutral")
        record.neck.score = calculateScore(for: record.neck, neutralCategory: "Neutral")
        record.shoulder.score = calculateScore(for: record.shoulder, neutralCategory: "Neutral")
        record.body.score = calculateScore(for: record.body, neutralCategory: "Neutral")
        record.feet.score = calculateScore(for: record.feet, neutralCategory: "Flat")
    }

    private func calculateScore(for bodyPart: BodyPartScore, neutralCategory: String) -> Double {
        let totalCount = bodyPart.count.values.reduce(0, +)
        guard totalCount > 0 else { return 0 }
        
        let neutralCount = bodyPart.count[neutralCategory, default: 0]
        self.record.totalCount = totalCount //順便更新totalCount
        return (Double(neutralCount) / Double(totalCount)) * 100
    }
    
    func resetResults() {
        headResult.result = nil
        neckResult.result = nil
        shoulderResult.result = nil
        backResult.result = nil
        legResult.result = nil
    }
    func getSingleRecordHistoryModel() -> HistoryModel{
        print("getting single record's data(HistoryModel)")
        return HistoryModel(initLineChartData: getSingleRecordLineChartData(), initPieChartData: getSingleRecordPieChartData(), timeUnit: .year)
    }
    private func getSingleRecordLineChartData() -> [DataSeries]{
        var lineChartData: [DataSeries] = []

        let time = record.startDetectTimeStamp
        let headDataSerie = DataSeries(title:"Head", scores: [ScoreData(day: time, score: Double(record.head.score))])
        let neckDataSerie = DataSeries(title:"Neck", scores: [ScoreData(day: time, score: Double(record.neck.score))])
        let shoulderDataSerie = DataSeries(title:"Shoulder", scores: [ScoreData(day: time, score: Double(record.shoulder.score))])
        let bodyDataSerie = DataSeries(title:"Back", scores: [ScoreData(day: time, score: Double(record.body.score))])
        let feetDataSerie = DataSeries(title:"Leg", scores: [ScoreData(day: time, score: Double(record.feet.score))])

        lineChartData = [headDataSerie, neckDataSerie, shoulderDataSerie, bodyDataSerie, feetDataSerie]
        return lineChartData
    }
    func getSingleRecordPieChartData() -> [PieDataSeries]{
        let time = record.startDetectTimeStamp
        var pieChartData: [PieDataSeries] = [
            PieDataSeries(title: "Back", ratios: []),
            PieDataSeries(title: "Leg", ratios: []),
            PieDataSeries(title: "Head", ratios: []),
            PieDataSeries(title: "Neck", ratios: []),
            PieDataSeries(title: "Shoulder", ratios: [])
        ]
        let legData = [
            RatioData(title: "Flat", day: time, ratio: record.feet.count["Flat", default: 0], uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Ankle-on-knee", day: time, ratio: record.feet.count["Ankle-on-knee", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Ambiguous", day: time, ratio: record.feet.count["Ambiguous", default: 0], uiColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        ]
        let backData = [
            RatioData(title: "Backward", day: time, ratio: record.body.count["Backward", default: 0], uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: time, ratio: record.body.count["Forward", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: time, ratio: record.body.count["Neutral", default: 0], uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Ambiguous", day: time, ratio: record.body.count["Ambiguous", default: 0], uiColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        ]
        let headData = [
            RatioData(title: "Bowed", day: time, ratio: record.head.count["Bowed", default: 0], uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: time, ratio: record.head.count["Neutral", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Tilt Back", day: time, ratio: record.head.count["Tilt Back", default: 0], uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Ambiguous", day: time, ratio: record.head.count["Ambiguous", default: 0], uiColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        ]
        let neckData = [
            RatioData(title: "Forward", day: time, ratio: record.neck.count["Forward", default: 0], uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: time, ratio: record.neck.count["Neutral", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Ambiguous", day: time, ratio: record.neck.count["Ambiguous", default: 0], uiColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        ]
        let shoulderData = [
            RatioData(title: "Hunched", day: time, ratio: record.shoulder.count["Hunched", default: 0], uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: time, ratio: record.shoulder.count["Neutral", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Shrug", day: time, ratio: record.shoulder.count["Shrug", default: 0], uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1)),
            RatioData(title: "Ambiguous", day: time, ratio: record.shoulder.count["Ambiguous", default: 0], uiColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        ]
        
        pieChartData[0].ratios = [backData]
        pieChartData[1].ratios = [legData]
        pieChartData[2].ratios = [headData]
        pieChartData[3].ratios = [neckData]
        pieChartData[4].ratios = [shoulderData]
        
        return pieChartData
    }
    
    func createRecord(){
        guard let token = self.tokenService.retrieveToken(for: .accessToken) else { return }
        recordService.createRecord(token: token, record: self.record.toRecordCreate()){ result in
            // Should make sure cover all .failure cases
            switch result{
            case .success():
                print("Sucessfully createRecord")
            case .failure(let error):
                print("CreateRecord failed: \(error)")
            }
        }
    }
}

