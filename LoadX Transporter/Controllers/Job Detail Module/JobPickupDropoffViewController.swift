//
//  JobPickupDropoffViewController.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 24/05/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import Reusable
import RxSwift

enum Status {
    case Arrived
    case RunningLate
    case UploadImages
    case LeavingForDropoff
}

class JobPickupDropoffViewController: UIViewController, StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "JobDetail", bundle: nil)
    
    @IBOutlet weak var PickupOrDropOff: UILabel!
    @IBOutlet weak var jobId: UILabel!
    @IBOutlet weak var timeEta: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var jobBookedFor: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var additionalDetailsTableView: UITableView!
    @IBOutlet weak var jobDescriptionTableView: UITableView!
    @IBOutlet weak var arrivedBtn: UIButton!
    @IBOutlet weak var runningLateBtn: UIButton!
    @IBOutlet weak var uploadImagesBtn: UIButton!
    @IBOutlet weak var leavingForDropoffBtn: UIButton!
    
    //Manage two tableview buttons
    @IBOutlet weak var detailTabView: UIView!
    @IBOutlet weak var leadingJobDescription: NSLayoutConstraint!
    @IBOutlet weak var trailingJobDescription: NSLayoutConstraint!
    @IBOutlet weak var leadingAdditionalDetails: NSLayoutConstraint!
    @IBOutlet weak var trailingAdditionalDetails: NSLayoutConstraint!
    @IBOutlet weak var additionalDetailsBtn: UIButton!
    @IBOutlet weak var jobDescriptionBtn: UIButton!
    @IBOutlet weak var titleView: UIView!
    
    struct Input {
        let pickupAddress: String?
        let dropoffAddress: String?
        let customerName: String
        let customerNumber: String
        let delId: String
        let jobStatus: JobStatus
    }
    
    var input: Input!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.roundCorners(corners: [.topLeft, .topRight], radius: 5)
        bindButtons()
        setData(input: input)
    }
    
    func setConstraints(leadingAdditionalDetails: Bool, trailingAdditionalDetails: Bool, leadingJobDescription: Bool, trailingJobDescription: Bool) {
        UIView.animate(withDuration: 3.0) { [weak self] in
            self?.leadingAdditionalDetails.isActive = leadingAdditionalDetails
            self?.trailingAdditionalDetails.isActive = trailingAdditionalDetails
            self?.leadingJobDescription.isActive = leadingJobDescription
            self?.trailingJobDescription.isActive = trailingJobDescription
        }
    }
    
    func bindButtons() {
        additionalDetailsBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.setConstraints(leadingAdditionalDetails: true, trailingAdditionalDetails: true, leadingJobDescription: false, trailingJobDescription: false)
            self?.additionalDetailsTableView.isHidden = false
            self?.jobDescriptionTableView.isHidden = true
        }).disposed(by: disposeBag)
        
        jobDescriptionBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.setConstraints(leadingAdditionalDetails: false, trailingAdditionalDetails: false, leadingJobDescription: true, trailingJobDescription: true)
            self?.additionalDetailsTableView.isHidden = true
            self?.jobDescriptionTableView.isHidden = false
        }).disposed(by: disposeBag)
    }
    
    func setHiddenStatuses(arrived: Bool, runningLate: Bool, uploadImages: Bool, bottomButton: Bool) {
        self.arrivedBtn.isHidden = arrived
        self.runningLateBtn.isHidden = runningLate
        self.uploadImagesBtn.isHidden = uploadImages
        self.leavingForDropoffBtn.isHidden = bottomButton
    }
    
    func setJobStatus() {
        let status = input.jobStatus
        if status.is_job_started == "0" {
            setHiddenStatuses(arrived: true, runningLate: true, uploadImages: true, bottomButton: true)
        } else {
            if status.p_leaving_f_dropoff == "0" {
                //pickup
    
            //check if driver is running late
            self.runningLateBtn.isHidden = !(status.arrival_at_pickup == "0" && status.is_running_late == "0")
            
                //check is driver is arrived at pickup or not
                if status.arrival_at_pickup == "0" {
                    self.arrivedBtn.isHidden = false
                    self.leavingForDropoffBtn.isHidden = false
                    self.uploadImagesBtn.isHidden = true
                } else {
                    self.uploadImagesBtn.isHidden = false
                    self.leavingForDropoffBtn.setTitle("Leaving for Dropoff", for: .normal)
                    self.leavingForDropoffBtn.isHidden = false
                }
                
            } else {
                //dropoff
                
            }
            
        }
    }
    
    func setData(input: Input) {
        SVProgressHUD.show()
        if let pickupAdd = input.pickupAddress {
            self.PickupOrDropOff.text = "Pickup"
            self.address.text = pickupAdd
        } else if let dropoffAdd = input.dropoffAddress {
            self.PickupOrDropOff.text = "Dropoff"
            self.address.text = dropoffAdd
        }
        self.customerName.text = input.customerName
        self.phoneNumber.text = input.customerNumber
        
        self.getJobDetails(delId: input.delId)
    }
    
    func getJobDetails(delId: String?) {
        guard let delId = delId else { return }
        APIManager.apiPost(serviceName: "api/job_detail", parameters: ["del_id": delId], completionHandler: { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                SVProgressHUD.dismiss()
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            
            guard let jsonData = json else { return }
            
            self.jobId.text = "LX00"+(jsonData[0]["del_id"].stringValue)
            let workingHours = jsonData[0]["working_hours"].stringValue
            
            if workingHours != "" && workingHours != "N/A" {
                self.jobBookedFor.isHidden = false
                self.jobBookedFor.text = workingHours + "Hours"
            } else {
                self.jobBookedFor.isHidden = true
            }
            
            SVProgressHUD.dismiss()
        })
    }
    
    @IBAction func arrivedAct(_ sender: Any) {
        showAlertView(question: "Have you arrived at stop?", ensure: "", paymentLinkHeight: 0, status: .Arrived)
    }
    
    @IBAction func runningLateAct(_ sender: Any) {
        showAlertView(question: "Are you running late?", ensure: "", paymentLinkHeight: 0, status: .RunningLate)
    }
    
    @IBAction func uploadImagesAct(_ sender: Any) {
        
    }
    
    @IBAction func leavingForDropoffAct(_ sender: Any) {
        
    }
    
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertView(question: String, ensure: String, paymentLinkHeight: CGFloat, status: Status) {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
        aView.question.text = question
        aView.ensure.text = ensure
        aView.sendPaymentLinkHeight.constant = paymentLinkHeight
        
        aView.yesCall = {[weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
            switch status {
            case .Arrived:
                return
            case .RunningLate:
                self.goToRunningLateScene()
            case .LeavingForDropoff:
                return
            case .UploadImages:
                return
            }
        }
        
        aView.noCall = { (_) in
            aView.removeFromSuperview()
        }
        
        aView.sendPaymentLinkCall = {[weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
        }
        
        self.view.addSubview(aView)
    }
    
}
