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

func render(stroke: Stroke?) {
    if stroke == nil {return}
    guard let context = UIGraphicsGetCurrentContext() else {return}
    context.setLineWidth(0.25)
    context.setStrokeColor(UIColor.black.cgColor)
    for arc in stroke! {
        context.move(to: arc.sampleBefore.location)
        context.addLine(to: arc.sampleAfter.location)
    }
    context.closePath()
    context.drawPath(using: .stroke)
}
