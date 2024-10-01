//
//  postureClassifier.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/6/12.
//
import TensorFlowLite

let modelCategories: [String: [String]] = [
    "Body": ["Backward", "Forward", "Neutral"],
    "Feet": ["Ankle-on-knee", "Flat"],
    "Head": ["Bowed", "Neutral", "Tilt Back"],
    "Shoulder": ["Hunched", "Neutral", "Shrug"],
    "Neck": ["Forward", "Neutral"]
]

class PoseClassifier {
    private var interpreter: Interpreter
    private var categories: [String]

    init(modelName: String) throws {
        // 加载 TensorFlow Lite 模型
        let modelPath = Bundle.main.path(forResource: modelName, ofType: "tflite")!
        interpreter = try Interpreter(modelPath: modelPath)
        try interpreter.allocateTensors()
        
        // 获取对应的类别
        guard let categories = modelCategories[modelName] else {
            throw NSError(domain: "Invalid model name", code: 1, userInfo: nil)
        }
        self.categories = categories
    }
    
    /// 輸入Movenet的關鍵點資訊(, 51)
    /// 輸出為機率分布陣列
    func classifyPose(landmarkData: [Float]) -> [Float32] {
        // 确保输入数据长度正确
        guard landmarkData.count == 51 else {
            print("Invalid input data length: expected 51, got \(landmarkData.count)")
            return []
        }

        do {
            // 将输入数据复制到输入张量
            let inputData = Data(copyingBufferOf: landmarkData)
            try interpreter.copy(inputData, toInputAt: 0)

            // 运行推理
            try interpreter.invoke()

            // 获取输出张量
            let outputTensor = try interpreter.output(at: 0)

            // 将输出张量的数据转换为 Float 数组
            let outputData = outputTensor.data
            return outputData.toArray(type: Float32.self)

            
//            // 回傳最高機率的類別
//            if let maxProbability = results.max(),
//               let maxIndex = results.firstIndex(of: maxProbability) {
//                let category = categories[maxIndex]
//                return poseClassfiedResult(category: category, prob: maxProbability)
//            } else {
//                return nil
//            }
        } catch {
            print("Error during pose classification: \(error)")
            return []
        }
    }
}


//extension Data {
//    /// Initialize Data from a buffer of a generic type
//    init<T>(copyingBufferOf array: [T]) {
//        self = array.withUnsafeBufferPointer(Data.init)
//    }
//
//    /// Convert Data to an array of the given type
//    func toArray<T>(type: T.Type) -> [T] {
//        var array = [T](repeating: T(), count: self.count / MemoryLayout<T>.stride)
//        _ = array.withUnsafeMutableBytes { self.copyBytes(to: $0) }
//        return array
//    }
//}

//// 使用示例
//do {
//    // 创建 PoseClassifier 实例
//    let modelPath = Bundle.main.path(forResource: "model", ofType: "tflite")!
//    let classifier = try PoseClassifier(modelPath: modelPath)
//
//    // 假设你已经有一个一维数组的关键点数据
//    let landmarkData: [Float] = Array(repeating: 0.0, count: 51) // 这只是一个示例，你需要用实际数据替换
//
//    // 运行推理
//    if let results = classifier.classifyPose(landmarkData: landmarkData) {
//        print("Pose classification results: \(results)")
//    } else {
//        print("Failed to classify pose")
//    }
//} catch {
//    print("Failed to initialize PoseClassifier: \(error)")
//}
