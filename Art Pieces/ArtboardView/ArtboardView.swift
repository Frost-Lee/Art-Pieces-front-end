//
//  ArtboardView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/15.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  The ArtboardView is the view that is used for the user to draw on, StrokeGestureRecognizer is used so that
//  user's interaction with the screen would be recorded.

import UIKit

protocol ArtboardDelegate: class {
    func artboardGuideDidUpdated(_ guide: ArtboardGuide)
}

class ArtboardView: UIView, UIGestureRecognizerDelegate {
    
    weak var delegate: ArtboardDelegate?
    
    var strokeGestureRecognizer: StrokeGestureRecognizer!
    var singleStrokeView: SingleStrokeView!
    var artboardLayerViews: [ArtboardLayerView] = []
    var currentStroke: Stroke? {
        get {
            return singleStrokeView.stroke
        } set {
            singleStrokeView.stroke = newValue
        }
    }
    
    var guide: ArtboardGuide = ArtboardGuide() {
        didSet {
            delegate?.artboardGuideDidUpdated(guide)
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
        for artboardLayerView in artboardLayerViews {
            artboardLayerView.setNeedsDisplay()
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
                artboardLayerViews[activeLayerIndex].eraseBufferStroke = updatedStroke
                if strokeGestureRecognizer.state == .ended {
                    artboardLayerViews[activeLayerIndex].mergeEraseStroke()
                }
                setNeedsDisplay()
            }
        }
    }
    
    func setupArtboard(with data: Data) {
        let artboard = try! JSONDecoder().decode(Artboard.self, from: data)
        for i in 0 ..< artboard.layers.count - 1 {
            artboardLayerViews[i].artboardLayer = artboard.layers[i]
            createLayer()
        }
        artboardLayerViews.last?.artboardLayer = artboard.layers.last
        if artboard.guide != nil {
            guide = artboard.guide!
        }
        delegate?.artboardGuideDidUpdated(guide)
        setNeedsDisplay()
    }
    
    func createLayer() {
        let newLayerView = ArtboardLayerView(frame: self.bounds)
        artboardLayerViews.append(newLayerView)
        switchLayer(to: artboardLayerViews.count - 1)
        self.addSubview(newLayerView)
    }
    
    func switchLayer(to index: Int) {
        guard index >= 0 && index < artboardLayerViews.count else {return}
        singleStrokeView.removeFromSuperview()
        activeLayerIndex = index
        self.insertSubview(singleStrokeView, aboveSubview: artboardLayerViews[activeLayerIndex])
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
            artboardLayerViews[layerIndex].artboardLayer.strokes[strokeIndex].renderMechanism =
                relatedSubStep.renderMechanism
        }
        setNeedsDisplay()
    }
    
    func export() -> Data {
        var layers: [Layer] = []
        for view in artboardLayerViews {
            layers.append(view.artboardLayer)
        }
        var newArtboard = Artboard(layers: layers, size: self.frame.size)
        if guide.steps.count != 0 {
            newArtboard.guide = guide
        }
        let data = try! JSONEncoder().encode(newArtboard)
        return data
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
        return self.viewImage()!
    }
    
    private func mergeActiveStroke() {
        if let newStroke = singleStrokeView.stroke {
            artboardLayerViews[activeLayerIndex].artboardLayer.add(stroke: newStroke)
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
            if !(guide.recordStroke(at: activeLayerIndex, index: artboardLayerViews[activeLayerIndex]
                .artboardLayer.strokes.count - 1)) {
                writeGuideLog(from: nil, to: currentRenderMechanism)
                guide.recordStroke(at: activeLayerIndex, index: artboardLayerViews[activeLayerIndex]
                    .artboardLayer.strokes.count - 1)
            }
        }
    }
    
}
