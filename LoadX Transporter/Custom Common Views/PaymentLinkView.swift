//
//  PaymentLinkView.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 31/05/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

public class PaymentLinkView: UIView, NibOwnerLoadable {
    
    //MARK: - IBOutlets
    @IBOutlet weak public var centerView: UIView!
    
    //MARK: - init
    var sendPaymentLinkCall: ((PaymentLinkView) -> Void)?
    var noCall: ((PaymentLinkView) -> Void)?
    
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
    
    @IBAction func noAct(_ sender: Any) {
        noCall?(self)
    }
    
    @IBAction func sendPaymentLinkAct(_ sender: Any) {
        sendPaymentLinkCall?(self)
    }
    
}

