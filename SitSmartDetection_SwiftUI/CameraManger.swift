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
        
        // guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { return }

        // 如果正在等待服务器响应，则不发送新请求
        guard !isWaitingForServer else { return }
        
        uploadImageToServer(image: uiImage)
    }

    private func uploadImageToServer(image: UIImage) {
        guard let url = URL(string: "http://192.168.1.109:8000/predict_movenet"),
              let imageData = image.jpegData(compressionQuality: 0.5) else { return }

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

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            if let data = data {
                print("Server response: \(String(data: data, encoding: .utf8) ?? "No response data")")
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
