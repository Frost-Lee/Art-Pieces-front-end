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
    
    var color: UIColor!
    var width: CGFloat!
    var texture: String?
    
    init(color: UIColor, width: CGFloat, texture: String? = nil) {
        self.color = color
        self.width = width
        self.texture = texture
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorData = try container.decode(Data.self, forKey: .color)
        self.color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        self.width = try container.decode(CGFloat.self, forKey: .width)
        self.texture = try container.decode(String.self, forKey: .texture)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
        try container.encode(colorData, forKey: .color)
        try container.encode(width, forKey: .width)
        try container.encode(texture, forKey: .texture)
    }
    
    func getTexture() -> UIColor {
        if let consolidateTexture = texture {
            var textureImage = UIImage(named: consolidateTexture)
            textureImage = textureImage?.tint(color: color, blendMode: .destinationOver)
            return UIColor(patternImage: textureImage!)
        } else {
            return color
        }
    }
    
    func getWidth() -> CGFloat {
        return width
    }
    
    enum CodingKeys: String, CodingKey {
        case color
        case width
        case texture
    }
    
}

var defaultRenderMechanism = RenderMechanism(color: .black, width: 1)

func render(stroke: Stroke?) {
    if stroke == nil {return}
    guard let context = UIGraphicsGetCurrentContext() else {return}
    let color = stroke!.renderMechanism.getTexture()
    context.setLineWidth(stroke!.renderMechanism.width)
    context.setStrokeColor(color.cgColor)
    context.setLineCap(.round)
    context.setLineJoin(.round)
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

extension UIImage {
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
