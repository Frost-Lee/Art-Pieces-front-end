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

/**
 * Stroke represents a single stroke on a painting, it's consists of stroke samples, and provides the render
 * information about the stroke
 */
class Stroke: Codable, Sequence {
    
    var samples: [StrokeSample] = []
    var state: StrokeState = .active
    
    func add(sample: StrokeSample) {
        self.samples.append(sample)
    }
    
    func makeIterator() -> StrokeArcIterator {
        return StrokeArcIterator(stroke: self)
    }
    
}

class StrokeArc {
    
    var sampleBefore: StrokeSample
    var sampleAfter: StrokeSample
    
    init(sampleBefore: StrokeSample, sampleAfter: StrokeSample) {
        self.sampleBefore = sampleBefore
        self.sampleAfter = sampleAfter
    }
    
}


/**
 * Layer is the layer in the painting, each layer is separate physically
 */
class Layer: Codable {
    var identifier: String = "new layer"
    var strokes: [Stroke] = []
    
    func add(stroke: Stroke) {
        self.strokes.append(stroke)
    }
}

/**
 * SubStep contains the pointers (actually indices of layer and stroke) to the strokes with same color and
 * texture
 */
class SubStep: Codable, Sequence {
    
    var renderDescription: String = "no render description"
    var relatedOperationLayer: [Int] = []
    var relatedOperationStroke: [Int] = []
    var renderMechanism: RenderMechanism
    
    func add(layerIndex: Int, strokeIndex: Int) {
        self.relatedOperationLayer.append(layerIndex)
        self.relatedOperationStroke.append(strokeIndex)
    }
    
    func remove(at index: Int) {
        self.relatedOperationLayer.remove(at: index)
        self.relatedOperationStroke.remove(at: index)
    }
    
    func setRenderMechanism(with mechanism: RenderMechanism) {
        self.renderMechanism = mechanism
    }
    
    func makeIterator() -> SubStepContentIterator {
        return SubStepContentIterator(subStep: self)
    }
    
}

/**
 * Step is the collection of SubStep, it contains multiple sub steps, that means it may be related with multiple
 * color and texture of strokes
 */
class Step: Codable {
    
    var description: String = "no description"
    var subSteps: [SubStep] = []
    
    func add(subStep: SubStep) {
        self.subSteps.append(subStep)
    }
}



class ArtworkGuide: Codable {
    
    var steps: [Step] = []
    
    func add(step: Step) {
        self.steps.append(step)
    }
}


/**
 * Artwork is the top level of stroage, each Artwork correspond to a painting, an Artwork is consisted of
 * multiple stroke layers
 */
class Artwork: Codable {
    
    var identifier: String = "new artwork"
    var layers: [Layer] = []
    var guide: ArtworkGuide? = nil
    
    func add(layer: Layer) {
        self.layers.append(layer)
    }
}



// MARK: Supportive classes
class SubStepContentIterator: IteratorProtocol {
    
    private let subStep: SubStep
    private var nextIndex: Int = 0
    
    init(subStep: SubStep) {
        self.subStep = subStep
    }
    
    func next() -> (Int, Int)? {
        if nextIndex >= subStep.relatedOperationLayer.count {
            return nil
        }
        let result = (subStep.relatedOperationLayer[nextIndex], subStep.relatedOperationStroke[nextIndex])
        nextIndex += 1
        return result
    }
    
}

class StrokeArcIterator: IteratorProtocol {
    
    private let stroke: Stroke
    private var nextIndex: Int = 0
    
    init(stroke: Stroke) {
        self.stroke = stroke
    }
    
    func next() -> StrokeArc? {
        if nextIndex >= stroke.samples.count - 1 {
            return nil
        }
        let result = StrokeArc(sampleBefore: stroke.samples[nextIndex],
                               sampleAfter: stroke.samples[nextIndex + 1])
        nextIndex += 1
        return result
    }
    
}
