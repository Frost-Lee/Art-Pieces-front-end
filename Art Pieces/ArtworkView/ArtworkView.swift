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
    var layers: [Layer] = []
    var currentLayer: Int? = nil
    
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
        strokeGestureRecognizer = StrokeGestureRecognizer(target: self, action: #selector(strokeUpdated))
        strokeGestureRecognizer.delegate = self
        strokeGestureRecognizer.cancelsTouchesInView = true
        strokeGestureRecognizer.coordinateSpaceView = self
        self.addGestureRecognizer(strokeGestureRecognizer)
        layer.drawsAsynchronously = true
        currentRenderMechanism = defaultRenderMechanism
        activeLayerView = ActiveLayerView(frame: frame)
        self.addSubview(activeLayerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func rerender() {
        for layer in layers {
            for stroke in layer.strokes {
                render(stroke: stroke)
            }
        }
    }
    
    func mergeActiveStroke() {
        if currentStroke != nil {
            activeLayerView.mergeActiveStroke()
        }
    }
    
    func switchLayer(to index: Int) {
        if currentLayer == nil {
            addLayer()
            currentLayer = 0
            loadActiveLayer(index: currentLayer!)
        } else if index <= numberOfLayers {
            mergeActiveLayer()
            if index == numberOfLayers - 1 {
                addLayer()
            }
            loadActiveLayer(index: index)
        }
    }
    
    private func mergeActiveLayer() {
        mergeActiveStroke()
        if activeLayerView.strokes.count != 0 {
            let newLayer = Layer()
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
    
    override func draw(_ rect: CGRect) {
        UIColor.white.set()
        UIRectFill(rect)
        rerender()
    }

}
