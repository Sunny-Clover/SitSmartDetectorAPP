//
//  CameraManager.swift
//  SitSmartDetection
//
//  Created by 林君曆 on 2024/4/20.
//
import SwiftUI
import AVFoundation

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var detectionResults: [ResultData] = []

    private let captureSession = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "cameraSessionQueue")
    private var isRunning = false
    private var isWaitingForServer = false // 新增的标志

    override init() {
        super.init()

        captureSession.sessionPreset = .photo

        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            return
        }

        captureSession.addInput(input)
        
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        captureSession.addOutput(videoOutput)
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

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { return }

        // 如果正在等待服务器响应，则不发送新请求
        guard !isWaitingForServer else { return }
        
        uploadImageToServer(imageData: imageData)
    }

    private func uploadImageToServer(imageData: Data) {
        let url = URL(string: "http://192.168.1.109:8000/predict_movenet")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

        isWaitingForServer = true // 设置标志，表示正在等待响应

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { self.isWaitingForServer = false } // 无论请求是否成功，重置标志

            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let predictionResult = String(data: data, encoding: .utf8) {
                print("Prediction result: \(predictionResult)")
            } else {
                print("Failed to decode response")
            }
        }
        
        task.resume()
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
