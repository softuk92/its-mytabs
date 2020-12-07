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
    var picker : YPImagePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        showPickerView()
    }
    
    func configureUI() {
        selectImages.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.present(self.picker, animated: true, completion: nil)
        }).disposed(by: disposeBag)

    }
    
    func showPickerView() {
        configPicker.library.maxNumberOfItems = 5
        configPicker.screens = [.library, .photo]
        picker = YPImagePicker(configuration: configPicker)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                print("Picker was canceled")
            }
            for item in items {
                switch item {
                case .photo(let photo):
                    return
                
                case .video(v: let v):
                    return
                }
            }
            picker?.dismiss(animated: true, completion: nil)
        }
    }

}
