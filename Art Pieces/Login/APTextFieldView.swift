//
//  APTextFieldView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol APTextFieldDelegate {
    func textFieldDidBeganEditing()
    func textFieldDidEndEditing(with text: String)
}

class APTextFieldView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editingIndicator: UIView!
    
    var delegate: APTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("APTextFieldView", owner: self, options: nil)
        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("APTextFieldView", owner: self, options: nil)
        self.addSubview(view)
    }
    
    @IBAction func textFieldBeganEditing(_ sender: UITextField) {
        UIView.transition(with: editingIndicator, duration: 0.1, options: .transitionCrossDissolve,
                          animations: {self.editingIndicator.backgroundColor = .black}, completion: nil)
        delegate?.textFieldDidBeganEditing()
    }
    
    @IBAction func textFieldEndEditing(_ sender: UITextField) {
        UIView.transition(with: editingIndicator, duration: 0.1, options: .transitionCrossDissolve,
                          animations: {self.editingIndicator.backgroundColor = .lightGray}, completion: nil)
        delegate?.textFieldDidEndEditing(with: textField.text!)
    }
    
}


extension APTextFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
