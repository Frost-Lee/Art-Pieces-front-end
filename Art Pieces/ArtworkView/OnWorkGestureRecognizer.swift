//
//  OnWorkGestureRecognizer.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/18.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class OnWorkGestureRecognizer: UIGestureRecognizer {
    
    var coordinateSpaceView: UIView!
    var trackedTouch: UITouch?
    
    var initialTimestamp: TimeInterval?
    var fingerStartTimer: Timer? = nil
    let cancellationTimeInterval = TimeInterval(0.1)
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        onWorkGestureRecognizerDidLoad()
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
            workingGestureFinished(touches: touches, event: event)
            state = .ended
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        if workingGestureMoved(touches: touches, event: event) {
            workingGestureCancelled(touches: touches, event: event)
            state = .failed
        }
    }
    
    override func reset() {
        workingGestureWillReset()
        trackedTouch = nil
        super.reset()
    }
    
    @objc private func beginIfNeeded(_ timer: Timer) {
        if state == .possible {
            state = .began
        }
    }
    
    func onWorkGestureRecognizerDidLoad() {}
    
    @discardableResult
    func workingGestureMoved(touches: Set<UITouch>, event: UIEvent?) -> Bool {return false}
    
    func workingGestureCancelled(touches: Set<UITouch>, event: UIEvent?) {}
    
    func workingGestureFinished(touches: Set<UITouch>, event: UIEvent?) {}
    
    func workingGestureWillReset() {}
    
    
    
}
