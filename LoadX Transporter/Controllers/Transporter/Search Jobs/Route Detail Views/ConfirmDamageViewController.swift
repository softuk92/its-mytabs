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

class ConfirmDamageViewController: UIViewController {

    @IBOutlet weak var selectImages: UIButton!
    @IBOutlet weak var receiversName: UITextField!
    @IBOutlet weak var desc: KMPlaceholderTextView!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var back: UIButton!
    
    private var disposeBag = DisposeBag()
    
    var configPicker = YPImagePickerConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func showPickerView() {
        configPicker.library.maxNumberOfItems = 20
        configPicker.screens = [.photo]
        let picker = YPImagePicker(configuration: configPicker)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    print(photo)
                case .video(let video):
                    print(video)
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                print("Picker was canceled")
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        selectImages.rx.tap.subscribe(onNext: { [weak self] (_) in
            
        }).disposed(by: disposeBag)

    }

}
