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
    
    func drawPerson(person: Person, cgImage: CGImage) -> CGImage? {
        /// TODO: 參照影片的github code畫在perviewLayer上面
        let image = UIImage(cgImage: cgImage)
        let renderer = UIGraphicsImageRenderer(size: image.size)
        guard let strokes = strokes(from: person) else { return cgImage}
        
        let newImage = renderer.image{ context in
            image.draw(at: .zero)
            
            var cgContext = context.cgContext
            cgContext = drawLines(cgContext: cgContext, lines: strokes.lines)
            cgContext = drawDots(cgContext: cgContext, dots: strokes.dots)
            
        }
        return newImage.cgImage
    }
    func drawLines(cgContext: CGContext, lines: [Line])->CGContext{
        for line in lines{
            
            let linePath = UIBezierPath()
            linePath.move(to: line.from)
            linePath.addLine(to: line.to)
            
            cgContext.addPath(linePath.cgPath)
            cgContext.setStrokeColor(Config.line.color)
            cgContext.setLineWidth(Config.line.width)
            cgContext.strokePath()

        }
        return cgContext
    }
    func drawDots(cgContext: CGContext, dots: [CGPoint])->CGContext{
        for dot in dots {
            let circlePath = UIBezierPath(arcCenter: dot, radius: Config.dot.radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
            cgContext.addPath(circlePath.cgPath)
            cgContext.setFillColor(Config.dot.color)
            cgContext.fillPath()
        }
        return cgContext
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
