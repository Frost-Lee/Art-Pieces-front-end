//
//  CGMathExtension.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/15.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGVector {
    var quadrance: CGFloat {
        return dx * dx + dy * dy
    }
}


func -(left: CGPoint, right:CGPoint) -> CGVector {
    return CGVector(dx: left.x - right.x, dy: left.y - right.y)
}
