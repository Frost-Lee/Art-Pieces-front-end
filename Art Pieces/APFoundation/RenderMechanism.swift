//
//  RenderMechanism.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/14.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  RenderMechanism contains the method used for rendering the stroke according to its sample points.

import Foundation
import UIKit

struct RenderMechanism: Codable {
    
    var color: UIColor! {
        didSet {
            setTexturedColor()
        }
    }
    var width: CGFloat!
    var texture: String? {
        didSet {
            setTexturedColor()
        }
    }
    var minimumWidth: Float {
        return 1
    }
    var maximunWidth: Float {
        if Tool.toolOfTexture(texture) == .pencil {
            return 2
        } else {
            return 5
        }
    }
    var isEraseMode: Bool = false
    
    var texturedColor: UIColor? = nil
    
    init(color: UIColor, width: CGFloat, texture: String? = nil) {
        self.color = color
        self.width = width
        self.texture = texture
        setTexturedColor()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorData = try container.decode(Data.self, forKey: .color)
        self.color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        self.width = try container.decode(CGFloat.self, forKey: .width)
        self.texture = try container.decode(String.self, forKey: .texture)
        setTexturedColor()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
        try container.encode(colorData, forKey: .color)
        try container.encode(width, forKey: .width)
        try container.encode(texture, forKey: .texture)
    }
    
    func getTexture() -> UIColor {
        if texturedColor != nil {
            return texturedColor!
        } else {
            return color
        }
    }
    
    func getWidth() -> CGFloat {
        return width
    }
    
    private mutating func setTexturedColor() {
        if let texturePath = texture {
            var textureImage = UIImage(named: texturePath)
            textureImage = textureImage?.tint(color: color, blendMode: .lighten)
            texturedColor = UIColor(patternImage: textureImage!)
        } else {
            texturedColor = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case color
        case width
        case texture
    }
    
}

var defaultRenderMechanism = RenderMechanism(color: .black, width: 1)

func getEraser(with size: CGFloat) -> RenderMechanism {
    var eraser = defaultRenderMechanism
    eraser.color = UIColor.clear
    eraser.isEraseMode = true
    eraser.width = size
    return eraser
}

func render(stroke: Stroke?) {
    guard let stroke = stroke else {return}
    guard let context = UIGraphicsGetCurrentContext() else {return}
    let color = stroke.renderMechanism.getTexture()
    if stroke.renderMechanism.isEraseMode {
        context.setBlendMode(.clear)
    } else {
        context.setBlendMode(CGBlendMode.color)
    }
    context.setLineWidth(stroke.renderMechanism.width)
    context.setStrokeColor(color.cgColor)
    context.setLineCap(.round)
    context.setLineJoin(.round)
    for arc in stroke {
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
