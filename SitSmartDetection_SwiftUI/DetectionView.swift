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
        record.detectionInterval = record.endDetectTimeStamp.timeIntervalSince(record.startDetectTimeStamp)
    }
    
    func updateResults(from response: [String:poseClassfiedResult]) {
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
    
    private func calculateScore(for bodyPart: BodyPartScore, neutralCategory: String) -> Float {
        let totalCount = bodyPart.count.values.reduce(0, +)
        guard totalCount > 0 else { return 0 }
        
        let neutralCount = bodyPart.count[neutralCategory, default: 0]
        return (Float(neutralCount) / Float(totalCount)) * 100
    }
    
    func resetResults() {
        headResult.result = nil
        neckResult.result = nil
        shoulderResult.result = nil
        backResult.result = nil
        legResult.result = nil
        
    }
    func resetRecord() {
        record = DetectionRecord()
    }
    // swiftData method
//    func insertRecord(modelContext:ModelContext){
//        modelContext.insert(record)
//    }
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
            if let frame = cameraManager.frame {
                OverlayViewRepresentable(image: $cameraManager.frame, person: $cameraManager.person)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 467)
                    .clipped()
            } else {
                Text("No Camera Feed")
                    .foregroundColor(.white)
                    .frame(width: 350, height: 467)
                    .onAppear {
                        print("No Camera Feed")
                    }
            }
            Button(action: {
                if cameraManager.isDetecting { //stop detection
                    cameraManager.stopDetection()
                    viewModel.countScore()
                    let record = viewModel.getRecord()
                    modelContext.insert(record)
//                    viewModel.insertRecord(modelContext: modelContext)
                    viewModel.resetResults()
                    navigateToRecordList = true
                } else { // start detection
                    viewModel.resetRecord()
                    cameraManager.startDetection()
                }
            }, label: {
                Image(systemName: cameraManager.isDetecting ? "stop.circle.fill" : "play.circle.fill")
            })
            NavigationLink("", destination: DetectionRecordList(), isActive: $navigateToRecordList)
                        }
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



struct OverlayViewRepresentable: UIViewRepresentable {
    @Binding var image: UIImage?
    @Binding var person: Person?

    func makeUIView(context: Context) -> OverlayView {
        let overlayView = OverlayView()
        overlayView.contentMode = .scaleAspectFit
        return overlayView
    }

    func updateUIView(_ uiView: OverlayView, context: Context) {
        guard let image = image, let person = person else { return }
        uiView.image = image
        uiView.draw(at: image, person: person)
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


struct DetectionRecordList: View {
    @Query private var records: [DetectionRecord]

    var body: some View {
        NavigationStack {
            List {
                ForEach(records, id: \.id) { record in
                    VStack(alignment: .leading) {
                        Text("head:\(record.head.score)")
                        Text("body:\(record.body.score)")
                        Text("shoulder:\(record.shoulder.score)")
                        Text("neck:\(record.neck.score)")
                        Text("feet:\(record.feet.score)")

                    }
                }
            }
            .navigationTitle("Detection Records")
            .toolbar {
                ToolbarItem {
                    Button(action: addRecord) {
                        Label("Add Record", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addRecord() {
        // 此處插入新增紀錄的代碼
    }
}

#Preview {
    DetectionRecordList()
        .modelContainer(for: DetectionRecord.self, inMemory: true)
}

/*
import SwiftUI
import Combine

class DetectionViewModel: ObservableObject {
    @Published var headResult = ResultData(icon: "headIcon", bodyPartName: "Head", result: nil, postureType: nil)
    @Published var neckResult = ResultData(icon: "neckIcon", bodyPartName: "Neck", result: nil, postureType: nil)
    @Published var shoulderResult = ResultData(icon: "shoulderIcon", bodyPartName: "Shoulder", result: nil, postureType: nil)
    @Published var backResult = ResultData(icon: "backIcon", bodyPartName: "Back", result: nil, postureType: nil)
    @Published var legResult = ResultData(icon: "legIcon", bodyPartName: "Leg", result: nil, postureType: nil)
    
    func getResults() -> [ResultData] {
        return [headResult, neckResult, shoulderResult, backResult, legResult]
    }
    
    func updateResults(from response: PostureResponse) {
        headResult.postureType = response.head
        neckResult.postureType = response.neck
        shoulderResult.postureType = response.shoulder
        backResult.postureType = response.body
        legResult.postureType = response.feet
        
        // 更新 result 字段，這裡假設如果 postureType 不是 neutral 或 flat 就是 wrong
        headResult.result = (response.head == "Neutral") ? "correct" : "wrong"
        neckResult.result = (response.neck == "Neutral") ? "correct" : "wrong"
        shoulderResult.result = (response.shoulder == "Neutral") ? "correct" : "wrong"
        backResult.result = (response.body == "Neutral") ? "correct" : "wrong"
        legResult.result = (response.feet == "Flat") ? "correct" : "wrong"
    }
    func resetResults() {
        headResult.result = nil
        neckResult.result = nil
        shoulderResult.result = nil
        backResult.result = nil
        legResult.result = nil
    }
}


struct DetectionView: View {
    @ObservedObject var cameraManager = CameraManager()
    @ObservedObject var viewModel = DetectionViewModel()
    
    var body: some View {
        ZStack {
            Color(red: 249/255, green: 249/255, blue: 249/255)
                .ignoresSafeArea()
            VStack(alignment: .center) {
//                Spacer().frame(height: 10)
                Text("Posture Detection").font(.title).foregroundColor(.deepAccent)
                HStack(spacing:15){
                    let rst = viewModel.getResults()
                    BodyPartResultView(detectionResult: rst[0])
                    BodyPartResultView(detectionResult: rst[1])
                    BodyPartResultView(detectionResult: rst[2])
                    BodyPartResultView(detectionResult: rst[3])
                    BodyPartResultView(detectionResult: rst[4])
                }
                CameraView(cameraManager: cameraManager)
                    .frame(width: 350, height: 467)
                    .clipped()
                Button(action: {
                    if cameraManager.isDetecting {
                        cameraManager.stopDetection()
                        viewModel.resetResults()
                    } else {
                        cameraManager.startDetection()
                    }
                }, label: {
                    Image(systemName: cameraManager.isDetecting ? "stop.circle.fill" : "play.circle.fill")
                })
            }
        }.onAppear { // TODO: start and stop with button trigger
            cameraManager.startRunning()
        }.onDisappear {
            cameraManager.stopRunning()
        }.onReceive(cameraManager.$detectionResult) { result in
            if let result = result{
                if !cameraManager.isDetecting {return}
                viewModel.updateResults(from: result)
            }
        }
    }
}

#Preview {
    DetectionView()
}


// struct 後面view protocol
// command+click 看definition
// option+click 看說明
// control + I 縮排
// command+shift+A 看快捷選單
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
}*/
