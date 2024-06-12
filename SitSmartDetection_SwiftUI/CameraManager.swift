import AVFoundation
import UIKit
import SwiftUI
import os

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var frame: UIImage?
    @Published var person: Person?
    @Published var classifiedReslt:[String:poseClassfiedResult]?
    private let session = AVCaptureSession()
    private var poseEstimator: PoseEstimator?
    private let videoQueue = DispatchQueue(label: "videoQueue")

    private var modelType: ModelType = .movenetThunder
    private var threadCount: Int = 4
    private var delegate: Delegates = .gpu
    private let minimumScore = 0.2
    
    let queue = DispatchQueue(label: "serial_queue")
    var isRunning = false
    
    // Pose classifier
    private var headClassifier:PoseClassifier?
    private var neckClassifier:PoseClassifier?
    private var shoulderClassifier:PoseClassifier?
    private var bodyClassifier:PoseClassifier?
    private var feetClassifier:PoseClassifier?
    
    override init() {
        super.init()
        updateModel()
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
                connection.videoOrientation = .portrait
            }
        } else {
            print("Failed to add video output to session")
            return
        }

        session.commitConfiguration()
        print("Camera setup complete")
    }

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
    func getCaptureSession() -> AVCaptureSession {
        return session
    }

    private func updateModel() {
        queue.async {
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
                let hResult = hClassifier.classifyPose(landmarkData: result.toFlattenedArray()) ?? poseClassfiedResult(category: "", prob: 0)
                let nResult = nClassifier.classifyPose(landmarkData: result.toFlattenedArray()) ?? poseClassfiedResult(category: "", prob: 0)
                let sResult = sClassifier.classifyPose(landmarkData: result.toFlattenedArray()) ?? poseClassfiedResult(category: "", prob: 0)
                let bResult = bClassifier.classifyPose(landmarkData: result.toFlattenedArray()) ?? poseClassfiedResult(category: "", prob: 0)
                let fResult = fClassifier.classifyPose(landmarkData: result.toFlattenedArray()) ?? poseClassfiedResult(category: "", prob: 0)
                DispatchQueue.main.async {
                    self.frame = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
                    self.person = result
                    self.classifiedReslt = ["head": hResult, "neck": nResult, "shoulder": sResult, "body":bResult, "feet":fResult]
                }
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
}

struct poseClassfiedResult{
    let category:String
    let prob:Float32
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


