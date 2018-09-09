//
//  ArtworkForkViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/30.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class ArtworkForkViewController: APFormSheetViewController {
    
    var pickArtworkView: PickArtworkView!
    var addArtworkDescriptionView: AddArtworkDescriptionView!
    
    var isAddingDescriptions: Bool = false
    
    var currentRepoID: UUID!
    var currentRepoName: String!
    
    var webService = APWebService.defaultManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickArtworkView()
        setupAddArtworkDescriptionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let viewFrame = self.view.frame
        if isAddingDescriptions {
            pickArtworkView.frame = CGRect(x: -viewFrame.width, y: 20, width:
                viewFrame.width, height: viewFrame.height - 20)
            addArtworkDescriptionView.frame = CGRect(x: 0, y:
                20, width: viewFrame.width, height: viewFrame.height - 20)
        } else {
            pickArtworkView.frame = CGRect(x: 0, y: 20, width:
                viewFrame.width, height: viewFrame.height - 20)
            addArtworkDescriptionView.frame = CGRect(x: viewFrame.width, y:
                20, width: viewFrame.width, height: viewFrame.height - 20)
        }
    }
    
    private func setupPickArtworkView() {
        let nib = UINib(nibName: "PickArtworkView", bundle: Bundle.main)
        pickArtworkView = nib.instantiate(withOwner: self,
                                          options: nil).first as? PickArtworkView
        self.view.insertSubview(pickArtworkView, belowSubview: closeButton)
        pickArtworkView.delegate = self
        let artboards = DataManager.defaultManager.getAllArtboards()
        for artboard in artboards {
            pickArtworkView.forkPreviews.append(ForkPreview(artboard: artboard))
        }
        pickArtworkView.repoName = currentRepoName
    }
    
    private func setupAddArtworkDescriptionView() {
        let nib = UINib(nibName: "AddArtworkDescriptionView", bundle: Bundle.main)
        addArtworkDescriptionView = nib.instantiate(withOwner: self,
                                                    options: nil).first as? AddArtworkDescriptionView
        addArtworkDescriptionView.repoName = currentRepoName
        self.view.insertSubview(addArtworkDescriptionView, belowSubview: closeButton)
        addArtworkDescriptionView.delegate = self
    }
    
}


extension ArtworkForkViewController: PickArtworkDelegate {
    func nextButtonDidTapped() {
        isAddingDescriptions = true
        addArtworkDescriptionView.artworkKeyPhotoImageView.image = pickArtworkView.selectedProject?.1
        UIView.animate(withDuration: 0.2, delay: 0, options:
            UIView.AnimationOptions.curveLinear, animations: {
                self.viewWillLayoutSubviews()
        }, completion: nil)
    }
    
    func artworkSelectionDidChanged() {
    }
    
    func shouldLaunch(viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
}


extension ArtworkForkViewController: AddArtworkDescriptionDelegate {
    func shareButtonTapped() {
        let user = AccountManager.defaultManager.currentUser!
        let selectedWork = pickArtworkView.selectedProject!
        webService.uploadArtwork(creatorEmail: user.email, creatorPassword: user.password,
                                 title: addArtworkDescriptionView.artworkTitle, description:
            addArtworkDescriptionView.artworkDescription, keyPhoto:
            selectedWork.1, belongingRepo: currentRepoID, selfID: selectedWork.0) {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
        }
    }
}
