//
//  AlertView.swift
//  LoadX Transporter
//
//  Created by CTS Move on 04/12/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

public class AlertIfCashReceived: UIView, NibOwnerLoadable {
    
    //MARK: - IBOutlets
    @IBOutlet weak public var centerView: UIView!
    @IBOutlet weak public var imageView: UIImageView!
    @IBOutlet weak public var question: UILabel!
    @IBOutlet weak public var ensure: UILabel!
    @IBOutlet weak public var cashReceivedBtn: UIButton!
    @IBOutlet weak public var paymentLinkBtn: UIButton!
    @IBOutlet weak public var closeButton: UIButton!
    @IBOutlet weak public var closeButtonView: UIView!
    
    var cashReceivedCall: ((AlertIfCashReceived) -> Void)?
    var closeCall: ((AlertIfCashReceived) -> Void)?
    var sendPaymentLinkCall: ((AlertIfCashReceived) -> Void)?
        
    //MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        customizeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        if AppUtility.shared.country == .Pakistan {
            closeButtonView.isHidden = true
            ensure.text = ""
            cashReceivedBtn.backgroundColor = R.color.newBlueColor()
            paymentLinkBtn.backgroundColor = .darkGray
            paymentLinkBtn.setTitle("CLOSE", for: .normal)
            paymentLinkBtn.isHidden = true
        }
    }
    
    
    private func customizeUI() {
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOpacity = 0.8
        centerView.layer.shadowOffset = .zero
        centerView.layer.shadowRadius = 10
        centerView.layer.cornerRadius = 10
        setupUI()
        cashReceivedBtn.setTitle(string.cashReceived, for: .normal)
        question.text = string.haveYouCollectedCashOnThisJob
        cashReceivedBtn.titleLabel?.font = Config.shared.getFont(font: R.font.montserratLight(size: 11))
        question.font = Config.shared.getFont(font: R.font.montserratLight(size: 14))
    }
    
    @IBAction func cashReceivedAct(_ sender: Any) {
        cashReceivedCall?(self)
    }

    @IBAction func closeAct(_ sender: Any) {
        closeCall?(self)
    }
    
    @IBAction func sendPaymentLinkAct(_ sender: Any) {
        if AppUtility.shared.country == .Pakistan {
        closeCall?(self)
        } else {
        sendPaymentLinkCall?(self)
        }
    }
    
}
