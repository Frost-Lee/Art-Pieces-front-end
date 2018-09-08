//
//  Extensions.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/25.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import CoreGraphics
import ChromaColorPicker
import SwiftyJSON

func delay(for seconds: Double, block: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: block)
}

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

extension NSLayoutConstraint {
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

extension UIView {
    func viewImage() -> UIImage? {
        if self.frame.width != 0 && self.frame.height != 0 {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        } else {
            return nil
        }
    }
}


extension UIAlertController {
    static func prepareController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        return alertController
    }
}


extension JSON {
    public var date: Date? {
        get {
            if let str = self.string {
                return JSON.jsonDateFormatter.date(from: str)
            }
            return nil
        }
    }
    
    private static let jsonDateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        fmt.timeZone = TimeZone(secondsFromGMT: 0)
        return fmt
    }()
}


extension Date {
    var secondsSince1970: TimeInterval {
        return self.timeIntervalSince1970 * 1000
    }
}
