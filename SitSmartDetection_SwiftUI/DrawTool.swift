//
//  DrawTool.swift
//  SitSmartDetection_SwiftUI
//
//  Created by 林君曆 on 2024/7/24.
//

import Foundation
import UIKit
import os


class DrawTool{
    private enum Config {
        static let dot = (radius: CGFloat(10), color: UIColor.orange.cgColor)
        static let line = (width: CGFloat(5.0), color: UIColor.orange.cgColor)
    }

    /// List of lines connecting each part to be visualized.
    private static let lines = [
      (from: BodyPart.leftWrist, to: BodyPart.leftElbow),
      (from: BodyPart.leftElbow, to: BodyPart.leftShoulder),
      (from: BodyPart.leftShoulder, to: BodyPart.rightShoulder),
      (from: BodyPart.rightShoulder, to: BodyPart.rightElbow),
      (from: BodyPart.rightElbow, to: BodyPart.rightWrist),
      (from: BodyPart.leftShoulder, to: BodyPart.leftHip),
      (from: BodyPart.leftHip, to: BodyPart.rightHip),
      (from: BodyPart.rightHip, to: BodyPart.rightShoulder),
      (from: BodyPart.leftHip, to: BodyPart.leftKnee),
      (from: BodyPart.leftKnee, to: BodyPart.leftAnkle),
      (from: BodyPart.rightHip, to: BodyPart.rightKnee),
      (from: BodyPart.rightKnee, to: BodyPart.rightAnkle),
    ]
    
    func drawPerson(person: Person) -> CALayer{
        /// TODO: 參照影片的github code畫在perviewLayer上面
        var detectionLayer = CALayer()
        
        guard let strokes = strokes(from: person) else { return detectionLayer}
        detectionLayer = drawLines(at: detectionLayer, lines: strokes.lines)
        detectionLayer = drawDots(at: detectionLayer, dots: strokes.dots)
        
        return detectionLayer
    }
    func drawLines(at layer: CALayer , lines: [Line])->CALayer{
        for line in lines{
            let linePath = UIBezierPath()
            linePath.move(to: line.from)
            linePath.addLine(to: line.to)
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = linePath.cgPath
            lineLayer.strokeColor = Config.line.color
            lineLayer.lineWidth = Config.line.width
            layer.addSublayer(lineLayer)
        }
        return layer
    }
    func drawDots(at layer: CALayer, dots: [CGPoint])->CALayer{
        for dot in dots {
            let shapeLayer = CAShapeLayer()
            let circlePath = UIBezierPath(arcCenter: dot, radius: Config.dot.radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = Config.dot.color
            
            layer.addSublayer(shapeLayer)
        }
        return layer
    }
    
    func drawBoundingBox(_ bounds: CGRect) -> CALayer {
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        boxLayer.cornerRadius = 4
        return boxLayer
    }
    private func strokes(from person: Person) -> Strokes? {
      var strokes = Strokes(dots: [], lines: []) //
      // MARK: Visualization of detection result
      var bodyPartToDotMap: [BodyPart: CGPoint] = [:] // 每個關鍵點對應的的座標(x, y)
      for (index, part) in BodyPart.allCases.enumerated() {
        let position = CGPoint(
          x: person.keyPoints[index].coordinate.x,
          y: person.keyPoints[index].coordinate.y)
        bodyPartToDotMap[part] = position // 建立每個部位的映射關係
        strokes.dots.append(position) // 同時把座標append入回傳的strokes
      }

      do {
          try strokes.lines = DrawTool.lines.map { map throws -> Line in // 如果有錯回傳Line
          guard let from = bodyPartToDotMap[map.from] else {
            throw VisualizationError.missingBodyPart(of: map.from)
          }
          guard let to = bodyPartToDotMap[map.to] else {
            throw VisualizationError.missingBodyPart(of: map.to)
          }
          return Line(from: from, to: to)
        }
      } catch VisualizationError.missingBodyPart(let missingPart) {
        os_log("Visualization error: %s is missing.", type: .error, missingPart.rawValue)
        return nil
      } catch {
        os_log("Visualization error: %s", type: .error, error.localizedDescription)
        return nil
      }
      return strokes
    }
}
