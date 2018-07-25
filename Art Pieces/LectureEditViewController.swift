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
import ChromaColorPicker

class LectureEditViewController: UIViewController {
    
    @IBOutlet weak var stepTableView: UITableView!
    @IBOutlet weak var artworkView: ArtworkView!
    @IBOutlet weak var toolBarView: ToolBarView!
    
    var selectedSteps: Set<Int> = []
    
    var artworkGuide: ArtworkGuide = ArtworkGuide() {
        didSet {
            //stepTableView.beginUpdates()
            stepTableView.reloadData()
            //stepTableView.endUpdates()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let toolBarNib = UINib(nibName: "ToolBarView", bundle: nil)
        toolBarView = toolBarNib.instantiate(withOwner: self, options: nil).first as? ToolBarView
        self.view.addSubview(toolBarView)
        toolBarView.delegate = self
        artworkView.currentRenderMechanism = RenderMechanism(color: .blue, width: 1)
        artworkView.switchLayer(to: 0)
        artworkView.delegate = self
        artworkView.isRecordingForLecture = true
        // initialize the cell
        stepTableView.register(StepTableViewCell.self, forCellReuseIdentifier: "stepTableViewCell")
        stepTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        toolBarView.frame = CGRect(x: stepTableView.frame.width, y: self.view.frame.height - CGFloat(71),
                                   width: UIScreen.main.bounds.width - stepTableView.frame.width, height: 71)
    }
    
    @IBAction func addStepButtonTapped(_ sender: UIButton) {
        artworkView.addAnotherStep()
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


extension LectureEditViewController: ArtworkViewDelegate {
    
    func artworkGuideDidUpdated(_ guide: ArtworkGuide) {
        artworkGuide = guide
    }
    
}


extension LectureEditViewController: ToolBarViewDelegate {
    
    func palletButtonDidTapped(_ sender: UIButton) {
        let paletteViewController = UIViewController()
        paletteViewController.view.backgroundColor = APTheme.grayBackgroundColor
        paletteViewController.preferredContentSize = CGSize(width: 300, height: 300)
        let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        colorPicker.hexLabel.isHidden = true
        colorPicker.delegate = self
        paletteViewController.view.addSubview(colorPicker)
        paletteViewController.modalPresentationStyle = .popover
        let popoverPresentationController = paletteViewController.popoverPresentationController
        popoverPresentationController?.sourceView = toolBarView.palletButton
        popoverPresentationController?.permittedArrowDirections = .any
        self.present(paletteViewController, animated: true, completion: nil)
    }
    
    func layerButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func thichnessButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func transparencyButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func eraserButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func penButtonDidTapped(_ sender: UIButton) {
        
    }
    
}


extension LectureEditViewController: ChromaColorPickerDelegate {
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        var mechanism = artworkView.currentRenderMechanism!
        mechanism.color = color
        artworkView.currentRenderMechanism = mechanism
        toolBarView.palletButton.backgroundColor = color
    }
    
}
