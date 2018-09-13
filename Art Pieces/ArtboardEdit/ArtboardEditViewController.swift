//
//  ArtboardEditViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/22.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  ArtboardEditViewController is the place where people can watch the lecture and try their ideas by
//  themselves.

import UIKit
import ChromaColorPicker

class ArtboardEditViewController: UIViewController {
    
    @IBOutlet weak var stepTableView: UITableView!
    @IBOutlet weak var artboardView: ArtboardView!
    @IBOutlet weak var toolBarView: ToolBarView!
    
    var artboardGuide: ArtboardGuide = ArtboardGuide() {
        didSet {
            stepTableView.reloadData()
        }
    }
    
    var artboard: MyArtboard?
    var contentData: Data?
    
    var saveArtboardWhenQuit: Bool = true
    
    private var selectedSteps: Set<Int> = []
    private var isEraserSelected: Bool = false
    private var previousRenderMechanism: RenderMechanism?
    
    private var penPickerIdentifier: String = ""
    private var palletIdentifier: String = ""
    private var interactingStep: (Int, Int)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .lightGray
        artboardView.currentRenderMechanism = RenderMechanism(color:
            .lightGray, width: 1.5, texture: "PencilTexture")
        artboardView.createLayer()
        artboardView.delegate = self
        artboardView.isRecordingForLecture = true
        let toolBarNib = UINib(nibName: "ToolBarView", bundle: nil)
        toolBarView = toolBarNib.instantiate(withOwner: self, options: nil).first as? ToolBarView
        toolBarView.delegate = self
        toolBarView.palletButton.backgroundColor = artboardView.currentRenderMechanism.color
        self.view.addSubview(toolBarView)
        stepTableView.register(StepTableViewCell.self, forCellReuseIdentifier: "stepTableViewCell")
        stepTableView.reloadData()
        if artboard != nil {
            artboardView.setupArtboard(with: artboard!.content! as Data)
        } else if contentData != nil {
            artboardView.setupArtboard(with: contentData!)
        }
        let tableViewController = UITableViewController(style: .plain)
        tableViewController.tableView = stepTableView
        addChildViewController(tableViewController)
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
        artboardView.stepPreviewPhotoArray.append(artboardView.viewImage()!)
        if saveArtboardWhenQuit {
            saveLecture()
        }
    }
    
    @IBAction func addStepButtonTapped(_ sender: UIButton) {
        artboardView.addAnotherStep()
    }
    
    private func saveLecture() {
        if artboardView.artboardLayerViews.first?.artboardLayer.strokes.count != 0 {
            DataManager.defaultManager.saveArtboard(keyPhoto: artboardView.viewImage()!, stepPreviewPhotoArray:
                artboardView.stepPreviewPhotoArray, content: artboardView.export(), email:
                AccountManager.defaultManager.currentUser?.email ?? "", title:
                "New Artboard", description: "", selfID: artboard?.uuid ?? UUID())
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


extension ArtboardEditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artboardGuide.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stepTableViewCell = StepTableViewCell(step: artboardGuide.steps[indexPath.row], index: indexPath.row)
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
            let step = artboardGuide.steps[indexPath.row]
            let fullHeight = CGFloat(step.subSteps.count) * SubStepView.height + StepTitleView.height
            return fullHeight
        } else {
            let titleHeight = StepTitleView.height
            return titleHeight
        }
    }
}


extension ArtboardEditViewController: StepTableViewCellDelegate {
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
        artboardView.guide.steps[step].subSteps[subStep].renderDescription = text
    }
}


extension ArtboardEditViewController: ArtboardDelegate {
    func artboardGuideDidUpdated(_ guide: ArtboardGuide) {
        artboardGuide = guide
    }
}


extension ArtboardEditViewController: ToolBarViewDelegate {
    func palletButtonDidTapped(_ sender: UIButton) {
        launchPallet(with: "ToolBar", at: toolBarView.palletButton, initialColor:
            artboardView.currentRenderMechanism.color)
    }
    
    func layerButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func thichnessButtonDidTapped(_ sender: UIButton) {
        let thicknessSliderController = ThicknessSliderViewController()
        thicknessSliderController.delegate = self
        thicknessSliderController.lowerBound = artboardView.currentRenderMechanism.minimumWidth
        thicknessSliderController.upperBound = artboardView.currentRenderMechanism.maximunWidth
        thicknessSliderController.slider.value = Float(artboardView.currentRenderMechanism.width)
        thicknessSliderController.preferredContentSize = CGSize(width: 300, height: 50)
        thicknessSliderController.prepareToLaunchAsPopover(source: toolBarView.thicknessButton)
        self.present(thicknessSliderController, animated: true, completion: nil)
    }
    
    func transparencyButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func eraserButtonDidTapped(_ sender: UIButton) {
        if isEraserSelected {
            toolBarView.dehighlightEraserButton()
            artboardView.currentRenderMechanism = previousRenderMechanism
            isEraserSelected = false
        } else {
            toolBarView.highLightEraserButton()
            isEraserSelected = true
            previousRenderMechanism = artboardView.currentRenderMechanism
            artboardView.currentRenderMechanism = getEraser(with: 5.0)
        }
    }
    
    func penButtonDidTapped(_ sender: UIButton) {
        launchPenPicker(with: "ToolBar", at: toolBarView.penButton, initialTool:
            Tool.toolOfTexture(artboardView.currentRenderMechanism.texture))
    }
}


extension ArtboardEditViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        switch palletIdentifier {
        case "ToolBar":
            artboardView.currentRenderMechanism.color = color
            toolBarView.palletButton.backgroundColor = color
        case "Record":
            artboardView.guide.steps[interactingStep!.0].subSteps[interactingStep!.1].renderMechanism.color = color
            artboardView.adjustAccordingTo(step: interactingStep!.0, subStep: interactingStep!.1)
            break
        default:
            break
        }
    }
}


extension ArtboardEditViewController: ToolPickerTableViewDelegate {
    func toolSelected(_ tool: Tool) {
        let textureName = tool.textureName()
        switch penPickerIdentifier {
        case "ToolBar":
            if artboardView.currentRenderMechanism.texture != textureName {
                artboardView.currentRenderMechanism.texture = textureName
            }
        case "Record":
            artboardView.guide.steps[interactingStep!.0].subSteps[interactingStep!.1].renderMechanism.texture = tool.textureName()
            artboardView.adjustAccordingTo(step: interactingStep!.0, subStep: interactingStep!.1)
        default:
            break
        }
    }
}


extension ArtboardEditViewController: ThicknessSliderDelegate {
    func thicknessDidSet(to value: Float) {
        artboardView.currentRenderMechanism.width = CGFloat(value)
    }
}
