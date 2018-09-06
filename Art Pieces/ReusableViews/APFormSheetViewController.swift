//
//  APFormSheetViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/9/6.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class APFormSheetViewController: UIViewController {
    
    var closeButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .formSheet
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .formSheet
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupCloseButton()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let controllerWidth = self.view.bounds.width
        closeButton.frame = CGRect(x: controllerWidth - 44, y: 20, width: 24, height: 24)
    }

    @objc func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupCloseButton() {
        closeButton = UIButton(type: .custom)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        closeButton.setImage(UIImage(named: "CloseButton"), for: .normal)
        self.view.addSubview(closeButton)
    }
}
