//
//  NewRepoViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/9/4.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class NewRepoViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    var newRepoView: NewRepoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewRepoView()
        launchImagePicker()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        newRepoView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width,
                                   height: self.view.frame.height - 20)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .overCurrentContext
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func setupNewRepoView() {
        let nib = UINib(nibName: "NewRepoView", bundle: Bundle.main)
        newRepoView = nib.instantiate(withOwner: self, options: nil).first as? NewRepoView
        self.view.insertSubview(newRepoView, belowSubview: closeButton)
        newRepoView.delegate = self
    }
    
}


extension NewRepoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        newRepoView.keyPhoto = selectedImage
        picker.dismiss(animated: true, completion: nil)
    }
}


extension NewRepoViewController: NewRepoDelegate {
    func shareButtonDidTapped() {
        newRepoView.beginAnimatingSpinner()
        let user = AccountManager.defaultManager.currentUser!
        let newArtworkID = UUID()
        let newRepoID = UUID()
        let title = newRepoView.title
        let description = newRepoView.repoDescription
        let keyPhoto = newRepoView.keyPhoto!
        APWebService.defaultManager.uploadArtwork(creatorEmail: user.email, creatorPassword:
            user.password, title: title, description: description, keyPhoto:
            keyPhoto, belongingRepo: nil, selfID: newArtworkID) {
                APWebService.defaultManager.createRepo(creatorEmail: user.email, creatorPassword:
                    user.password, title: title, description: description, selfID: newRepoID,
                                   keyArtworkID: newArtworkID) {
                    DataManager.defaultManager.saveArtwork(title: title, description:
                        description, keyPhoto: keyPhoto, uuid: newArtworkID)
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }
}
