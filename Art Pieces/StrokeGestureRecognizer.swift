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
    
    var stroke = Stroke()
    var coordinateSpaceView: UIView!
    
    var trackedTouch: UITouch?
    var initialTimestamp: TimeInterval?
    
    var fingerStartTimer: Timer? = nil
    
    private let cancellationTimeInterval = TimeInterval(0.1)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.trackedTouch == nil {
            self.trackedTouch = touches.first
            self.initialTimestamp = trackedTouch?.timestamp
            self.fingerStartTimer = Timer.scheduledTimer(timeInterval: cancellationTimeInterval,
                                        target: self, selector: #selector(beginIfNeeded(_:)),
                                        userInfo: nil, repeats: false)
        }
        append(touches: touches, event: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if append(touches: touches, event: event) {
            if state == .began {
                state = .changed
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if append(touches: touches, event: event) {
            stroke.state = .done
            state = .ended
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        if append(touches: touches, event: event) {
            stroke.state = .cancelled
            state = .failed
        }
    }
    
    override func reset() {
        self.stroke = Stroke()
        self.trackedTouch = nil
        super.reset()
    }
    
    @objc func beginIfNeeded(_ timer: Timer) {
        if state == .possible {
            state = .began
        }
    }
    
    @discardableResult
    private func append(touches: Set<UITouch>, event: UIEvent?) -> Bool {
        if let touchToAppend = self.trackedTouch {
            for touch in touches {
                if touch !== touchToAppend && touch.timestamp - self.initialTimestamp!
                    < self.cancellationTimeInterval {
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
                self.stroke.add(sample: sample)
                return true
            }
        }
        return false
    }
    
    
    
}
