//
//  AlertViewWithDescription.swift
//  LoadX Transporter
//
//  Created by CTS Move on 07/12/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

public class AlertViewWithDesciption: UIView, NibOwnerLoadable {
    
    //MARK: - IBOutlets
    @IBOutlet weak public var centerView: UIView!
    @IBOutlet weak public var imageView: UIImageView!
    @IBOutlet weak public var question: UILabel!
    @IBOutlet weak public var no: UIButton!
    
    //MARK: - init
//    required public init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.loadNibContent()
//    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        customizeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func customizeUI() {
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOpacity = 0.8
        centerView.layer.shadowOffset = .zero
        centerView.layer.shadowRadius = 10
        centerView.layer.cornerRadius = 10
    }

}
