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

class StrokeGestureRecognizer: UIGestureRecognizer {
    
    var coordinateSpaceView: UIView!
    var trackedTouch: UITouch?
    
    var initialTimestamp: TimeInterval?
    var fingerStartTimer: Timer? = nil
    let cancellationTimeInterval = TimeInterval(0.1)
    
    var stroke: Stroke!
    var renderMechanism: RenderMechanism! {
        didSet {
            stroke.renderMechanism = renderMechanism
        }
    }
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        stroke = Stroke(renderMechanism: defaultRenderMechanism)
        renderMechanism = defaultRenderMechanism
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if trackedTouch == nil {
            trackedTouch = touches.first
            initialTimestamp = trackedTouch?.timestamp
            fingerStartTimer = Timer.scheduledTimer(timeInterval: cancellationTimeInterval,
                                                    target: self, selector: #selector(beginIfNeeded(_:)),
                                                    userInfo: nil, repeats: false)
        }
        workingGestureMoved(touches: touches, event: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if workingGestureMoved(touches: touches, event: event) {
            if state == .began {
                state = .changed
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if workingGestureMoved(touches: touches, event: event) {
            stroke.state = .done
            state = .ended
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        if workingGestureMoved(touches: touches, event: event) {
            stroke.state = .cancelled
            state = .failed
        }
    }
    
    override func reset() {
        stroke = Stroke(renderMechanism: renderMechanism)
        trackedTouch = nil
        super.reset()
    }
    
    @objc private func beginIfNeeded(_ timer: Timer) {
        if state == .possible {
            state = .began
        }
    }
    
    @discardableResult
    func workingGestureMoved(touches: Set<UITouch>, event: UIEvent) -> Bool {
        if let touchToAppend = trackedTouch {
            for touch in touches {
                if touch !== touchToAppend && touch.timestamp - initialTimestamp!
                    < cancellationTimeInterval {
                    state = (state == .possible) ? .failed : .cancelled
                    return false
                }
            }
            if touches.contains(touchToAppend) {
                let location = touchToAppend.preciseLocation(in: coordinateSpaceView)
                let timestamp = touchToAppend.timestamp
                if let previousSample = stroke.samples.last {
                    if (previousSample.location - location).quadrance < 0.003 {
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
}
