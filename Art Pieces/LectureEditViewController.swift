//
//  LectureViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/22.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  LecturePresentationViewController is the place where people can watch the lecture and try their ideas by
//  themselves.

import UIKit

class LectureEditViewController: UIViewController {

    @IBOutlet weak var stepTableView: UITableView!
    @IBOutlet weak var artworkView: ArtworkView!
    
    var selectedSteps: Set<Int> = []
    
    var artworkGuide: ArtworkGuide = ArtworkGuide()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Only for test use
        var step = Step()
        let renderMechanism = RenderMechanism(color: .black, width: 1.0)
        let subStep = SubStep(operationType: .colorChange, renderMechanism: renderMechanism,
                              renderDescription: "Step 1")
        step.add(subStep: subStep)
        step.add(subStep: subStep)
        step.description = "Step 1"
        artworkGuide.add(step: step)
        step.description = "Step 2"
        artworkGuide.add(step: step)
        step.description = "Step 3"
        artworkGuide.add(step: step)
        
        // initialize the cell
        stepTableView.register(StepTableViewCell.self, forCellReuseIdentifier: "stepTableViewCell")
        stepTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}


extension LectureEditViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artworkGuide.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stepTableViewCell = StepTableViewCell()
        stepTableViewCell.selectionStyle = .none
        stepTableViewCell.delegate = self
        stepTableViewCell.backgroundColor = UIColor(red: 247/255, green: 246/255, blue: 244/255, alpha: 1)
        stepTableViewCell.clipsToBounds = true
        stepTableViewCell.step = artworkGuide.steps[indexPath.row]
        stepTableViewCell.index = indexPath.row
        if selectedSteps.contains(indexPath.row) {
            stepTableViewCell.setupDetailedInterface()
        } else {
            stepTableViewCell.setupTitleInterface()
        }
        return stepTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedSteps.contains(indexPath.row) {
            let step = artworkGuide.steps[indexPath.row]
            let fullHeight = CGFloat(step.subSteps.count) * SubStepView.height + StepTitleView.height
            return fullHeight
        } else {
            let titleHeight = StepTitleView.height
            return titleHeight
        }
    }
    
}

extension LectureEditViewController: StepTableViewCellDelegate {
    
    func stepTitleBarDidTapped(at index: Int) {
        stepTableView.beginUpdates()
        if selectedSteps.contains(index) {
            selectedSteps.remove(index)
        } else {
            selectedSteps.insert(index)
        }
        stepTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        stepTableView.endUpdates()
    }
    
    func subStepInteractionButtonDidTapped(at index: Int) {
    }
    
}
