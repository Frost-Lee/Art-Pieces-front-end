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

enum OperationChange: Int, Codable {
    case colorChange
    case toolChange
}

enum Tool {
    case gelPen
    case pencil
    case crayon
    
    func toolName() -> String {
        switch self {
            case .gelPen: return "Gel Pen"
            case .pencil: return "Pencil"
            case .crayon: return "Crayon"
        }
    }
    
    func textureName() -> String? {
        switch self {
            case .gelPen:return nil
            case .pencil:return "PencilTexture"
            case .crayon:return "CrayonTexture"
        }
    }
    
    func index() -> Int {
        switch self {
            case .gelPen: return 0
            case .pencil: return 1
            case .crayon: return 2
        }
    }
    
    static func toolOfTexture(_ texture: String?) -> Tool {
        switch texture {
            case nil: return .gelPen
            case "PencilTexture": return .pencil
            case "CrayonTexture": return .crayon
            default: return .gelPen
        }
    }
    
    static func toolOfIndex(_ index: Int) -> Tool {
        switch index {
            case 0: return .gelPen
            case 1: return .pencil
            case 2: return .crayon
            default: return .gelPen
        }
    }
    
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
    
    func within(center: CGPoint, radius: CGFloat) -> Bool {
        let xDistance = location.x - center.x
        let yDistance = location.y - center.y
        let distanceSquare = xDistance * xDistance + yDistance * yDistance
        return distanceSquare < radius * radius
    }
}

/**
 * Stroke represents a single stroke on a painting, it's consists of stroke samples, and provides the render
 * information about the stroke
 */
struct Stroke: Codable, Sequence {
    var samples: [StrokeSample] = []
    var state: StrokeState = .active
    var renderMechanism: RenderMechanism!
    
    init(renderMechanism: RenderMechanism) {
        self.renderMechanism = renderMechanism
    }
    
    mutating func add(sample: StrokeSample) {
        samples.append(sample)
    }
    
    func makeIterator() -> StrokeArcIterator {
        return StrokeArcIterator(stroke: self)
    }
}

struct StrokeArc {
    var sampleBefore: StrokeSample
    var sample: StrokeSample
    var sampleAfter: StrokeSample
    
    init(sampleBefore: StrokeSample, sample: StrokeSample, sampleAfter: StrokeSample) {
        self.sampleBefore = sampleBefore
        self.sample = sample
        self.sampleAfter = sampleAfter
    }
}


/**
 * Layer is the layer in the painting, each layer is separate physically
 */
struct Layer: Codable {
    var identifier: String = "new layer"
    var strokes: [Stroke] = []
    
    init(strokes: [Stroke] = [], identifier: String = "new layer") {
        self.strokes = strokes
        self.identifier = identifier
    }
    
    mutating func add(stroke: Stroke) {
        strokes.append(stroke)
    }
}

/**
 * SubStep contains the pointers (actually indices of layer and stroke) to the strokes with same color and
 * texture
 */
struct SubStep: Codable, Sequence {
    var renderDescription: String
    var operationType: OperationChange
    var renderMechanism: RenderMechanism
    var isInteractive: Bool {
        return true
    }
    
    var relatedOperationLayer: [Int] = []
    var relatedOperationStroke: [Int] = []
    
    init(operationType: OperationChange, renderMechanism: RenderMechanism, renderDescription: String) {
        self.operationType = operationType
        self.renderMechanism = renderMechanism
        self.renderDescription = renderDescription
    }
    
    mutating func add(layerIndex: Int, strokeIndex: Int) {
        relatedOperationLayer.append(layerIndex)
        relatedOperationStroke.append(strokeIndex)
    }
    
    mutating func remove(at index: Int) {
        relatedOperationLayer.remove(at: index)
        relatedOperationStroke.remove(at: index)
    }
    
    mutating func setRenderMechanism(with mechanism: RenderMechanism) {
        renderMechanism = mechanism
    }
    
    func description() -> String {
        switch operationType {
        case .colorChange:
            return "Change Color:"
        case .toolChange:
            return "Use Tool:"
        }
    }
    
    func makeIterator() -> SubStepContentIterator {
        return SubStepContentIterator(subStep: self)
    }
}

/**
 * Step is the collection of SubStep, it contains multiple sub steps, that means it may be related with multiple
 * color and texture of strokes
 */
struct Step: Codable {
    var description: String = "no description"
    var subSteps: [SubStep] = []
    
    mutating func add(subStep: SubStep) {
        subSteps.append(subStep)
    }
}



struct ArtworkGuide: Codable {
    var steps: [Step] = []
    
    mutating func add(step: Step) {
        steps.append(step)
    }
    
    @discardableResult
    mutating func recordStroke(at layer: Int, index: Int) -> Bool {
        let lastStepIndex = steps.count - 1
        if lastStepIndex >= 0 {
            var lastSubStepIndex = steps[lastStepIndex].subSteps.count - 1
            if lastSubStepIndex >= 0 {
                steps[lastStepIndex].subSteps[lastSubStepIndex].add(layerIndex: layer, strokeIndex: index)
                let operationType = steps[lastStepIndex].subSteps[lastSubStepIndex].operationType
                lastSubStepIndex -= 1
                while lastSubStepIndex >= 0 &&
                    steps[lastStepIndex].subSteps[lastSubStepIndex].operationType != operationType {
                    steps[lastStepIndex].subSteps[lastSubStepIndex].add(layerIndex: layer, strokeIndex: index)
                    lastSubStepIndex -= 1
                }
                return true
            }
        }
        return false
    }
}


/**
 * Artwork is the top level of stroage, each Artwork correspond to a painting, an Artwork is consisted of
 * multiple stroke layers
 */
struct Artwork: Codable {
    var identifier: String
    var layers: [Layer]
    var guide: ArtworkGuide?
    var initialSize: CGSize
    
    init(layers: [Layer], size: CGSize, identifier: String = "new artwork", guide: ArtworkGuide? = nil) {
        self.layers = layers
        initialSize = size
        self.identifier = identifier
        self.guide = guide
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
        if nextIndex >= stroke.samples.count - 2 {
            return nil
        }
        let sampleBefore = stroke.samples[nextIndex]
        let sample = stroke.samples[nextIndex + 1]
        let sampleAfter = stroke.samples[nextIndex + 2]
        let strokeArc = StrokeArc(sampleBefore: sampleBefore, sample: sample, sampleAfter: sampleAfter)
        nextIndex += 1
        return strokeArc
    }
    
}
