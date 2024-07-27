//
//  DetectionView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/12.
//
import SwiftUI
import SwiftData

class DetectionViewModel: ObservableObject {
    @Published var headResult = ResultData(icon: "headIcon", bodyPartName: "Head", result: nil, postureType: nil)
    @Published var neckResult = ResultData(icon: "neckIcon", bodyPartName: "Neck", result: nil, postureType: nil)
    @Published var shoulderResult = ResultData(icon: "shoulderIcon", bodyPartName: "Shoulder", result: nil, postureType: nil)
    @Published var backResult = ResultData(icon: "backIcon", bodyPartName: "Back", result: nil, postureType: nil)
    @Published var legResult = ResultData(icon: "legIcon", bodyPartName: "Leg", result: nil, postureType: nil)
    
    private var record: DetectionRecord
    
    init(record: DetectionRecord) {
        self.record = record
    }
    
    func getResults() -> [ResultData] {
        return [headResult, neckResult, shoulderResult, backResult, legResult]
    }
    func getRecord() -> DetectionRecord{
        return record
    }
    func stopRecord(){
        record.endDetectTimeStamp = Date()
        print("record start:\(record.startDetectTimeStamp), record end:\(record.endDetectTimeStamp)")
        record.detectionInterval = record.endDetectTimeStamp.timeIntervalSince(record.startDetectTimeStamp)
    }
    
    func updateResults(from response: [String:poseClassfiedResult]) {
        print("updateResults called")
        headResult.postureType = response["head"]?.category
        neckResult.postureType = response["neck"]?.category
        shoulderResult.postureType = response["shoulder"]?.category
        backResult.postureType = response["body"]?.category
        legResult.postureType = response["feet"]?.category
        
        // 更新 result 字段，這裡假設如果 postureType 不是 neutral 或 flat 就是 wrong
        headResult.result = (response["head"]?.category == "Neutral") ? "correct" : "wrong"
        neckResult.result = (response["neck"]?.category == "Neutral") ? "correct" : "wrong"
        shoulderResult.result = (response["shoulder"]?.category == "Neutral") ? "correct" : "wrong"
        backResult.result = (response["body"]?.category == "Neutral") ? "correct" : "wrong"
        legResult.result = (response["feet"]?.category == "Flat") ? "correct" : "wrong"
    }
    
    func updateCounts(from classifiedResult: [String: poseClassfiedResult]) {
        print("update counts of record")
        if let headCategory = classifiedResult["head"]?.category {
            record.head.count[headCategory, default: 0] += 1
        }
        if let neckCategory = classifiedResult["neck"]?.category {
            record.neck.count[neckCategory, default: 0] += 1
        }
        if let shoulderCategory = classifiedResult["shoulder"]?.category {
            record.shoulder.count[shoulderCategory, default: 0] += 1
        }
        if let bodyCategory = classifiedResult["body"]?.category {
            record.body.count[bodyCategory, default: 0] += 1
        }
        if let feetCategory = classifiedResult["feet"]?.category {
            record.feet.count[feetCategory, default: 0] += 1
        }
    }
    
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
    func resetRecord() {
        record.startDetectTimeStamp = Date()
        record = DetectionRecord()
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
    private func getSingleRecordPieChartData() -> [PieDataSeries]{
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
            RatioData(title: "Ankle-on-knee", day: time, ratio: record.feet.count["Ankle-on-knee", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ]
        let backData = [
            RatioData(title: "Backward", day: time, ratio: record.body.count["Backward", default: 0], uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Forward", day: time, ratio: record.body.count["Forward", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Neutral", day: time, ratio: record.body.count["Neutral", default: 0], uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ]
        let headData = [
            RatioData(title: "Bowed", day: time, ratio: record.head.count["Bowed", default: 0], uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: time, ratio: record.head.count["Neutral", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Tilt Back", day: time, ratio: record.head.count["Tilt Back", default: 0], uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ]
        let neckData = [
            RatioData(title: "Forward", day: time, ratio: record.neck.count["Forward", default: 0], uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: time, ratio: record.neck.count["Neutral", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1))
        ]
        let shoulderData = [
            RatioData(title: "Hunched", day: time, ratio: record.shoulder.count["Hunched", default: 0], uiColor: #colorLiteral(red: 0.9474967122, green: 0.8637040257, blue: 0.3619352579, alpha: 1)),
            RatioData(title: "Neutral", day: time, ratio: record.shoulder.count["Neutral", default: 0], uiColor: #colorLiteral(red: 0.388066709, green: 0.6697527766, blue: 0.9942032695, alpha: 1)),
            RatioData(title: "Shrug", day: time, ratio: record.shoulder.count["Shrug", default: 0], uiColor: #colorLiteral(red: 0.3899648786, green: 0.3800646067, blue: 0.6288498044, alpha: 1))
        ]
        
        pieChartData[0].ratios = [backData]
        pieChartData[1].ratios = [legData]
        pieChartData[2].ratios = [headData]
        pieChartData[3].ratios = [neckData]
        pieChartData[4].ratios = [shoulderData]
        
        return pieChartData
    }
}



struct DetectionView: View {
    @AppStorage("uid") var userID: String = ""
    @ObservedObject var cameraManager = CameraManager()
    @ObservedObject var viewModel = DetectionViewModel(record: DetectionRecord())
    @Environment(\.modelContext) private var modelContext
    @State private var navigateToRecordList = false
    
    var body: some View {
        NavigationStack{
            VStack {
                
                Text("Posture Detection").font(.title).foregroundColor(.deepAccent)
                HStack(spacing:15){
                    let rst = viewModel.getResults()
                    BodyPartResultView(detectionResult: rst[0])
                    BodyPartResultView(detectionResult: rst[1])
                    BodyPartResultView(detectionResult: rst[2])
                    BodyPartResultView(detectionResult: rst[3])
                    BodyPartResultView(detectionResult: rst[4])
                }
                
                if let image = cameraManager.cgImage {
                    Image(image, scale: 1.0, orientation: .up, label: Text("Image"))
                        .resizable()
                        .frame(width: 350, height: 467)
                        
                } else {
                    Text("No Camera Feed")
                        .foregroundColor(.white)
                        .frame(width: 350, height: 467)
                        .onAppear {
                            print("No Camera Feed")
                        }
                }
                NavigationLink(destination: ReportView(report: viewModel.getSingleRecordHistoryModel()).onAppear {
                    cameraManager.stopSession()
                }, isActive: $navigateToRecordList) {
                    EmptyView()
                }
                Button(action: {
                    if cameraManager.isDetecting { // stop detection
                        cameraManager.stopDetection()
                        viewModel.stopRecord()
                        viewModel.countScore()
                        let record = viewModel.getRecord()
                        modelContext.insert(record)
                        print("stop detection, isDetecting = \(cameraManager.isDetecting)")
                        viewModel.resetResults()
                        navigateToRecordList = true
                    } else { // start detection
                        viewModel.resetRecord()
                        cameraManager.startDetection()
                    }
                }, label: {
                    Image(systemName: cameraManager.isDetecting ? "stop.circle.fill" : "play.circle.fill")
                        .foregroundColor(.accent)
                        .frame(width: 50)
                })
            }
            .onAppear {
                cameraManager.startSession()
                print("View appeared, camera session started")
            }
            .onDisappear {
                cameraManager.stopSession()
                print("View disappeared, camera session stopped")
            }
            .onReceive(cameraManager.$classifiedReslt) { result in
                if let result = result{
                    if !cameraManager.isDetecting {return}
                    viewModel.updateCounts(from: result)
                    viewModel.updateResults(from: result)
                }
            }
        }
        
    }
}


struct BodyPartResultView: View{
    var detectionResult:ResultData
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Image(detectionResult.icon).resizable().frame(width: 30, height: 30)
            Text(detectionResult.bodyPartName)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .font(.system(size: 12))
            
            ZStack {
                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 24, bottomTrailingRadius: 24, topTrailingRadius: 0)
                            .foregroundStyle(.white)
                            .frame(width:48, height: 58)
                        .padding(.bottom, 3)
                VStack {
                    if let result = detectionResult.result, let postureType = detectionResult.postureType {
                        if result == "correct" {
                            Image(systemName: "checkmark").resizable().frame(width: 20, height: 20)
                                .foregroundColor(.accent)
                            Text(postureType).fontWeight(.regular)
                                .foregroundColor(.accent)
                                .font(.system(size: 12))
                                .padding(.bottom, 3)
                        } else if result == "wrong" {
                            Image(systemName: "xmark").resizable().frame(width: 20, height: 20)
                                .foregroundColor(.red)
                            Text(postureType).fontWeight(.regular)
                                .foregroundColor(.red)
                                .font(.system(size: 12))
                                .padding(.bottom, 3)
                        }
                    }
                    
                }
            }

        }.frame(width: 54, height: 128)
            .background(.accent)
            .cornerRadius(27)
    }
}


#Preview {
    DetectionView()
}
