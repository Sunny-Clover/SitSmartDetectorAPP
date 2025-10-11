import AVFoundation
import UIKit
import SwiftUI
import WebRTC
import os

enum ClassificationBodyPart: String {
    case Head = "Head"
    case Neck = "Neck"
    case Shoulder = "Shoulder"
    case Body = "Body"
    case Feet = "Feet"
}

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var cgImage: CGImage? // Realtime detection image
    @Published var person: Person? // Movenet Detection results
    @Published var classifiedReslt:[String:[Float32]]? // Pose classification results from person
    
    private let drawTool = DrawTool()
    private let session = AVCaptureSession()
    private let videoQueue = DispatchQueue(label: "videoQueue") // background thread for capture session
    
    // webRTC 相關
    private var peerConnection: RTCPeerConnection?
    private var localVideoTrack: RTCVideoTrack?
    private var videoCapturer: RTCVideoCapturer?
    private var videoSource: RTCVideoSource?
    private let factory = RTCPeerConnectionFactory()
    
    // 新增：WebSocket 信令相關
    private var webSocketTask: URLSessionWebSocketTask?
    
    // movenet settings
    private var poseEstimator: PoseEstimator? // movenet
    private var modelType: ModelType = .movenetThunder
    private var threadCount: Int = 4
    private var delegate: Delegates = .gpu
    private let minimumScore = 0.2 // min bound to show detection result
    
    let queue = DispatchQueue(label: "serial_queue")
    private let context = CIContext()
    
    var isRunning = false
    var isDetecting = false // determine to run pose classifier or not
    
    // Pose classifier
    private var headClassifier:PoseClassifier?
    private var neckClassifier:PoseClassifier?
    private var shoulderClassifier:PoseClassifier?
    private var bodyClassifier:PoseClassifier?
    private var feetClassifier:PoseClassifier?
    
    override init() {
        super.init()
        setupWebRTC()
        initModel()
        checkCameraAuthorization()
    }
    
    // MARK: - 相機相關設定
    private func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupCamera()
                } else {
                    print("Camera access denied")
                }
            }
        case .denied, .restricted:
            print("Camera access denied")
        @unknown default:
            fatalError("Unknown camera authorization status")
        }
    }
    
    private func setupCamera() {
        session.beginConfiguration()
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("Failed to get default video device")
            return
        }
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
            } else {
                print("Failed to add video device input to session")
                return
            }
        } catch {
            print("Failed to create video device input: \(error)")
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            if let connection = videoOutput.connection(with: .video) {
                connection.videoRotationAngle = 90
            }
        } else {
            print("Failed to add video output to session")
            return
        }
        
        session.commitConfiguration()
        print("Camera setup complete")
    }
    
    // MARK: - 模型初始化
    private func initModel() {
        queue.async {
            do {
                self.headClassifier = try PoseClassifier(modelName: "Head")
                self.neckClassifier = try PoseClassifier(modelName: "Neck")
                self.shoulderClassifier = try PoseClassifier(modelName: "Shoulder")
                self.bodyClassifier = try PoseClassifier(modelName: "Body")
                self.feetClassifier = try PoseClassifier(modelName: "Feet")
                
                self.poseEstimator = try MoveNet(
                    threadCount: self.threadCount,
                    delegate: self.delegate,
                    modelType: self.modelType)
            } catch let error {
                os_log("Error: %@", log: .default, type: .error, String(describing: error))
            }
        }
    }
    
    // MARK: - 模型運算與視覺化處理
    private func runModel(_ pixelBuffer: CVPixelBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        guard !isRunning else { return }
        guard let estimator = poseEstimator else { return }
        guard let hClassifier = headClassifier,
              let nClassifier = neckClassifier,
              let sClassifier = shoulderClassifier,
              let bClassifier = bodyClassifier,
              let fClassifier = feetClassifier else { return }
        
        queue.async {
            self.isRunning = true
            defer { self.isRunning = false }
            
            do {
                let (result, times) = try estimator.estimateSinglePose(on: pixelBuffer)
                var (hResult, nResult, sResult, bResult, fResult) = ([Float32](), [Float32](), [Float32](), [Float32](), [Float32]())
                
                if self.isDetecting {
                    let flatLandmarks = result.toFlattenedArray()
                    hResult = hClassifier.classifyPose(landmarkData: flatLandmarks)
                    nResult = nClassifier.classifyPose(landmarkData: flatLandmarks)
                    sResult = sClassifier.classifyPose(landmarkData: flatLandmarks)
                    bResult = bClassifier.classifyPose(landmarkData: flatLandmarks)
                    fResult = fClassifier.classifyPose(landmarkData: flatLandmarks)
                }
                
                DispatchQueue.main.async {
                    self.person = result
                    
                    if result.score >= 0.2 {
                        self.cgImage = self.drawTool.drawPerson(person: result, cgImage: cgImage)
                    } else {
                        self.cgImage = cgImage
                    }
                    
                    // 傳送即時畫面給 WebRTC (後續會由 peerConnection 送出)
                    if let cgImage = self.cgImage {
                        self.sendFrameToWebRTC(cgImage)
                    }
                    
                    if self.isDetecting {
                        self.classifiedReslt = ["Head": hResult, "Neck": nResult, "Shoulder": sResult, "Body": bResult, "Feet": fResult]
                    }
                }
            } catch {
                os_log("Error running pose estimation.", type: .error)
            }
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
        runModel(pixelBuffer)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
    }
    
    // MARK: - Session Control
    func startSession() {
        videoQueue.async {
            self.session.startRunning()
            print("Camera session started")
        }
    }
    func stopSession() {
        videoQueue.async {
            self.session.stopRunning()
            print("Camera session stopped")
        }
    }
    func startDetection(){
        setupWebRTC()
        startBroadcast()
        isDetecting = true
    }
    func stopDetection(){
        stopBroadcast()
        isDetecting = false
    }
    func getCaptureSession() -> AVCaptureSession {
        return session
    }
    
    // MARK: - WebRTC 與 Signaling
    private func setupWebRTC() {
        let config = RTCConfiguration()
        // 加入 STUN server
        config.iceServers = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
        let constraints = RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        peerConnection = factory.peerConnection(with: config, constraints: constraints, delegate: self)
        
        // 初始化自訂 videoSource
        videoSource = factory.videoSource()
        videoCapturer = RTCCameraVideoCapturer(delegate: videoSource!)
        localVideoTrack = factory.videoTrack(with: videoSource!, trackId: "video0")
        
        // 將 videoTrack 加入 peer connection (streamId 可自訂)
        if let track = localVideoTrack {
            peerConnection?.add(track, streamIds: ["stream0"])
        }
    }
    
    /// 將 CGImage 轉成 CVPixelBuffer 並傳送給 WebRTC videoSource
    private func sendFrameToWebRTC(_ cgImage: CGImage) {
        guard let videoSource = videoSource else { return }
        
        let pixelBuffer = createPixelBuffer(from: cgImage)
        let rtcPixelBuffer = RTCCVPixelBuffer(pixelBuffer: pixelBuffer)
        let timeStampNs = Int64(CACurrentMediaTime() * 1_000_000_000)
        let rtcVideoFrame = RTCVideoFrame(buffer: rtcPixelBuffer, rotation: ._0, timeStampNs: timeStampNs)
        
        videoSource.capturer(videoCapturer!, didCapture: rtcVideoFrame)
    }
    
    private func createPixelBuffer(from cgImage: CGImage) -> CVPixelBuffer {
        let options: [NSString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true
        ]
        var pxBuffer: CVPixelBuffer?
        let width = cgImage.width
        let height = cgImage.height
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            options as CFDictionary,
            &pxBuffer
        )
        guard let pixelBuffer = pxBuffer else { fatalError("Failed to create pixel buffer") }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        let context = CGContext(
            data: CVPixelBufferGetBaseAddress(pixelBuffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])
        return pixelBuffer
    }
    
    // MARK: - Signaling related function
    
    /// 外部觸發：開始廣播（例如按下按鈕時呼叫）
    func startBroadcast() {
        connectToSignalingServer()
        // 稍微延遲確保 WS 連線成功（或在 connectToSignalingServer 的 callback 中再呼叫 createAndSendOffer）
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.createAndSendOffer()
        }
    }
    
    func stopBroadcast() {
        // 關閉 WebSocket 連線
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        
        // 關閉 WebRTC 連線
        peerConnection?.close()
        peerConnection = nil
    }
    /// 連線到 signaling server
    private func connectToSignalingServer() {
        let jwtToken = TokenService.shared.retrieveToken(for: .accessToken)
        var urlComponents = URLComponents(string: "\(Config.shared.wsBaseURL)/ws/phone")!
        urlComponents.queryItems = [ URLQueryItem(name: "token", value: jwtToken) ]
        
        guard let url = urlComponents.url else { return }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        listenToWebSocket()
    }

    /// 持續監聽 WebSocket 資料
    private func listenToWebSocket() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleWebSocketMessage(text)
                default:
                    print("Received non-string message")
                }
            }
            self?.listenToWebSocket()
        }
    }
    
    /// 解析從 signaling server 收到的 JSON 訊息
    private func handleWebSocketMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // 處理 SDP 訊息（通常是 web 端傳來的 answer）
                if let sdpDict = json["sdp"] as? [String: Any],
                   let typeString = sdpDict["type"] as? String,
                   let sdp = sdpDict["sdp"] as? String {
                    let sdpType: RTCSdpType = (typeString == "offer") ? .offer : .answer
                    let sessionDescription = RTCSessionDescription(type: sdpType, sdp: sdp)
                    peerConnection?.setRemoteDescription(sessionDescription, completionHandler: { error in
                        if let error = error {
                            print("Failed to set remote description: \(error)")
                        } else {
                            print("Remote description set successfully")
                        }
                    })
                }
                // 處理 ICE candidate 訊息
                else if let iceDict = json["ice"] as? [String: Any],
                        let candidate = iceDict["candidate"] as? String,
                        let sdpMid = iceDict["sdpMid"] as? String,
                        let sdpMLineIndex = iceDict["sdpMLineIndex"] as? Int32 {
                    let rtcCandidate = RTCIceCandidate(sdp: candidate, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
                    peerConnection?.add(rtcCandidate){ _ in
                        print("rtc candidate was added to peerConnection!")
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    
    /// 建立 SDP offer 並傳送給 signaling server
    private func createAndSendOffer() {
        let constraints = RTCMediaConstraints(mandatoryConstraints: [
            "OfferToReceiveAudio": "false",
            "OfferToReceiveVideo": "false"
        ], optionalConstraints: nil)
        peerConnection?.offer(for: constraints, completionHandler: { [weak self] offer, error in
            if let error = error {
                print("Error creating offer: \(error)")
                return
            }
            guard let offer = offer else { return }
            self?.peerConnection?.setLocalDescription(offer, completionHandler: { error in
                if let error = error {
                    print("Error setting local description: \(error)")
                } else {
                    let typeString = (offer.type == .offer) ? "offer" : "answer"
                    let sdpDict: [String: Any] = [
                        "sdp": [
                            "type": typeString,
                            "sdp": offer.sdp
                        ]
                    ]
                    self?.sendSignalMessage(sdpDict)
                }
            })
        })
    }
    
    /// 透過 WebSocket 傳送 JSON 訊息（SDP 或 ICE candidate）
    private func sendSignalMessage(_ dict: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                webSocketTask?.send(.string(jsonString)) { error in
                    if let error = error {
                        print("WebSocket send error: \(error)")
                    }
                }
            }
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }
}

// MARK: - RTCPeerConnectionDelegate
extension CameraManager: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange state: RTCSignalingState) {
        print("Signaling state changed: \(state)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        // not used on sender side
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        // not used on sender side
    }
    
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        // negotiation needed if required
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        print("ICE connection state changed: \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        print("ICE gathering state changed: \(newState)")
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        // 當產生 candidate 時，送出給 signaling server
        let iceDict: [String: Any] = [
            "ice": [
                "candidate": candidate.sdp,
                "sdpMid": candidate.sdpMid ?? "",
                "sdpMLineIndex": candidate.sdpMLineIndex
            ]
        ]
        sendSignalMessage(iceDict)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        // 可以實作 candidate 移除邏輯
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        // 如果使用 data channel，這裡可作處理
    }
}

// MARK: - URLSessionWebSocketDelegate
extension CameraManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?) {
        print("WebSocket connected")
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?) {
        print("WebSocket disconnected")
    }
}
