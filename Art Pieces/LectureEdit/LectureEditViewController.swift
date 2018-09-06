//
//  LectureViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/22.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  LectureEditViewController is the place where people can watch the lecture and try their ideas by
//  themselves.

import UIKit
import ChromaColorPicker

class LectureEditViewController: UIViewController {
    
    @IBOutlet weak var stepTableView: UITableView!
    @IBOutlet weak var lectureEditView: LectureEditView!
    @IBOutlet weak var toolBarView: ToolBarView!
    
    var selectedSteps: Set<Int> = []
    
    var artworkGuide: LectureGuide = LectureGuide() {
        didSet {
            stepTableView.reloadData()
        }
    }
    
    private var isEraserSelected: Bool = false
    private var previousRenderMechanism: RenderMechanism?
    
    private var penPickerIdentifier: String = ""
    private var palletIdentifier: String = ""
    private var interactingStep: (Int, Int)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .lightGray
        lectureEditView.currentRenderMechanism = RenderMechanism(color:
            .lightGray, width: 1.5, texture: "PencilTexture")
        lectureEditView.createLayer()
        lectureEditView.delegate = self
        lectureEditView.isRecordingForLecture = true
        let toolBarNib = UINib(nibName: "ToolBarView", bundle: nil)
        toolBarView = toolBarNib.instantiate(withOwner: self, options: nil).first as? ToolBarView
        toolBarView.delegate = self
        toolBarView.palletButton.backgroundColor = lectureEditView.currentRenderMechanism.color
        self.view.addSubview(toolBarView)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lectureEditView.stepPreviewPhotoArray.append(lectureEditView.viewImage()!)
        saveLecture()
    }
    
    @IBAction func addStepButtonTapped(_ sender: UIButton) {
        lectureEditView.addAnotherStep()
    }
    
    private func saveLecture() {
        if lectureEditView.artworkLayerViews.first?.lectureLayer.strokes.count != 0 {
            DataManager.defaultManager.saveLecture(title: "New Artboard", description: nil, content: lectureEditView.export(),
                previewPhoto: lectureEditView.viewImage()!,
                stepPreviewPhotos: lectureEditView.stepPreviewPhotoArray)
        }
    }
    
    private func launchPallet(with identifier: String, at view: UIView, initialColor: UIColor) {
        palletIdentifier = identifier
        ChromaColorPicker.launch(in: self, sourceView: view, initialColor:
            initialColor, frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    }
    
    private func launchPenPicker(with identifier: String, at view: UIView, initialTool: Tool) {
        penPickerIdentifier = identifier
        let toolPickerController = ToolPickerTableViewController()
        toolPickerController.selectedTool = initialTool
        toolPickerController.delegate = self
        toolPickerController.preferredContentSize = CGSize(width: 150, height: 150)
        toolPickerController.prepareToLaunchAsPopover(source: view)
        self.present(toolPickerController, animated: true, completion: nil)
    }
    
}


extension LectureEditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artworkGuide.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stepTableViewCell = StepTableViewCell(step: artworkGuide.steps[indexPath.row], index: indexPath.row)
        stepTableViewCell.delegate = self
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
    
    func subStepInteractionButtonDidTapped(step: Int, subStep: Int) {
        interactingStep = (step, subStep)
        let cell = stepTableView.cellForRow(at: IndexPath(row: step, section: 0)) as! StepTableViewCell
        switch cell.step.subSteps[subStep].operationType {
        case .colorChange:
            launchPallet(with: "Record", at: cell.subStepViews[subStep].interactionButton, initialColor:
                cell.step.subSteps[subStep].renderMechanism.color)
        case .toolChange:
            launchPenPicker(with: "Record", at: cell.subStepViews[subStep].interactionButton, initialTool:
                Tool.toolOfTexture(cell.step.subSteps[subStep].renderMechanism.texture))
        }
    }
    
    func subDescriptionTextDieEditted(to text: String, step: Int, subStep: Int) {
        lectureEditView.guide.steps[step].subSteps[subStep].renderDescription = text
    }
}


extension LectureEditViewController: LectureEditViewDelegate {
    func artworkGuideDidUpdated(_ guide: LectureGuide) {
        artworkGuide = guide
    }
}


extension LectureEditViewController: ToolBarViewDelegate {
    func palletButtonDidTapped(_ sender: UIButton) {
        launchPallet(with: "ToolBar", at: toolBarView.palletButton, initialColor:
            lectureEditView.currentRenderMechanism.color)
    }
    
    func layerButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func thichnessButtonDidTapped(_ sender: UIButton) {
        let thicknessSliderController = ThicknessSliderViewController()
        thicknessSliderController.delegate = self
        thicknessSliderController.lowerBound = lectureEditView.currentRenderMechanism.minimumWidth
        thicknessSliderController.upperBound = lectureEditView.currentRenderMechanism.maximunWidth
        thicknessSliderController.slider.value = Float(lectureEditView.currentRenderMechanism.width)
        thicknessSliderController.preferredContentSize = CGSize(width: 300, height: 50)
        thicknessSliderController.prepareToLaunchAsPopover(source: toolBarView.thicknessButton)
        self.present(thicknessSliderController, animated: true, completion: nil)
    }
    
    func transparencyButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func eraserButtonDidTapped(_ sender: UIButton) {
        if isEraserSelected {
            toolBarView.dehighlightEraserButton()
            lectureEditView.currentRenderMechanism = previousRenderMechanism
            isEraserSelected = false
        } else {
            toolBarView.highLightEraserButton()
            isEraserSelected = true
            previousRenderMechanism = lectureEditView.currentRenderMechanism
            lectureEditView.currentRenderMechanism = getEraser(with: 5.0)
        }
    }
    
    func penButtonDidTapped(_ sender: UIButton) {
        launchPenPicker(with: "ToolBar", at: toolBarView.penButton, initialTool:
            Tool.toolOfTexture(lectureEditView.currentRenderMechanism.texture))
    }
}


extension LectureEditViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        switch palletIdentifier {
        case "ToolBar":
            lectureEditView.currentRenderMechanism.color = color
            toolBarView.palletButton.backgroundColor = color
        case "Record":
            lectureEditView.guide.steps[interactingStep!.0].subSteps[interactingStep!.1].renderMechanism.color = color
            lectureEditView.adjustAccordingTo(step: interactingStep!.0, subStep: interactingStep!.1)
            break
        default:
            break
        }
    }
}


extension LectureEditViewController: ToolPickerTableViewDelegate {
    func toolSelected(_ tool: Tool) {
        let textureName = tool.textureName()
        switch penPickerIdentifier {
        case "ToolBar":
            if lectureEditView.currentRenderMechanism.texture != textureName {
                lectureEditView.currentRenderMechanism.texture = textureName
            }
        case "Record":
            lectureEditView.guide.steps[interactingStep!.0].subSteps[interactingStep!.1].renderMechanism.texture = tool.textureName()
            lectureEditView.adjustAccordingTo(step: interactingStep!.0, subStep: interactingStep!.1)
        default:
            break
        }
    }
}


extension LectureEditViewController: ThicknessSliderDelegate {
    func thicknessDidSet(to value: Float) {
        lectureEditView.currentRenderMechanism.width = CGFloat(value)
    }
}
