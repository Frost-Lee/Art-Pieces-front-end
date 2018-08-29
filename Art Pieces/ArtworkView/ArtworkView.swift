//
//  ArtworkView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/15.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  The ArtworkView is the view that is used for the user to draw on, StrokeGestureRecognizer is used so that
//  user's interaction with the screen would be recorded.

import UIKit

protocol LectureEditViewDelegate: class {
    func artworkGuideDidUpdated(_ guide: LectureGuide)
}

class LectureEditView: UIView, UIGestureRecognizerDelegate {
    
    weak var delegate: LectureEditViewDelegate?
    
    var strokeGestureRecognizer: StrokeGestureRecognizer!
    var singleStrokeView: SingleStrokeView!
    var artworkLayerViews: [LectureLayerView] = []
    var currentStroke: Stroke? {
        get {
            return singleStrokeView.stroke
        } set {
            singleStrokeView.stroke = newValue
        }
    }
    
    var guide: LectureGuide = LectureGuide() {
        didSet {
            delegate?.artworkGuideDidUpdated(guide)
        }
    }
    var stepPreviewPhotoArray: [UIImage] = []
    
    var isRecordingForLecture: Bool = false
    var numberOfLayers: Int = 0
    var activeLayerIndex: Int = -1
    
    var currentRenderMechanism: RenderMechanism! {
        get {
            return strokeGestureRecognizer.renderMechanism
        } set {
            writeGuideLog(from: currentRenderMechanism, to: newValue)
            strokeGestureRecognizer.renderMechanism = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.white.set()
        UIRectFill(rect)
        for artworkLayerView in artworkLayerViews {
            artworkLayerView.setNeedsDisplay()
        }
    }
    
    @objc func strokeUpdated() {
        var stroke: Stroke? = nil
        if strokeGestureRecognizer.state != .cancelled {
            stroke = strokeGestureRecognizer.stroke
        }
        if let updatedStroke = stroke {
            if !updatedStroke.renderMechanism.isEraseMode {
                currentStroke = updatedStroke
                if strokeGestureRecognizer.state == .ended {
                    mergeActiveStroke()
                }
            } else {
                artworkLayerViews[activeLayerIndex].eraseBufferStroke = updatedStroke
                if strokeGestureRecognizer.state == .ended {
                    artworkLayerViews[activeLayerIndex].mergeEraseStroke()
                }
                setNeedsDisplay()
            }
        }
    }
    
    func createLayer() {
        let newLayerView = LectureLayerView(frame: self.bounds)
        artworkLayerViews.append(newLayerView)
        switchLayer(to: artworkLayerViews.count - 1)
        self.addSubview(newLayerView)
    }
    
    func switchLayer(to index: Int) {
        guard index >= 0 && index < artworkLayerViews.count else {return}
        singleStrokeView.removeFromSuperview()
        activeLayerIndex = index
        self.insertSubview(singleStrokeView, aboveSubview: artworkLayerViews[activeLayerIndex])
    }
    
    func addAnotherStep() {
        if isRecordingForLecture {
            var newStep = Step()
            newStep.description = "Step " + String(guide.steps.count + 1)
            guide.add(step: newStep)
            stepPreviewPhotoArray.append(getStepPreviewPhoto())
        }
    }
    
    func adjustAccordingTo(step: Int, subStep: Int) {
        let relatedSubStep = guide.steps[step].subSteps[subStep]
        for (layerIndex, strokeIndex) in relatedSubStep {
            artworkLayerViews[layerIndex].lectureLayer.strokes[strokeIndex].renderMechanism = relatedSubStep.renderMechanism
        }
        setNeedsDisplay()
    }
    
    private func initialize() {
        strokeGestureRecognizer = setupStrokeGestureRecognizer()
        self.addGestureRecognizer(strokeGestureRecognizer)
        layer.drawsAsynchronously = true
        currentRenderMechanism = defaultRenderMechanism
        singleStrokeView = SingleStrokeView(frame: self.bounds)
        self.addSubview(singleStrokeView)
    }
    
    private func setupStrokeGestureRecognizer() -> StrokeGestureRecognizer {
        let recognizer = StrokeGestureRecognizer()
        recognizer.delegate = self
        recognizer.addTarget(self, action: #selector(strokeUpdated))
        recognizer.cancelsTouchesInView = true
        recognizer.coordinateSpaceView = self
        return recognizer
    }
    
    private func getStepPreviewPhoto() -> UIImage {
        return self.viewImage(for: self.frame.size)!
    }
    
    private func mergeActiveStroke() {
        if let newStroke = singleStrokeView.stroke {
            artworkLayerViews[activeLayerIndex].lectureLayer.add(stroke: newStroke)
            singleStrokeView.stroke = nil
        }
        setNeedsDisplay()
        appendStrokeChangeToGuideLog()
    }
    
    private func writeGuideLog(from old: RenderMechanism?, to new: RenderMechanism) {
        guard isRecordingForLecture else {return}
        if old?.color == .clear || new.color == .clear {
            return
        }
        var operationChange: OperationChange? = nil
        if old != nil {
            if old!.texture != new.texture {
                operationChange = .toolChange
            } else if old!.color != new.color {
                operationChange = .colorChange
            }
        } else {
            operationChange = .toolChange
        }
        if let change = operationChange {
            if guide.steps.count != 0 {
                let newSubStep = SubStep(operationType: change, renderMechanism: new,
                                         renderDescription: "Add description here.")
                let lastIndex = guide.steps.count - 1
                guide.steps[lastIndex].add(subStep: newSubStep)
            }
        }
    }
    
    private func appendStrokeChangeToGuideLog() {
        if isRecordingForLecture && guide.steps.count != 0 {
            if !(guide.recordStroke(at: activeLayerIndex, index: artworkLayerViews[activeLayerIndex]
                .lectureLayer.strokes.count - 1)) {
                writeGuideLog(from: nil, to: currentRenderMechanism)
                guide.recordStroke(at: activeLayerIndex, index: artworkLayerViews[activeLayerIndex]
                    .lectureLayer.strokes.count - 1)
            }
        }
    }
    
}
