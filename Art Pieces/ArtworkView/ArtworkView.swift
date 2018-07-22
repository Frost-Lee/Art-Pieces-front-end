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

class ArtworkView: UIView, UIGestureRecognizerDelegate {
    
    var activeLayerView: ActiveLayerView!
    var strokeGestureRecognizer: StrokeGestureRecognizer!
    var eraseGestureRecognizer: EraseGestureRecognizer!
    var layers: [Layer] = []
    var currentLayer: Int? = nil
    
    var eraserRadius: CGFloat = 5.0
    
    var currentRenderMechanism: RenderMechanism! {
        get {
            return strokeGestureRecognizer.renderMechanism
        } set {
            strokeGestureRecognizer.renderMechanism = newValue
        }
    }
    
    var currentStroke: Stroke? {
        get {
            return self.activeLayerView.activeStrokeView.stroke
        } set {
            self.activeLayerView.activeStrokeView.stroke = newValue
        }
    }
    
    var numberOfLayers: Int {
        return currentLayer == nil ? layers.count : layers.count + 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init() {
        self.init()
        initialize()
    }
    
    convenience init(frame: CGRect, artwork: Artwork) {
        self.init(frame: frame)
        layers = artwork.layers
        switchLayer(to: 0)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.white.set()
        UIRectFill(rect)
        rerender()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func strokeUpdated() {
        var stroke: Stroke? = nil
        if strokeGestureRecognizer.state != .cancelled {
            stroke = strokeGestureRecognizer.stroke
        }
        if let updatedStroke = stroke {
            if strokeGestureRecognizer.state == .ended {
                currentStroke = updatedStroke
                mergeActiveStroke()
            } else {
                currentStroke = updatedStroke
            }
        }
    }
    
    /**
     * The method is used for rerendering the strokes in all layers. However, the method shouldn't be called
     * directly, one should call setNeedsDisplay if need to rerender all layers
     */
    func rerender() {
        for layer in layers {
            for stroke in layer.strokes {
                render(stroke: stroke)
            }
        }
    }
    
    func switchLayer(to index: Int) {
        if currentLayer == nil {
            addLayer()
            currentLayer = 0
            loadActiveLayer(index: currentLayer!)
        } else if index <= numberOfLayers && index != currentLayer! {
            mergeActiveLayer()
            if index == numberOfLayers - 1 {
                addLayer()
            }
            loadActiveLayer(index: index)
        }
    }
    
    func switchEraseMode() {
        eraseGestureRecognizer.isEnabled = !eraseGestureRecognizer.isEnabled
        strokeGestureRecognizer.isEnabled = !eraseGestureRecognizer.isEnabled
    }
    
    func setCurrentColor(to color: UIColor) {
        currentRenderMechanism.color = color
    }
    
    func export() -> Artwork {
        withdrawActiveLayer()
        return Artwork(layers: layers, size: frame.size)
    }
    
    private func initialize() {
        strokeGestureRecognizer = setupStrokeGestureRecognizer()
        strokeGestureRecognizer.isEnabled = true
        eraseGestureRecognizer = setupEraseGestureRecognizer()
        eraseGestureRecognizer.isEnabled = false
        self.addGestureRecognizer(strokeGestureRecognizer)
        self.addGestureRecognizer(eraseGestureRecognizer)
        layer.drawsAsynchronously = true
        currentRenderMechanism = defaultRenderMechanism
        activeLayerView = ActiveLayerView(frame: frame)
        self.addSubview(activeLayerView)
    }
    
    private func withdrawActiveLayer() {
        let activeLayer = Layer(strokes: activeLayerView.strokes)
        layers.insert(activeLayer, at: currentLayer!)
    }
    
    private func setupStrokeGestureRecognizer() -> StrokeGestureRecognizer {
        let recognizer = StrokeGestureRecognizer()
        recognizer.addTarget(self, action: #selector(strokeUpdated))
        recognizer.delegate = self
        recognizer.cancelsTouchesInView = true
        recognizer.coordinateSpaceView = self
        return recognizer
    }
    
    private func setupEraseGestureRecognizer() -> EraseGestureRecognizer {
        let recognizer = EraseGestureRecognizer()
        recognizer.delegate = self
        recognizer.eraseDelegate = self
        recognizer.cancelsTouchesInView = true
        recognizer.coordinateSpaceView = self
        return recognizer
    }
    
    private func mergeActiveStroke() {
        if currentStroke != nil {
            activeLayerView.mergeActiveStroke()
        }
    }
    
    private func mergeActiveLayer() {
        mergeActiveStroke()
        if activeLayerView.strokes.count != 0 {
            var newLayer = Layer()
            newLayer.strokes = activeLayerView.strokes
            layers.insert(newLayer, at: currentLayer!)
            activeLayerView.strokes = []
        }
    }
    
    private func loadActiveLayer(index: Int) {
        currentLayer = index
        activeLayerView.strokes = layers[index].strokes
        layers.remove(at: index)
    }
    
    private func addLayer() {
        layers.append(Layer())
    }

}

extension ArtworkView: EraseDelegate {
    
    func eraseDetected(at sample: StrokeSample) {
        activeLayerView.handleErase(at: sample, for: eraserRadius)
    }
    
}
