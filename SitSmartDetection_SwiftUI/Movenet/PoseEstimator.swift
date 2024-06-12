//
//  PoseEstimator.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/6/11.
//

import UIKit
/// Protocol to  run a pose estimator.
protocol PoseEstimator {
  func estimateSinglePose(on pixelbuffer: CVPixelBuffer) throws -> (Person, Times)
}

// MARK: - Custom Errors
enum PoseEstimationError: Error {
  case modelBusy
  case preprocessingFailed
  case inferenceFailed
  case postProcessingFailed
}
