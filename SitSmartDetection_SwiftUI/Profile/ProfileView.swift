//
//  ProfileView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/17.
//

import SwiftUI
import FirebaseAuth

class ProfileViewModel: ObservableObject {
//    @Published var users: [User] = []
    @Published var statics: profileStatics = profileStatics(level: 2, Score: 89, ReachedGaol: 6)
    
    func getUserAvatar(){
        
    }
    func getUserName() -> String{
        return "Sunny"
    }
}
struct profileStatics{
    let level:Int
    let Score:Int
    let ReachedGaol:Int
}


struct ProfileView: View {
    @AppStorage("uid") var userID: String = ""
    @ObservedObject var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Button
                HStack{
                    Spacer()
                    Button(action: {
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                            withAnimation {
                                userID = ""
                            }
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                    }) {
                        Image(.faRightFromBracket)
                            .foregroundColor(.accentColor)
                    }.padding()
                }
                Image("Avatar")
                    .resizable()
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(.accent, lineWidth: 3) // 使用 `overlay` 添加圓形邊框
                    )
                Text(viewModel.getUserName())
                    .foregroundColor(.profileAccent) // 設置文字顏色
                    .font(.system(size: 32, weight: .medium, design: .default))
                    .padding() // 添加內邊距
                // Statics
                HStack (spacing:3){
                    VStack{
                        Text("\(viewModel.statics.level)")
                            .font(.system(size: 20, weight: .medium, design: .default))
                        Text("Level")
                            .font(.system(size: 14, weight: .medium, design: .default))
                    }.frame(width: 90)
                    VStack{
                        Text("\(viewModel.statics.Score)")
                            .font(.system(size: 20, weight: .medium, design: .default))
                        Text("Score")
                            .font(.system(size: 14, weight: .medium, design: .default))
                    }.frame(width: 90)
                    VStack{
                        Text("\(viewModel.statics.ReachedGaol)")
                            .font(.system(size: 20, weight: .medium, design: .default))
                        Text("ReachedGoal")
                            .font(.system(size: 14, weight: .medium, design: .default))
                    }.frame(width: 90)
                }.foregroundColor(.profileAccent) // 設置文字顏色
                // Profile setting button
                NavigationLink(destination: ProfileSettingView()) {
                    HStack {
                        Image(systemName: "person.fill").resizable().frame(width:32, height: 32)
                        Text("Profile")
                            .font(.system(size: 24, weight: .medium, design: .default))
                            .padding() // 添加內邊距
                        Spacer()
                        Image(systemName: "arrowtriangle.right.fill")
                    }
                    .padding()
                    .frame(width: 300, height: 64)
                    .background(Color.accent)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(5)
                }

                // Custom setting button
                NavigationLink(destination: ProfileSettingView()) {
                    HStack {
                        Image(systemName: "gearshape.fill").resizable().frame(width:32, height: 32)
                        Text("Customization")
                            .font(.system(size: 24, weight: .medium, design: .default))
                            .padding() // 添加內邊距
                        Spacer()
                        Image(systemName: "arrowtriangle.right.fill")
                    }
                    .padding()
                    .frame(width: 300, height: 64)
                    .background(Color.accent)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(5)
                }
                Spacer()
            }
        }
    }
}




// sample Button to test the urlSession
//            Button(action: {
//                guard let image = UIImage(named: "sample_img") else {
//                    print("Image not found")
//                    return
//                }
//                sendRequest(image: image)
//            }, label: {
//                Text("Button").padding()
//            })

//func sendRequest(image: UIImage) {
//    guard let url = URL(string: "http://192.168.1.109:8000/predict_movenet") else {
//        print("Invalid URL")
//        return
//    }
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    
//    // 將圖片轉換為 JPEG Data
//    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//        print("Failed to convert image to data")
//        return
//    }
//    
//    // 設置請求頭
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    // 建立multipart/form-data的請求body
//    let boundary = UUID().uuidString
//    let contentType = "multipart/form-data; boundary=\(boundary)"
//    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//    
//    var body = Data()
//    let boundaryPrefix = "--\(boundary)\r\n"
//    
//    body.append(Data(boundaryPrefix.utf8))
//    body.append(Data("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".utf8))
//    body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
//    body.append(imageData)
//    body.append(Data("\r\n".utf8))
//    body.append(Data("--\(boundary)--\r\n".utf8))
//    
//    request.httpBody = body
//    
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error: \(error.localizedDescription)")
//            return
//        }
//        
//        guard let data = data else {
//            print("No data received")
//            return
//        }
//        
//        if let predictionResult = String(data: data, encoding: .utf8) {
//            print("Prediction result: \(predictionResult)")
//        } else {
//            print("Failed to decode response")
//        }
//    }
//    
//    task.resume()
//}


#Preview {
    ProfileView()
}
