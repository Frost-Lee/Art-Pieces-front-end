//
//  MasterNavigationView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/22.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol MasterNavigationDelegate: class {
    func galleryButtonDidTapped(_ sender: UIButton)
    func lectureButtonDidTapped(_ sender: UIButton)
    func searchButtonDidTapped(_ sender: UIButton)
    func settingButtonDidTapped(_ sender: UIButton)
    func notificationButtonDidTapped(_ sendr: UIButton)
    func meButtonDidTapped(_ sender: UIButton)
    func artworkButtonDidTapped(_ sender: UIButton)
}

class MasterNavigationView: UIView {
    
    @IBOutlet weak var galleryLabel: UILabel!
    @IBOutlet weak var lectureLabel: UILabel!
    @IBOutlet weak var selectionIndicator: UIView!
    
    weak var delegate: MasterNavigationDelegate?
    
    var isGallerySelected: Bool = true
    
    private var galleryLockFrame = CGRect(x: 128, y: 102, width: 100, height: 8)
    private var lectureLockFrame = CGRect(x: 251, y: 102, width: 100, height: 8)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard selectionIndicator != nil && galleryLabel != nil && lectureLabel != nil else {return}
        if isGallerySelected {
            setGallerySelected(animated: true)
        } else {
            setLectureSelected(animated: true)
        }
    }
    
    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        if !isGallerySelected {
            setGallerySelected(animated: true)
            delegate?.galleryButtonDidTapped(sender)
        }
    }
    
    @IBAction func lectureButtonTapped(_ sender: UIButton) {
        if isGallerySelected {
            setLectureSelected(animated: true)
            delegate?.lectureButtonDidTapped(sender)
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func notificationButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func meButtonTapped(_ sender: UIButton) {
        delegate?.meButtonDidTapped(sender)
    }
    
    @IBAction func addArtworkButtonTapped(_ sender: UIButton) {
        delegate?.artworkButtonDidTapped(sender)
    }
    
    func setGallerySelected(animated: Bool) {
        isGallerySelected = true
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options:
                UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.selectionIndicator.frame = self.galleryLockFrame
            }, completion: nil)
        } else {
            self.selectionIndicator.frame = self.galleryLockFrame
        }
        galleryLabel.textColor = APTheme.purpleHighLightColor
        lectureLabel.textColor = UIColor.black
        
    }
    
    func setLectureSelected(animated: Bool) {
        isGallerySelected = false
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options:
                UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.selectionIndicator.frame = self.lectureLockFrame
            }, completion: nil)
        } else {
            self.selectionIndicator.frame = self.lectureLockFrame
        }
        galleryLabel.textColor = UIColor.black
        lectureLabel.textColor = APTheme.purpleHighLightColor
    }
    
}
