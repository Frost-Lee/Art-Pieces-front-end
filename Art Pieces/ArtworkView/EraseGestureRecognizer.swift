//
//  EraseGestureRecognizer.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/18.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  EraseGestureRecognizer identifies erase gestures in artwork view, by calling delegate methods, strokes in
//  artwork view would be erased

import UIKit

protocol EraseDelegate {
    func eraseDetected(at sample: StrokeSample)
}

class EraseGestureRecognizer: OnWorkGestureRecognizer {
    
    var eraseDelegate: EraseDelegate!
    
    override func workingGestureMoved(trackedTouch: UITouch) {
        let location = trackedTouch.preciseLocation(in: coordinateSpaceView)
        let timestamp = trackedTouch.timestamp
        eraseDelegate.eraseDetected(at: StrokeSample(timeStamp: timestamp, location: location))
    }
    
}
