//
//  StudioViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/16.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import ChromaColorPicker

class StudioViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var editColorButton: UIBarButtonItem!
    
    var artworkView: ArtworkView!
    var fingerStrokeRecognizer: StrokeGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        artworkView = ArtworkView(frame: self.view.frame)
        self.view.addSubview(artworkView)
        artworkView.currentRenderMechanism = RenderMechanism(color: .blue, width: 1)
        artworkView.switchLayer(to: 0)
    }

    @IBAction func colorSelectButtonTapped(_ sender: UIBarButtonItem) {
        let paletteViewController = UIViewController()
        paletteViewController.view.backgroundColor = UIColor.lightGray
        paletteViewController.preferredContentSize = CGSize(width: 300, height: 300)
        let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        colorPicker.hexLabel.isHidden = true
        colorPicker.delegate = self
        paletteViewController.view.addSubview(colorPicker)
        paletteViewController.modalPresentationStyle = .popover
        let popoverPresentationController = paletteViewController.popoverPresentationController
        popoverPresentationController?.barButtonItem = editColorButton
        popoverPresentationController?.permittedArrowDirections = .any
        self.present(paletteViewController, animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension StudioViewController: ChromaColorPickerDelegate {
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        artworkView.setCurrentColor(to: color)
    }
    
}
