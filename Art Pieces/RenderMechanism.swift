//
//  RenderMechanism.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/14.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import Foundation
import UIKit

class RenderMechanism: Codable {
    
}

//func render(stroke: Stroke?) {
//    if stroke == nil {return}
//    guard let context = UIGraphicsGetCurrentContext() else {return}
//    context.setLineWidth(0.25)
//    context.setStrokeColor(UIColor.black.cgColor)
//    for arc in stroke! {
//        context.move(to: arc.sampleBefore.location)
//        context.addLine(to: arc.sampleAfter.location)
//    }
//    context.closePath()
//    context.drawPath(using: .stroke)
//}

func render(stroke: Stroke?) {
    if stroke == nil {return}
    guard let context = UIGraphicsGetCurrentContext() else {return}
    context.setLineWidth(0.25)
    context.setStrokeColor(UIColor.black.cgColor)
    for arc in stroke! {
        let midPoint_1 = getMidPoint(between: arc.sampleBefore.location, and: arc.sample.location)
        let midPoint_2 = getMidPoint(between: arc.sample.location, and: arc.sampleAfter.location)
        context.move(to: midPoint_1)
        context.addQuadCurve(to: midPoint_2, control: arc.sample.location)
    }
    context.closePath()
    context.drawPath(using: .stroke)
}

private func getMidPoint(between point1: CGPoint, and point2: CGPoint) -> CGPoint {
    let x = (point1.x + point2.x) / 2.0
    let y = (point1.y + point2.y) / 2.0
    return CGPoint(x: x, y: y)
}
