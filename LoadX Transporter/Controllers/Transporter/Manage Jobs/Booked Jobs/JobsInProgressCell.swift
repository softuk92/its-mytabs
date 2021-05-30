//
//  JobsInProgressCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class JobsInProgressCell: UITableViewCell {

    @IBOutlet weak var cellbackground_view: UIView!
    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var jobId: UILabel!
    @IBOutlet weak var pick_up: UILabel!
    @IBOutlet weak var drop_off: UILabel!
    @IBOutlet weak var businessCharges: UILabel!
    @IBOutlet weak var widthBusiness: NSLayoutConstraint!
    @IBOutlet weak var jobPrice: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var businessPatti: UIImageView!
    @IBOutlet weak var payment_method_lbl: UILabel!
    @IBOutlet weak var startJobBtn: UIButton!
    @IBOutlet weak var cancelJobBtn: UIButton!
    @IBOutlet weak var jobBookedFor: UILabel!
    @IBOutlet weak var jobBookedForView: UIStackView!
    
    var startJob: ((JobsInProgressCell) -> Void)?
    var cancelJob: ((JobsInProgressCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        customizeView()
    }
    
    func setJobBookedForView(workingHours: String) {
        if workingHours != "" || workingHours != "N/A" {
            jobBookedForView.isHidden = false
            jobBookedFor.text = workingHours
        } else {
            jobBookedForView.isHidden = true
        }
    }
    
    func customizeView() {
        innerView.layer.cornerRadius = 10
        startJobBtn.layer.cornerRadius = 10
        startJobBtn.clipsToBounds = true
        startJobBtn.layer.maskedCorners = [ .layerMaxXMaxYCorner]
               
        cancelJobBtn.layer.cornerRadius = 10
        cancelJobBtn.clipsToBounds = true
        cancelJobBtn.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    @IBAction func startJobAct(_ sender: Any) {
        startJob?(self)
    }

    @IBAction func cancelJobAct(_ sender: Any) {
        cancelJob?(self)
    }
    
}
