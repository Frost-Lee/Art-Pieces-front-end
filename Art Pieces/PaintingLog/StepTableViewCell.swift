//
//  StepTableViewCell.swift
//
//
//  Created by 李灿晨 on 2018/7/21.
//

import UIKit

protocol StepTableViewCellDelegate {
    func stepTitleBarDidTapped(at index: Int)
    func subStepInteractionButtonDidTapped(at index: Int)
}

class StepTableViewCell: UITableViewCell {
    
    var stepTitleView: StepTitleView!
    var subStepViews: [SubStepView] = []
    
    var step: Step!
    var index: Int!
    
    var delegate: StepTableViewCellDelegate!
    
    private var currentHeight: CGFloat = 0
    
    init(style: UITableViewCell.CellStyle, step: Step, index: Int) {
        super.init(style: style, reuseIdentifier: "stepTableViewCell")
        self.step = step
        self.index = index
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "stepTableViewCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTitleInterface()
    }
    
    func setupTitleInterface() {
        let stepTitleViewNib = UINib(nibName: "StepTitleView", bundle: nil)
        let stepTitleView = stepTitleViewNib.instantiate(withOwner: self, options: nil).first
            as! StepTitleView
        stepTitleView.delegate = self
        stepTitleView.stepName = step.description
        stepTitleView.layer.masksToBounds = true
        stepTitleView.frame = CGRect(x: 8, y: 0, width: stepTitleView.frame.width,
                                     height: stepTitleView.frame.height)
        self.addSubview(stepTitleView)
        currentHeight = stepTitleView.frame.height
    }
    
    func setupDetailedInterface() {
        setupTitleInterface()
        for subStep in step.subSteps {
            let subStepViewNib = UINib(nibName: "SubStepView", bundle: nil)
            let newSubStepView = subStepViewNib.instantiate(withOwner: self, options: nil).first
                as! SubStepView
            newSubStepView.operationDescription = subStep.description()
            newSubStepView.isToolInteractive = true
            newSubStepView.index = subStepViews.count
            subStepViews.append(newSubStepView)
        }
        for subStepView in subStepViews {
            subStepView.layer.masksToBounds = true
            subStepView.frame = CGRect(x: 16, y: currentHeight, width: subStepView.frame.width,
                                       height: subStepView.frame.height)
            subStepView.delegate = self
            currentHeight += subStepView.frame.height
            self.addSubview(subStepView)
        }
    }
    
}

extension StepTableViewCell: StepTitleDelegate, SubStepViewDelegate {
    
    func stepTitleBarDidTapped() {
        delegate.stepTitleBarDidTapped(at: index)
    }
    
    func subStepInteractionButtonDidTapped() {
        delegate.subStepInteractionButtonDidTapped(at: index)
    }
    
}
