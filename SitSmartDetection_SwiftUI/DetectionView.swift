//
//  DetectionView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/12.
//

import SwiftUI

struct DetectionView: View {
    @ObservedObject var cameraManager = CameraManager()
    var body: some View {
        ZStack {
            Color(red: 249/255, green: 249/255, blue: 249/255)
                .ignoresSafeArea()
            VStack(alignment: .center) {
                Text("Posture Detection").font(.title).foregroundColor(.deepAccent)
                HStack(spacing:15){
                    BodyPartResultView(detectionResult: .fakeCorrectData)
                    BodyPartResultView(detectionResult: .fakeWrongData)
                    BodyPartResultView(detectionResult: .fakeCorrectData)
                    BodyPartResultView(detectionResult: .fakeWrongData)
                    BodyPartResultView(detectionResult: .fakeCorrectData)
                }
                CameraView(cameraManager: cameraManager)
                    .frame(width: 350, height: 467)
                    .clipped()
            }
        }.onAppear {
            cameraManager.startRunning()
        }
        .onDisappear {
            cameraManager.stopRunning()
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
