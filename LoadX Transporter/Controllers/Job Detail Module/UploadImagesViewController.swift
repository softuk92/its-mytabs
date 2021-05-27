//
//  ConfirmDamageViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 07/12/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import RxSwift
import KMPlaceholderTextView
import YPImagePicker
import SVProgressHUD

class UploadImagesViewController: UIViewController {
    
    @IBOutlet weak var selectImages: UIButton!
    @IBOutlet weak var receiversName: UITextField!
    @IBOutlet weak var desc: KMPlaceholderTextView!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    private var disposeBag = DisposeBag()
    
    var configPicker = YPImagePickerConfiguration()
    var picker : YPImagePicker!
    private var images = [UIImage]()
    var delId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        showPickerView()
        configureCollectionView()
        collectionViewHeight.constant = 0
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureUI() {
        submit.isEnabled = false
        desc.layer.cornerRadius = 5
        desc.layer.borderWidth = 0.1
        desc.layer.borderColor = UIColor.black.cgColor
        selectImages.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.present(self.picker, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        back.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(receiversName.rx.text.map{$0 != ""},desc.rx.text.map{$0 != ""}).map{$0.0 && $0.1}.bind(to: submit.rx.isEnabled).disposed(by: disposeBag)
    }

    @IBAction func getCall(_ sender: Any) {
        sendDamageReport()
    }
    
    func showPickerView() {
        configPicker.library.maxNumberOfItems = 5
        configPicker.screens = [.library, .photo]
        picker = YPImagePicker(configuration: configPicker)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                print("Picker was canceled")
            }
            self.images = []
            for item in items {
                switch item {
                case .photo(let photo):
                    self.images.append(photo.image)
                case .video(_):
                    return
                }
            }
            
            picker?.dismiss(animated: true, completion: nil)
            if self.images.count < 5 {
                self.collectionViewHeight.constant = 70
            } else if self.images.count == 0 {
                self.collectionViewHeight.constant = 0
            } else {
                self.collectionViewHeight.constant = 140
            }
            self.collectionView.reloadData()
        }
    }
    
    private func sendDamageReport() {
        guard let delId = delId else { return }
        let parameters = ["del_id" : delId, "r_id" : "", "receivername" : receiversName.text ?? "", "damage_description" : desc.text ?? ""]
        var input = [MultipartData]()
        for image in images {
            let imageData = image.resizeWithWidth(width: 500)?.jpegData(compressionQuality: 0.2)
            input.append(MultipartData.init(data: imageData ?? Data(), paramName: "job_damage_image", fileName: image.description))
        }
        APIManager.apiPostMultipart(serviceName: "api/transporterAddDamageReport", parameters: parameters, multipartImages: input) { [weak self] (data, json, error, progress) in
            guard let self = self else { return }
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            if progress != nil {
                showSuccessAlert(question: "Uploaded Images Successfully", imageName: "success", viewController: self)
            }
            
        }
    }
    
}

extension UploadImagesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
}

extension UploadImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ImageViewCell.self)
        cell.selectedImage.image = images[indexPath.row]
        return cell
    }
    
    
}
