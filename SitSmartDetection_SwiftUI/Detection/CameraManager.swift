import AVFoundation
import UIKit
import SwiftUI
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
    private let videoQueue = DispatchQueue(label: "videoQueue") // allow run capture session on bg thread
    
    // movenet settings
    private var poseEstimator: PoseEstimator? // movenet
    private var modelType: ModelType = .movenetThunder
    private var threadCount: Int = 4
    private var delegate: Delegates = .gpu
    private let minimumScore = 0.2 // min bound to show detection rst
    
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
        initModel()
        checkCameraAuthorization()
    }
    
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
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { // TODO: dual position must be accepted
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
        
        let videoOutput = AVCaptureVideoDataOutput() // Data output sends frames to CMSampleBuffer and notify SampleBufferDelegate the frame is arrived, and the delegate read frame from sampleBuffer
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput) //
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
    
    private func initModel() {
        queue.async { // 將模型初始化放到背景執行，防止堵塞Main thread
            do {
                // init pose classifier
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
    
    private func runModel(_ pixelBuffer: CVPixelBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        guard !isRunning else { return }
        guard let estimator = poseEstimator else { return }
        guard let hClassifier = headClassifier else { return }
        guard let nClassifier = neckClassifier else { return }
        guard let sClassifier = shoulderClassifier else { return }
        guard let bClassifier = bodyClassifier else { return }
        guard let fClassifier = feetClassifier else { return }
        
        queue.async {
            self.isRunning = true
            defer { self.isRunning = false }
            
            do {
                let (result, times) = try estimator.estimateSinglePose(on: pixelBuffer)
                var (hResult, nResult, sResult, bResult, fResult) = ([Float32](), [Float32](), [Float32](), [Float32](), [Float32]());
                
                if (self.isDetecting){
                    hResult = hClassifier.classifyPose(landmarkData: result.toFlattenedArray())
                    nResult = nClassifier.classifyPose(landmarkData: result.toFlattenedArray())
                    sResult = sClassifier.classifyPose(landmarkData: result.toFlattenedArray())
                    bResult = bClassifier.classifyPose(landmarkData: result.toFlattenedArray())
                    fResult = fClassifier.classifyPose(landmarkData: result.toFlattenedArray())
                }
                DispatchQueue.main.async { // data for UI
                    self.person = result
                    
                    if result.score >= 0.2{
                        self.cgImage = self.drawTool.drawPerson(person: result, cgImage: cgImage)
                    }else{
                        self.cgImage = cgImage
                    }
                    if self.isDetecting {
                        self.classifiedReslt = ["Head": hResult, "Neck": nResult, "Shoulder": sResult, "Body":bResult, "Feet":fResult]
                    }
                }
//                // Debug: to monitor the latency
//                print(times)
            } catch {
                os_log("Error running pose estimation.", type: .error)
            }
        }
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
        runModel(pixelBuffer)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
    }
    
    // Setting functions
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
        isDetecting = true
    }
    func stopDetection(){
        isDetecting = false
//        timerSubscription?.cancel()
//        timerSubscription = nil
    }
    func getCaptureSession() -> AVCaptureSession {
        return session
    }
    
}

