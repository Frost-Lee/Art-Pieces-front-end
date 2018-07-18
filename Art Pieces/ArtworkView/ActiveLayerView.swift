//
//  ActiveLayerView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/17.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  ActiveLayerView contains the layer which the user is interacting with, after each stroke complete, only
//  strokes in the active layer would be redrawn. The background color is set to lucency so that it would
//  go well with the real background

import UIKit

class ActiveLayerView: UIView {
    
    var activeStrokeView: SingleStrokeView!
    var strokes: [Stroke] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        activeStrokeView = SingleStrokeView(frame: frame)
        self.addSubview(activeStrokeView)
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rerender() {
        for stroke in strokes {
            render(stroke: stroke)
        }
    }
    
    func mergeActiveStroke() {
        if let newStroke = activeStrokeView.stroke {
            strokes.append(newStroke)
        }
        activeStrokeView.stroke = nil
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        rerender()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
