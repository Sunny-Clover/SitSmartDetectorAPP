//
//  ProfileView.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/5/17.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @AppStorage("uid") var userID: String = ""
    var body: some View {
        VStack {
//            Text("Logged In! \nYour user id is \(userID)")
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
                // arrow.forward.square
                //
                // faRightFromBracket
//                Image(systemName: "rectangle.portrait.and.arrow.forward")
                Image(.faRightFromBracket)
                    .foregroundColor(.accentColor)
            }
//            Button(action: {
//                guard let image = UIImage(named: "sample_img") else {
//                    print("Image not found")
//                    return
//                }
//                sendRequest(image: image)
//            }, label: {
//                Text("Button").padding()
//            })
            
        }
    }
}

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
