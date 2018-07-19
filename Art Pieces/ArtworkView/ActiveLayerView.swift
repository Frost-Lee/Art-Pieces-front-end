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
    
    override func draw(_ rect: CGRect) {
        rerender()
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
    
    func handleErase(at sample: StrokeSample, for radius: CGFloat) {
        var strokeBuffer: [Stroke] = []
        for stroke in strokes {
            let splittedStrokes = executeErase(on: stroke, at: sample, for: radius)
            strokeBuffer += splittedStrokes
        }
        strokes = strokeBuffer
        setNeedsDisplay()
    }
    
    private func executeErase(on stroke: Stroke, at sample: StrokeSample, for radius: CGFloat) -> [Stroke] {
        var result: [Stroke] = []
        var tempStroke: Stroke = Stroke(renderMechanism: stroke.renderMechanism)
        let eraseLocation = sample.location
        for sample in stroke.samples {
            if sample.within(center: eraseLocation, radius: radius) {
                if tempStroke.samples.count != 0 {
                    result.append(tempStroke)
                }
                tempStroke = Stroke(renderMechanism: stroke.renderMechanism)
            } else {
                tempStroke.add(sample: sample)
            }
        }
        if tempStroke.samples.count != 0 {
            result.append(tempStroke)
        }
        return result
    }

}
