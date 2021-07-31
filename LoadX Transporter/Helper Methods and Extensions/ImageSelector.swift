//
//  FMImageSelector.swift
//  FormBlok
//
//  Created by Yasir Ali on 07/03/2019.
//  Copyright © 2019 Yasir Ali. All rights reserved.
//

import UIKit
import Photos

@objc public protocol ImageSelectorDelegate: class {
//    @objc func imageSelector(didSelectImage image: UIImage?)
    @objc func imageSelector(didSelectImage image: UIImage? , imgName: String?)
    @objc optional func imageSelector(didDismissImagePicker imagePicker: UIImagePickerController)
    @objc optional func videoSelector(didSelectVideo url: URL)
}

public class ImageSelector: NSObject {
    
    private let imagePickerController: UIImagePickerController
    weak public var delegate: ImageSelectorDelegate?
    weak var viewController: UIViewController?
    
    public override init() {
        imagePickerController = UIImagePickerController()
        super.init()
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image"/*, "public.movie"*/]
//        imagePickerController.videoMaximumDuration = 10
        
//        imagePickerController.allowsEditing = true
        
    }
    
    public func showOptions(viewController: UIViewController) {
        self.viewController = viewController
        //"Photo Library"
        #warning("Enter localized strings for titles")
        let actionPhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { [weak self] (action) in
            self?.showImagePicker(sourceType: .photoLibrary)
        }
        // "Camera"
        let actionCamera = UIAlertAction(title: "Camera", style: .default) { [weak self](action) in
            self?.showImagePicker(sourceType: .camera)
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.delegate?.imageSelector?(didDismissImagePicker: UIImagePickerController.init())
        }
        
        showImagePickerAlert(viewController: viewController, actionPhotoLibrary: actionPhotoLibrary, actionCamera: actionCamera, actionCancel: actionCancel)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePickerController.sourceType = sourceType
        imagePickerController.modalPresentationStyle = .fullScreen
        viewController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func showImagePickerAlert(viewController:UIViewController,actionPhotoLibrary:UIAlertAction,actionCamera:UIAlertAction, actionCancel: UIAlertAction)  {
        // "Cancel"
//        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // "Choose photo using"
        let alert = UIAlertController(title: "Chose Photo", message: nil, preferredStyle: .actionSheet)
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        alert.addAction(actionPhotoLibrary)
        viewController.present(alert, animated: true, completion: nil)
    }
}


extension ImageSelector: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //image returned
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        
        var fileName: String?
        if let phAsset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            
             let resources = PHAssetResource.assetResources(for: phAsset)
             let orgFilename = resources.first?.originalFilename
            fileName = orgFilename
            
        }
        imagePickerController.dismiss(animated: true, completion: nil)
//      delegate?.imageSelector(didSelectImage: image)
        delegate?.imageSelector(didSelectImage: image, imgName: fileName)
        }
        
        if let videoURL = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerMediaURL")] as? URL {
            imagePickerController.dismiss(animated: true, completion: nil)
            delegate?.videoSelector?(didSelectVideo: videoURL)
        }
    }
    
    //canceled
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
        delegate?.imageSelector?(didDismissImagePicker: picker)
    }
    
}

