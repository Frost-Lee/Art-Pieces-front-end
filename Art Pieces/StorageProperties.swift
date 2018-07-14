//
//  StorageProperties.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/13.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  This file contains the storage properties of a single drawing, include stroke sample, stroke, stroke layer,
//  etc. The structs / classes are all serializable

import Foundation
import UIKit


enum StrokePhase: Int, Codable {
    case begin
    case changed
    case ended
    case cancelled
}

enum StrokeState: Int, Codable {
    case active
    case done
    case cancelled
}

/**
 * StrokeSample is a single that records a single point of the user's touch on the screen
 * it contains the location and the time stamp data of a single touch
 */
struct StrokeSample: Codable {
    
    // Must-have properties
    let timeStamp: TimeInterval
    let location: CGPoint
    
    init(timeStamp: TimeInterval, location: CGPoint) {
        self.timeStamp = timeStamp
        self.location = location
    }
}


class Stroke: Codable {
    
    var samples: [StrokeSample] = []
    var state: StrokeState = .active
    
    func add(sample: StrokeSample) {
        self.samples.append(sample)
    }
    
}

