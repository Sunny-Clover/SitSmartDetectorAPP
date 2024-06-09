//
//  DetectionView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/12.
//

import SwiftUI
import Combine

class DetectionViewModel: ObservableObject {
    @Published var headResult = ResultData(icon: "headIcon", bodyPartName: "Head", result: "correct", postureType: "Neutral")
    @Published var neckResult = ResultData(icon: "neckIcon", bodyPartName: "Neck", result: "correct", postureType: "Neutral")
    @Published var shoulderResult = ResultData(icon: "shoulderIcon", bodyPartName: "Shoulder", result: "correct", postureType: "Neutral")
    @Published var backResult = ResultData(icon: "backIcon", bodyPartName: "Back", result: "correct", postureType: "Neutral")
    @Published var legResult = ResultData(icon: "legIcon", bodyPartName: "Leg", result: "correct", postureType: "Flat")
    
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
}


struct DetectionView: View {
    @ObservedObject var cameraManager = CameraManager()
    @ObservedObject var viewModel = DetectionViewModel()
    
    var body: some View {
        ZStack {
            Color(red: 249/255, green: 249/255, blue: 249/255)
                .ignoresSafeArea()
            VStack(alignment: .center) {
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
            }
        }.onAppear { // TODO: start and stop with button trigger
            cameraManager.startRunning()
        }.onDisappear {
            cameraManager.stopRunning()
        }.onReceive(cameraManager.$detectionResult) { result in
            if let result = result {
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
                    if detectionResult.result == "correct"{
                        Image(systemName: "checkmark").resizable().frame(width:20, height:20)
                            .foregroundColor(.accent)
                        Text(detectionResult.postureType).fontWeight(.regular)
                            .foregroundColor(.accent)
                            .font(.system(size: 12))
                            .padding(.bottom, 3)
                    }else{
                        Image(systemName: "xmark").resizable().frame(width:20, height:20)
                            .foregroundColor(.red)
                        Text(detectionResult.postureType).fontWeight(.regular)
                            .foregroundColor(.red)
                            .font(.system(size: 12))
                            .padding(.bottom, 3)
                    }
                    
                }
            }

        }.frame(width: 54, height: 128)
            .background(.accent)
            .cornerRadius(27)
    }
}
