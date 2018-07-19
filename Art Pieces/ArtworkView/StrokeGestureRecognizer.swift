//
//  StrokeGestureRecognizer.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/14.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  StrokeGestureRecognizer is used in a view that would collect the user's drawing gestures and convert the
//  data into StrokeSample informations

import UIKit

class StrokeGestureRecognizer: OnWorkGestureRecognizer {
    
    var stroke: Stroke!
    var renderMechanism: RenderMechanism! {
        didSet {
            stroke.renderMechanism = renderMechanism
        }
    }
    
    override func onWorkGestureRecognizerDidLoad() {
        stroke = Stroke(renderMechanism: defaultRenderMechanism)
        renderMechanism = defaultRenderMechanism
    }
    
    override func workingGestureMoved(touches: Set<UITouch>, event: UIEvent?) -> Bool {
        if let touchToAppend = trackedTouch {
            for touch in touches {
                if touch !== touchToAppend && touch.timestamp - initialTimestamp!
                    < cancellationTimeInterval {
                    state = (state == .possible) ? .failed : .cancelled
                    return false
                }
            }
            if touches.contains(touchToAppend) {
                let location = touchToAppend.preciseLocation(in: self.coordinateSpaceView)
                let timestamp = touchToAppend.timestamp
                if let previoudSample = self.stroke.samples.last {
                    if (previoudSample.location - location).quadrance < 0.003 {
                        return true
                    }
                }
                let sample = StrokeSample(timeStamp: timestamp, location: location)
                stroke.add(sample: sample)
                return true
            }
        }
        return false
    }
    
    override func workingGestureFinished(touches: Set<UITouch>, event: UIEvent?) {
        stroke.state = .done
    }
    
    override func workingGestureCancelled(touches: Set<UITouch>, event: UIEvent?) {
        stroke.state = .cancelled
    }
    
    override func workingGestureWillReset() {
        stroke = Stroke(renderMechanism: renderMechanism)
    }
    
}

