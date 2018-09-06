//
//  PickArtworkView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/30.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol PickArtworkDelegate: class {
    func nextButtonDidTapped()
    func artworkSelectionDidChanged()
    func shouldLaunch(viewController: UIViewController)
}

class PickArtworkView: UIView {
    
    @IBOutlet weak var localArtworkCollectionView: UICollectionView! {
        didSet {
            localArtworkCollectionView.register(UINib(nibName:
                "LocalArtworkCollectionViewCell", bundle: Bundle.main),
                forCellWithReuseIdentifier: "localArtworkCollectionViewCell")
            localArtworkCollectionView.reloadData()
        }
    }
    @IBOutlet weak var nextButton: UIButton!
    
    weak var delegate: PickArtworkDelegate?
    
    var forkPreviews: [ForkPreview] = []
    
    var selectedIndex: Int?
    var selectedProject: (Bool, UUID)? {
        didSet {
            if selectedProject != nil {
                nextButton.isEnabled = true
            } else {
                nextButton.isEnabled = false
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        delegate?.nextButtonDidTapped()
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = APTheme.purpleHighLightColor
        imagePicker.modalPresentationStyle = .overCurrentContext
        delegate?.shouldLaunch(viewController: imagePicker)
    }
    
}

extension PickArtworkView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return forkPreviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "localArtworkCollectionViewCell", for: indexPath) as! LocalArtworkCollectionViewCell
        cell.forkPreview = forkPreviews[indexPath.row]
        if indexPath.row == selectedIndex {
            cell.setSelected()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = collectionView.frame
        let width = (frame.width - 10) / 2.0
        return CGSize(width: width, height: width * 0.87)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndex = selectedIndex {
            if let oldCell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0))
                as? LocalArtworkCollectionViewCell {
                oldCell.setDeselected()
            }
        }
        let cell = collectionView.cellForItem(at: indexPath) as! LocalArtworkCollectionViewCell
        if indexPath.row == selectedIndex {
            selectedIndex = nil
            cell.setDeselected()
            selectedProject = nil
        } else {
            selectedIndex = indexPath.row
            cell.setSelected()
            selectedProject = (true, forkPreviews[indexPath.row].uuid)
        }
        delegate?.artworkSelectionDidChanged()
    }
}


extension PickArtworkView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let newArtworkID = UUID()
        DataManager.defaultManager.saveArtwork(title: "New Artwork", description: nil, keyPhoto:
            selectedImage!, uuid: newArtworkID)
        selectedProject = (false, newArtworkID)
        nextButtonTapped(nextButton)
    }
}
