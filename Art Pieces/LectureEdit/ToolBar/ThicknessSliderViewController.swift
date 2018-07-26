//
//  ThicknessSliderViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/26.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit


protocol ThicknessSliderDelegate {
    func thicknessDidSet(to value: Float)
}

class ThicknessSliderViewController: UIViewController {
    
    var slider: UISlider = UISlider()
    
    var delegate: ThicknessSliderDelegate?
    var lowerBound: Float? {
        didSet {
            slider.minimumValue = lowerBound ?? 1
        }
    }
    var upperBound: Float? {
        didSet {
            slider.maximumValue = upperBound ?? 5
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        slider.frame = CGRect(x: 20, y: 0, width: 260, height: 50)
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(sliderValueDidChanged), for: UIControl.Event.valueChanged)
        self.view.addSubview(slider)
    }
    
    @objc func sliderValueDidChanged() {
        delegate?.thicknessDidSet(to: slider.value)
    }

}
