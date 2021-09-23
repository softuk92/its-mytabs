//
//  CompletedJobsCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class CompletedJobsCell: UITableViewCell {

    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var pick_up: UILabel!
    @IBOutlet weak var drop_off: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var receivedAmountStatus: UILabel!
    
    @IBOutlet weak var businessPatti: UIImageView!
    @IBOutlet weak var widthBusiness: NSLayoutConstraint!
   
    @IBOutlet weak var payment_type_lbl: UILabel!
    @IBOutlet weak var dateIcon: UIImageView!
   
    @IBOutlet weak var completion_dateView: UIView!
    @IBOutlet weak var completionDate_Lbl: UILabel!
    @IBOutlet weak var cellBackground_view: UIView!

    @IBOutlet weak var delete_btn: UIButton!
    @IBOutlet weak var jobBookedFor: UILabel!
    @IBOutlet weak var jobBookedForView: UIStackView!
    
    @IBOutlet weak var receivedAmountView: UIStackView!
    @IBOutlet weak var receivedAmount: UILabel!
    @IBOutlet weak var transporterShareView: UIStackView!
    @IBOutlet weak var transporterShare: UILabel!
    @IBOutlet weak var transporterShareTitle: UILabel!
    @IBOutlet weak var loadxShareView: UIStackView!
    @IBOutlet weak var loadxShare: UILabel!
    @IBOutlet weak var jobPriceView: UIStackView!
    @IBOutlet weak var contactPerson: UILabel!
    @IBOutlet weak var loadxShareStatus: UILabel!
    @IBOutlet weak var jobId: UILabel!
    
    var deleteRow: ((CompletedJobsCell) -> Void)?
    var transporterProfileRow: ((CompletedJobsCell) -> Void)?
    var detailJobRow: ((CompletedJobsCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CompletedJobsCell.viewDetails))
        moving_item.isUserInteractionEnabled = true
        moving_item.addGestureRecognizer(tap)
        
    }
    
    func setupViews(paymentType: String, dueAmountStatus: String, lxShareStatus: String, isCOD: Bool) {
        if AppUtility.shared.country == .Pakistan {
            jobPriceView.isHidden = true
            if paymentType.lowercased() == "full" && isCOD {
                receivedAmountView.isHidden = false
                transporterShareView.isHidden = false
                loadxShareView.isHidden = false
                loadxShareStatus.isHidden = false
                loadxShareStatus.text = lxShareStatus
            } else if paymentType.lowercased() == "initial" {
                loadxShareView.isHidden = true
                transporterShareView.isHidden = false
                receivedAmountView.isHidden = true
                loadxShareStatus.isHidden = true
                transporterShareTitle.text = "Job Price"
        } else {
            receivedAmountView.isHidden = true
            transporterShareView.isHidden = true
            loadxShareView.isHidden = true
            jobPriceView.isHidden = false
        }
        }
//            if paymentType.lowercased() == "full" {
//                if (dueAmountStatus.lowercased() == "pending" || dueAmountStatus.lowercased() == "paid") && !isCOD {
//                    loadxShareView.isHidden = true
//                    transporterShareView.isHidden = false
//                    receivedAmountView.isHidden = true
//                    loadxShareStatus.isHidden = true
//                    transporterShareTitle.text = "Job Price"
//                }
//                if (dueAmountStatus.lowercased() == "pending" || dueAmountStatus.lowercased() == "paid") && isCOD {
//                    receivedAmountView.isHidden = false
//                    transporterShareView.isHidden = false
//                    loadxShareView.isHidden = false
//                    loadxShareStatus.isHidden = false
//                    loadxShareStatus.text = lxShareStatus
//                }
//            }
//            if paymentType.lowercased() == "initial" {
//                    loadxShareView.isHidden = true
//                    transporterShareView.isHidden = false
//                    receivedAmountView.isHidden = true
//                    loadxShareStatus.isHidden = true
//                    transporterShareTitle.text = "Job Price"
//            }
//        } else {
//            receivedAmountView.isHidden = true
//            transporterShareView.isHidden = true
//            loadxShareView.isHidden = true
//            jobPriceView.isHidden = false
//        }
    }

    func setData(model: CompletedJobsModel) {
        let price = model.job_price == nil ? model.price : Int(model.job_price ?? "")
        receivedAmount.text = AppUtility.shared.currencySymbol+(price?.withCommas() ?? "0")
        transporterShare.text = AppUtility.shared.currencySymbol+(Int(model.transporter_share)?.withCommas() ?? "0")
        loadxShare.text = AppUtility.shared.currencySymbol+(Int(model.loadx_share ?? "")?.withCommas() ?? "0")
        contactPerson.text = model.customer_name != nil ? model.customer_name?.capitalized : model.contact_person?.capitalized
        setupViews(paymentType: model.payment_type, dueAmountStatus: model.amount_status, lxShareStatus: (model.loadx_share_status ?? ""), isCOD: model.is_cod == "1")
        jobId.text = "LX00\(model.del_id)"
    }

    func setJobBookedForView(workingHours: String?, category: String?) {
        if category == "Man & Van" || category == "Man and Van" {
        if let workingHours = workingHours, workingHours != "" && workingHours != "N/A" {
            if workingHours == "0" {
                jobBookedForView.isHidden = true
                return
            }
            jobBookedForView.isHidden = false
            jobBookedFor.text = workingHours + " Hours"
        } else {
            jobBookedForView.isHidden = true
        }
        } else {
            jobBookedForView.isHidden = true
        }
    }
    
    @objc func viewDetails(sender: UITapGestureRecognizer) {
        detailJobRow?(self)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        deleteRow?(self)
    }

}
