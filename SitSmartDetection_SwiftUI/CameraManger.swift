//
//  CameraManager.swift
//  SitSmartDetection
//
//  Created by 林君曆 on 2024/4/20.
//
import SwiftUI
import AVFoundation
import Photos

struct PostureResponse: Codable {
    let body: String
    let feet: String
    let head: String
    let neck: String
    let shoulder: String
}


// Protocal: AVCaptureVideoDataOutputSampleBufferDelegate
// Usage: to do some action about the camera frame
class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var detectionResult: PostureResponse?
    @Published var isDetecting = false // toggle by button
    private let captureSession = AVCaptureSession() //協調設備的輸入輸出數據流，功能：啟動、停止capture等等等
    private let videoOutput = AVCaptureVideoDataOutput()
//    private let sessionQueue = DispatchQueue(label: "cameraSessionQueue")
    private let dataOutputQueue = DispatchQueue(
      label: "video data queue",
      qos: .userInitiated,
      attributes: [],
      autoreleaseFrequency: .workItem)
    private var isRunning = false
    private var isWaitingForServer = false // 新增的标志

    override init() {
        super.init() // 呼叫parent的初始化，因爲這個object繼承了NSObject！

        captureSession.sessionPreset = .photo

        guard let captureDevice = AVCaptureDevice.default(for: .video), // 獲取後置相機
              let input = try? AVCaptureDeviceInput(device: captureDevice) /*獲取設備的輸入*/else {
            // 獲取設備或設備的輸入失敗就直接return
            return
        }

        captureSession.addInput(input) // 將創建好的設備輸入設定給captureSession協調
        
        /*
        // 設置設備輸出AVCaptureVideoDataOutput的delegate為self(=CameraManager)
        // 設置callback function queue，等待callback functino處理
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        captureSession.addOutput(videoOutput) // 將定義好的output設置給captureSession
        // videoOutput會自動將得到的影像以CMSampleBuffer的形式傳遞給callback functino(captureOutput)
         */
        
        videoOutput.videoSettings = [
          (kCVPixelBufferPixelFormatTypeKey as String): NSNumber(value: kCVPixelFormatType_32BGRA)
        ]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(videoOutput) {
          captureSession.addOutput(videoOutput)
          videoOutput.connection(with: .video)?.videoOrientation = .portrait
        }
        videoOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
    }

    func getCaptureSession() -> AVCaptureSession {
        return captureSession
    }

    func startRunning() {
        if !isRunning {
            captureSession.startRunning()
            isRunning = true
        }
    }

    func stopRunning() {
        if isRunning {
            captureSession.stopRunning()
            isRunning = false
        }
    }
    func startDetection() {
        isDetecting = true
    }

    func stopDetection() {
        isDetecting = false
    }
    // callback function，對輸出做操作
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 提取整個緩衝區中的Image緩衝區
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        // 在不同的框架中的圖片型態做轉換，每種型態都有其作用跟目的，UIImage比較高層次做渲染等作用
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        
        // guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { return }

        // Fix image orientation
        // uiImage = uiImage.fixOrientation() ?? uiImage
        // 如果正在等待服务器响应，则不发送新请求
        guard !isWaitingForServer else { return }
        guard isDetecting else { return } // 只在检测状态下上传图片

        // 標誌設置為正在等待伺服器響應
        isWaitingForServer = true
        
        // 保存圖片到相簿:只用作測試！
//        saveImageToPhotosAlbum(image: uiImage)
        
        uploadImageToServer(image: uiImage)
    }
    
    private func saveImageToPhotosAlbum(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveError), nil)
            } else {
                print("Permission to access photo library was denied")
            }
        }
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving photo: \(error.localizedDescription)")
        } else {
            print("Photo saved successfully")
        }
    }
    
    private func uploadImageToServer(image: UIImage) {
         guard let url = URL(string: "http://192.168.1.109:8000/predict_movenet"), // windows IP
//        guard let url = URL(string: "http://127.0.0.1:8000/predict_movenet"),
              let imageData = image.jpegData(compressionQuality: 0.5) else {
            isWaitingForServer = false // 確保即使出錯也能重置標誌
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error uploading image: \(error)")
            } else if let data = data {
                print("Server response: \(String(data: data, encoding: .utf8) ?? "No response data")")
                // JSON解碼
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(PostureResponse.self, from: data)
                    
                    // 更新UI，因為URLSession的回調是在背景佇列中運行，所以需要回到主佇列中更新UI
                    DispatchQueue.main.async {
                        self?.detectionResult = response
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            
            // 無論成功還是失敗，都重置標誌
            DispatchQueue.main.async {
                self?.isWaitingForServer = false
            }
        }.resume()
    }

}


struct CameraView: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 467))
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: cameraManager.getCaptureSession())
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // 更新视图时需要执行的操作
    }
}
private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension UIImage {
    func fixOrientation() -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        if self.imageOrientation == .up { return self }

        var transform = CGAffineTransform.identity

        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2)
        default:
            break
        }

        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }

        guard let colorSpace = cgImage.colorSpace,
              let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue) else {
            return nil
        }

        ctx.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }

        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage(cgImage: newCGImage)
    }
}

