//
//  DetectionView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/12.
//

import SwiftUI

struct DetectionView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Posture Detection").font(.title).foregroundColor(.deepAccent)
            HStack(spacing:15){
                BodyPartResultView(detectionResult: .fakeCorrectData)
                BodyPartResultView(detectionResult: .fakeWrongData)
                BodyPartResultView(detectionResult: .fakeCorrectData)
                BodyPartResultView(detectionResult: .fakeWrongData)
                BodyPartResultView(detectionResult: .fakeCorrectData)
            }
            CameraView()
                .frame(width: 350, height: 467)  // 指定CameraView的尺寸
                .clipped()  // 確保視圖不會超出指定的尺寸
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
