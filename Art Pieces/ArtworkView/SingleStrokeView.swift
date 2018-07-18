//
//  SingleStrokeView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/15.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  The SingleStrokeView is used for rendering the stroke that is currently drawing. Each time a new sample is
//  attached, the view have to be redrawn.

import UIKit

class SingleStrokeView: UIView {
    
    var stroke: Stroke? {
        didSet {
            if stroke != nil {
                setNeedsDisplay()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        render(stroke: stroke)
    }

}
