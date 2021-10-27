//
//  JobsInProgressCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import RxSwift

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
    @IBOutlet weak var pickupTime: UILabel!
    
    @IBOutlet weak var receivedAmountView: UIStackView!
    @IBOutlet weak var receivedAmount: UILabel!
    @IBOutlet weak var transporterShareView: UIStackView!
    @IBOutlet weak var transporterShare: UILabel!
    @IBOutlet weak var loadxShareView: UIStackView!
    @IBOutlet weak var loadxShare: UILabel!
    @IBOutlet weak var jobPriceView: UIStackView!
    @IBOutlet weak var pickupTimeView: UIStackView!
    
    @IBOutlet weak var changeDriverRightView: UIView!
    @IBOutlet weak var changeDriverBtn: UIButton!
    @IBOutlet weak var changeDriverView: UIView!
    @IBOutlet weak var startJobView: UIView!
    
    @IBOutlet weak var transporterName: UILabel!
    @IBOutlet weak var transporterPhone: UILabel!
    @IBOutlet weak var jobPriceTitle: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var startJob: ((JobsInProgressCell) -> Void)?
    var cancelJob: ((JobsInProgressCell) -> Void)?
    weak var parentViewController: UIViewController!
    var jobID: String?
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        customizeView()
        setupViews()
        
        Config.shared.currentLanguage.subscribe(onNext: { [weak self] (lang) in
            self?.cancelJobBtn.setTitle(lang == .en ? "Cancel Job" : "جاب منسوخ کریں۔", for: .normal)
        }).disposed(by: disposeBag)
        
    }
    
    func setupViews() {
        if AppUtility.shared.country == .Pakistan {
            receivedAmountView.isHidden = false
            transporterShareView.isHidden = true            
            loadxShareView.isHidden = true
            jobPriceView.isHidden = true
            pickupTimeView.isHidden = true
        } else {
            receivedAmountView.isHidden = true
            transporterShareView.isHidden = true
            loadxShareView.isHidden = true
            jobPriceView.isHidden = false
            pickupTimeView.isHidden = false
        }
    }
    
    func setData(model: JobsInProgressModel) {
        receivedAmount.text = AppUtility.shared.currencySymbol+(Int(model.transporterShare ?? "")?.withCommas() ?? "0")
//        receivedAmount.text = AppUtility.shared.currencySymbol+(Int(model.price ?? "")?.withCommas() ?? "0")
//        transporterShare.text = AppUtility.shared.currencySymbol+(Int(model.transporterShare ?? "")?.withCommas() ?? "0")
        loadxShare.text = AppUtility.shared.currencySymbol+(Int(model.loadxShare ?? "")?.withCommas() ?? "0")
        transporterName.text = model.driverName?.capitalized
        transporterPhone.text = model.driverPhone
        jobID = model.jbID
        jobPriceTitle.text = model.isCod == "1" ? "Job Price" : "Job Price"
        if user_type == TransportationCompany {
            deleteBtn.isHidden = false
            if model.driverName?.lowercased() == user_name?.lowercased() {
                if model.isJobStarted != "1" {
                    changeDriverView.isHidden = true
                    startJobView.isHidden = false
                    cancelJobBtn.setTitle("Assign Driver", for: .normal)
                } else {
                    changeDriverView.isHidden = false
                    startJobView.isHidden = true
                }
            } else {
//                if model.isJobStarted != "1" {
//                    changeDriverView.isHidden = true
//                    startJobView.isHidden = false
//                    cancelJobBtn.setTitle("Assign Driver", for: .normal)
//                } else {
                changeDriverView.isHidden = false
                startJobView.isHidden = true
//                }
            }
            
        } else {
            deleteBtn.isHidden = true
            changeDriverView.isHidden = true
            startJobView.isHidden = false
        }
        
    }
    
    func setJobBookedForView(workingHours: String?, category: String) {
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
    
    func customizeView() {
        innerView.layer.cornerRadius = 10
        startJobBtn.layer.cornerRadius = 10
        startJobBtn.clipsToBounds = true
        startJobBtn.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        changeDriverBtn.layer.cornerRadius = 10
        changeDriverBtn.clipsToBounds = true
        changeDriverBtn.layer.maskedCorners = [ .layerMaxXMaxYCorner]
               
        cancelJobBtn.layer.cornerRadius = 10
        cancelJobBtn.clipsToBounds = true
        cancelJobBtn.layer.maskedCorners = [.layerMinXMaxYCorner]
        changeDriverRightView.layer.cornerRadius = 10
        changeDriverRightView.clipsToBounds = true
        changeDriverRightView.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    @IBAction func startJobAct(_ sender: Any) {
        startJob?(self)
    }

    @IBAction func cancelJobAct(_ sender: Any) {
        if cancelJobBtn.titleLabel?.text == "Assign Driver" {
            goToAssignDriver()
            return
        }
        cancelJob?(self)
    }
    
    @IBAction func deleteJob(_ sender: Any) {
        cancelJob?(self)
    }
    
    @IBAction func changeDriver(_ sender: Any) {
        goToAssignDriver()
    }
    
    func goToAssignDriver() {
        if let vc = UIStoryboard.init(name: "AssignDriver", bundle: Bundle.main).instantiateViewController(withIdentifier: "AssignDriverViewController") as? AssignDriverViewController {
            vc.jobID = jobID
            parentViewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
