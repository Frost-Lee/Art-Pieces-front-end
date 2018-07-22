//
//  LectureViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/22.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController {

    @IBOutlet weak var stepTableView: UITableView!
    @IBOutlet weak var artworkView: ArtworkView!
    
    var selectedStep: Int = 0
    
    var artworkGuide: ArtworkGuide = ArtworkGuide()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Only for test use
        var step = Step()
        let renderMechanism = RenderMechanism(color: .black, width: 1.0)
        let subStep = SubStep(operationType: .colorChange, renderMechanism: renderMechanism,
                              renderDescription: "Step 1")
        step.add(subStep: subStep)
        artworkGuide.add(step: step)
        
        // initialize the cell
        stepTableView.register(StepTableViewCell.self, forCellReuseIdentifier: "stepTableViewCell")
        stepTableView.reloadData()
    }

}


extension LectureViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artworkGuide.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stepTableViewCell = stepTableView.dequeueReusableCell(withIdentifier:
            "stepTableViewCell") as! StepTableViewCell
        stepTableViewCell.step = artworkGuide.steps[indexPath.row]
        if indexPath.row == selectedStep {
            stepTableViewCell.setupDetailedInterface()
        } else {
            stepTableViewCell.setupTitleInterface()
        }
        return stepTableViewCell
    }
    
}
