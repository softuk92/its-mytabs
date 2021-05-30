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

public class JobSummaryView: UIView, NibOwnerLoadable {
    
    //MARK: - IBOutlets
    @IBOutlet weak public var centerView: UIView!
    @IBOutlet weak public var cashReceived: UIButton!
    @IBOutlet weak public var closed: UIButton!
    @IBOutlet weak public var sendPaymentLink: UIButton!
    @IBOutlet weak public var jobBookedFor: UILabel!
    @IBOutlet weak public var completedTime: UILabel!
    @IBOutlet weak public var extraTime: UILabel!
    @IBOutlet weak public var extraAmount: UILabel!
    @IBOutlet weak public var extraTimeView: UIStackView!
    @IBOutlet weak public var extraAmountView: UIStackView!
    //MARK: - init
//    required public init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.loadNibContent()
//    }
    
    var cashReceivedCall: ((JobSummaryView) -> Void)?
    var closeCall: ((JobSummaryView) -> Void)?
    var sendPaymentLinkCall: ((JobSummaryView) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        customizeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setJobSummaryViews(input: JobSummaryModel) {
        if input.jobExtratime == "" && input.extraCharges == "" {
            self.extraTimeView.isHidden = true
            self.extraAmountView.isHidden = true
        } else {
            self.extraTimeView.isHidden = false
            self.extraAmountView.isHidden = false
        }
    }
    
    
    private func customizeUI() {
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOpacity = 0.8
        centerView.layer.shadowOffset = .zero
        centerView.layer.shadowRadius = 10
        centerView.layer.cornerRadius = 10
    }
    
    @IBAction func cashReceived(_ sender: Any) {
        cashReceivedCall?(self)
    }

    @IBAction func closeAct(_ sender: Any) {
        closeCall?(self)
    }
    
    @IBAction func sendPaymentLinkAct(_ sender: Any) {
        sendPaymentLinkCall?(self)
    }
    
}
