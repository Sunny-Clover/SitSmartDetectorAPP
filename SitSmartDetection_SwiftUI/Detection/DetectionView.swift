//
//  DetectionView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/12.
//
import SwiftUI
import SwiftData

struct DetectionView: View {
    @AppStorage("uid") var userID: String = ""
    @ObservedObject var cameraManager = CameraManager()
    @ObservedObject var viewModel = DetectionViewModel(record: DetectionRecord())
    @Environment(\.modelContext) private var modelContext
    @State private var navigateToRecordList = false
    
    var body: some View {
        NavigationStack{
            VStack {
//                Text("Posture Detection").font(.title).foregroundColor(.deepAccent)
                HStack(spacing:15){
                    let rst = viewModel.getResults()
                    BodyPartResultView(detectionResult: rst[0])
                    BodyPartResultView(detectionResult: rst[1])
                    BodyPartResultView(detectionResult: rst[2])
                    BodyPartResultView(detectionResult: rst[3])
                    BodyPartResultView(detectionResult: rst[4])
                }
                
                // TODO: 樣式可以再調整
                ZStack(alignment: .bottom){
                    if let image = cameraManager.cgImage {
                        Image(image, scale: 1.0, orientation: .up, label: Text("Image"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350, height: 467)
                    } else {
                        Text("No Camera Feed")
                            .foregroundColor(.white)
                            .frame(width: 350, height: 467)
                            .onAppear {
                                print("No Camera Feed")
                            }
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
                .frame(width: 350, height: 467)
            }
            .navigationDestination(isPresented: $navigateToRecordList){
                // 連結到單次監測結果畫面
                ReportView(report: viewModel.getSingleRecordHistoryModel()).onAppear {
                    cameraManager.stopSession()
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
