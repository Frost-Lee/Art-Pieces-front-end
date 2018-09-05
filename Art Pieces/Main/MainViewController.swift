//
//  MainViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/26.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var masterNavigationView: MasterNavigationView!
    
    var galleryView: GalleryView!
    var lectureView: LectureView!
    var addArtworkView: AddArtworkView!
    
    var onSightLockFrame: CGRect!
    var offSightLockFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMasterNavigationView()
        setupGalleryView()
        setupLectureView()
        setupAddArtworkView()
        setupLockFrames()
        setGalleryOnSight()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let screenWidth = UIScreen.main.bounds.width
        masterNavigationView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 110)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        masterNavigationView.loadUserPortrait()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupMasterNavigationView() {
        self.navigationController?.navigationBar.tintColor = UIColor.lightGray
        let masterNavigationNib = UINib(nibName: "MasterNavigationView", bundle: nil)
        masterNavigationView = masterNavigationNib.instantiate(withOwner: self, options: nil).first
            as? MasterNavigationView
        masterNavigationView.delegate = self
        self.view.addSubview(masterNavigationView)
    }
    
    private func setupGalleryView() {
        let nib = UINib(nibName: "Gallery", bundle: nil)
        galleryView = nib.instantiate(withOwner: self, options: nil).first as? GalleryView
        galleryView.delegate = self
        self.view.addSubview(galleryView)
    }
    
    private func setupLectureView() {
        let nib = UINib(nibName: "Lecture", bundle: nil)
        lectureView = nib.instantiate(withOwner: self, options: nil).first as? LectureView
        lectureView.delegate = self
        self.view.addSubview(lectureView)
    }
    
    private func setupAddArtworkView() {
        let nib = UINib(nibName: "AddArtworkView", bundle: nil)
        addArtworkView = nib.instantiate(withOwner: self, options: nil).first as? AddArtworkView
        addArtworkView.frame = self.view.frame
        addArtworkView.delegate = self
        self.view.addSubview(addArtworkView)
    }
    
    private func setupLockFrames() {
        let selfFrame = self.view.frame
        onSightLockFrame = CGRect(x: 0, y: 110, width: selfFrame.width, height: selfFrame.height - 110)
        offSightLockFrame = CGRect(x: selfFrame.width, y: 110, width: selfFrame.width, height:
            selfFrame.height - 110)
    }
    
    private func setGalleryOnSight() {
        galleryView.frame = onSightLockFrame
        lectureView.frame = offSightLockFrame
    }
    
    private func setLectureOnSight() {
        lectureView.frame = onSightLockFrame
        galleryView.frame = offSightLockFrame
    }

}


extension MainViewController: MasterNavigationDelegate {
    func galleryButtonDidTapped(_ sender: UIButton) {
        setGalleryOnSight()
    }
    
    func lectureButtonDidTapped(_ sender: UIButton) {
        setLectureOnSight()
    }
    
    func searchButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func settingButtonDidTapped(_ sender: UIButton) {
        
    }
    
    func notificationButtonDidTapped(_ sendr: UIButton) {
        
    }
    
    func meButtonDidTapped(_ sender: UIButton) {
        if AccountManager.defaultManager.isUserExist() {
            performSegue(withIdentifier: "showPersonal", sender: nil)
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
            present(storyboard.instantiateInitialViewController()!, animated: true, completion: nil)
        }
    }
    
    func artworkButtonDidTapped(_ sender: UIButton) {
        addArtworkView.activate()
    }
}


extension MainViewController: AddArtworkDelegate {
    func importButtonDidTapped(_ sender: UIButton) {
        addArtworkView.deactivate()
        let storyboard = UIStoryboard(name: "NewRepo", bundle: Bundle.main)
        let viewController = storyboard.instantiateInitialViewController()!
        viewController.modalPresentationStyle = .formSheet
        present(viewController, animated: true, completion: nil)
    }
    
    func createButtonDidTapped(_ sender: UIButton) {
        addArtworkView.deactivate()
        performSegue(withIdentifier: "showLectureEditViewController", sender: nil)
    }
}


extension MainViewController: GalleryDelegate {
    func galleryItemDidSelected(at index: Int) {
        self.performSegue(withIdentifier: "showArtworkDetail", sender: nil)
    }
}


extension MainViewController: LectureDelegate {
    func lectureItemDidSelected(at index: Int) {
        self.performSegue(withIdentifier: "showLectureDetail", sender: nil)
    }
}
