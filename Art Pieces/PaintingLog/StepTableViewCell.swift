//
//  StepTableViewCell.swift
//
//
//  Created by 李灿晨 on 2018/7/21.
//

import UIKit

class StepTableViewCell: UITableViewCell {
    
    var stepTitleView: StepTitleView!
    var subStepViews: [SubStepView] = []
    
    var step: Step!
    
    init(style: UITableViewCell.CellStyle, step: Step) {
        super.init(style: style, reuseIdentifier: "stepTableViewCell")
        self.step = step
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
        stepTitleView = StepTitleView()
        stepTitleView.delegate = self
        stepTitleView.stepName = step.description
        stepTitleView.layer.masksToBounds = true
        self.addSubview(stepTitleView)
    }
    
    func setupDetailedInterface() {
        setupTitleInterface()
        for subStep in step.subSteps {
            let newSubStepView = SubStepView()
            newSubStepView.operationDescription = subStep.description()
            newSubStepView.isToolInteractive = true
            newSubStepView.index = subStepViews.count - 1
            subStepViews.append(newSubStepView)
        }
        for subStepView in subStepViews {
            subStepView.layer.masksToBounds = true
            self.addSubview(subStepView)
        }
    }
    
}

extension StepTableViewCell: StepTitleDelegate {
    
    func stepTitleBarDidTapped() {
        
    }
    
    
}
