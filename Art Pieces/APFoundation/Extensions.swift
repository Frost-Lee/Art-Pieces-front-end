//
//  Extensions.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/25.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import Foundation
import CoreGraphics
import ChromaColorPicker


extension CGVector {
    var quadrance: CGFloat {
        return dx * dx + dy * dy
    }
}


func -(left: CGPoint, right:CGPoint) -> CGVector {
    return CGVector(dx: left.x - right.x, dy: left.y - right.y)
}

extension ChromaColorPicker {
    static func launch(in masterController: UIViewController, sourceView: UIView,
                initialColor: UIColor, frame: CGRect) {
        let colorPicker = ChromaColorPicker(frame: frame)
        colorPicker.adjustToColor(initialColor)
        colorPicker.supportsShadesOfGray = true
        colorPicker.hexLabel.isHidden = true
        colorPicker.delegate = masterController as? ChromaColorPickerDelegate
        UIViewController.launchPopover(masterViewController: masterController, with: colorPicker,
                                       source: sourceView, frame: frame)
    }
}

extension UIViewController {
    static func launchPopover(masterViewController: UIViewController, with subview: UIView,
                              source: UIView, frame: CGRect) {
        let viewController = UIViewController()
        viewController.view.backgroundColor = APTheme.grayBackgroundColor
        viewController.preferredContentSize = frame.size
        viewController.view.addSubview(subview)
        viewController.prepareToLaunchAsPopover(source: source)
        masterViewController.present(viewController, animated: true, completion: nil)
    }
    
    func prepareToLaunchAsPopover(source: UIView) {
        self.modalPresentationStyle = .popover
        let popoverController = self.popoverPresentationController
        popoverController?.sourceView = source
        popoverController?.sourceRect = source.bounds
        popoverController?.permittedArrowDirections = .any
    }
}
