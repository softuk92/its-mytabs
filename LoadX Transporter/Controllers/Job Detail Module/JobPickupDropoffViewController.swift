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
import SwiftyJSON

enum Status {
    case PickupArrived
    case DropoffArrived
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
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var pickupArrivedBtn: UIButton!
    @IBOutlet weak var dropoffArrivedBtn: UIButton!
    @IBOutlet weak var runningLateBtn: UIButton!
    @IBOutlet weak var uploadImagesBtn: UIButton!
    @IBOutlet weak var leavingForDropoffBtn: UIButton!
    @IBOutlet weak var jobCompletedBtn: UIButton!
    @IBOutlet weak var upperButtonView: UIView!
    @IBOutlet weak var bottomButtonView: UIView!
    @IBOutlet weak var bottomButtonsStackView: UIStackView!
    
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
    
    var routeSummaryDetails = [RouteSummaryDetails]()
    var items: [MenuItemStruct] = []
    var jobDescription: String? {
        didSet {
            jobDescriptionTextView.text = jobDescription
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.roundCorners(corners: [.topLeft, .topRight], radius: 5)
        bindButtons()
        setJobStatus()
        configureTableView()
        setData(input: input)
    }
    
    func configureTableView() {
        additionalDetailsTableView.delegate = self
        additionalDetailsTableView.dataSource = self
        additionalDetailsTableView.register(cellType: JobSummaryCell.self)
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
            self?.jobDescriptionTextView.isHidden = true
        }).disposed(by: disposeBag)
        
        jobDescriptionBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.setConstraints(leadingAdditionalDetails: false, trailingAdditionalDetails: false, leadingJobDescription: true, trailingJobDescription: true)
            self?.additionalDetailsTableView.isHidden = true
            self?.jobDescriptionTextView.isHidden = false
        }).disposed(by: disposeBag)
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
            self.getData(jsonData: jsonData, jsonData_inventory: jsonData[1])
            SVProgressHUD.dismiss()
        })
    }
    
    @IBAction func pickupArrivedAct(_ sender: Any) {
        showAlertView(question: "Have you arrived at stop?", ensure: "", paymentLinkHeight: 0, status: .PickupArrived)
    }
    
    @IBAction func dropoffArrivedAct(_ sender: Any) {
        showAlertView(question: "Have you arrived at stop?", ensure: "", paymentLinkHeight: 0, status: .DropoffArrived)
    }
    
    @IBAction func runningLateAct(_ sender: Any) {
        showAlertView(question: "Are you running late?", ensure: "", paymentLinkHeight: 0, status: .RunningLate)
    }
    
    @IBAction func uploadImagesAct(_ sender: Any) {
        
    }
    
    @IBAction func leavingForDropoffAct(_ sender: Any) {
        
    }
    
    @IBAction func jobCompletedAct(_ sender: Any) {
        
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
            case .PickupArrived:
                self.pickupArrived()
            case .DropoffArrived:
                self.dropoffArrived()
            case .RunningLate:
                self.goToRunningLateScene()
            case .LeavingForDropoff:
                self.leavingForDropoff()
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

extension JobPickupDropoffViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getData(jsonData: JSON, jsonData_inventory: JSON) {
        var info = [MenuItemStruct]()
        let customData = jsonData_inventory.dictionary ?? [:]
        let inventoryList = customData.map({ (key, value) -> MenuItemStruct in
            return MenuItemStruct.init(title: key.replacingOccurrences(of: "_", with: " "), value: value.stringValue)
        })
        
        let desc = jsonData[0]["description"].stringValue
        if desc != "" {
            jobDescription = desc
//            self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Description", detail: [MenuItemStruct.init(title: desc, value: "")]))
        }
        
        if inventoryList.count > 0 {
            self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Inventory List", detail: inventoryList))
        }
        
        let category = jsonData[0]["add_type"].stringValue
        let jobID = "LX00"+jsonData[0]["del_id"].stringValue
        let pickUp_date = convertDateFormatter(jsonData[0]["date"].stringValue)
        let pickUp_time = jsonData[0]["timeslot"].stringValue
        let Posteddate = convertDateFormatter(jsonData[0]["job_posted_date"].stringValue)
        let vehicleOperational = jsonData[0]["is_car_operational"].stringValue
        let no_of_hepler = (jsonData[0]["no_of_helper"].stringValue == "1") ? "Driver Only" : ("\(jsonData[0]["no_of_helper"].stringValue) Helpers")
        let supermarketName_lbl = jsonData[0]["super_market_name"].stringValue
        let movingFrom_lbl = jsonData[0]["moving_from"].stringValue
        let movingTo_lbl = jsonData[0]["moving_to"].stringValue
        let vehicleType_lbl = jsonData[0]["vehicle_type"].stringValue
        let No_of_vehicle_lbl = jsonData[0]["no_of_vehicle"].stringValue
        let noOfPallate = jsonData[0]["noOfPallet"].stringValue
        let carMake = jsonData[0]["car_make"].stringValue
        let carModel = jsonData[0]["car_model"].stringValue
        let pickupLift = jsonData[0]["pickup_lift"].stringValue
        let dropoffLift = jsonData[0]["dropoff_lift"].stringValue
        let pickupPropertyType = jsonData[0]["pickup_prop_type"].stringValue
        let dropoffPropertyType = jsonData[0]["dropoff_prop_type"].stringValue
        let pickupHouseNo = jsonData[0]["pu_house_no"].stringValue
        let dropoffHouseNo = jsonData[0]["do_house_no"].stringValue
        let workingHours = jsonData[0]["working_hours"].stringValue
        let extraHalfHours = jsonData[0]["helper_extra_half_hr_charges"].stringValue
        
        info.append(MenuItemStruct.init(title: "Job ID", value: jobID))
        info.append(MenuItemStruct.init(title: "Category", value: category))
        
//        if isJobNotBooked != true {
        if pickupHouseNo != "" {
            info.append(MenuItemStruct.init(title: "Pickup House No.", value: pickupHouseNo))
        }
        if dropoffHouseNo != "" {
            info.append(MenuItemStruct.init(title: "Drop Off House No.", value: dropoffHouseNo))
        }
//        }
        
        if movingFrom_lbl != "" {
        info.append(MenuItemStruct.init(title: "Moving From", value: movingFrom_lbl))
        }
        if movingTo_lbl != "" {
        info.append(MenuItemStruct.init(title: "Moving To", value: movingTo_lbl))
        }
        
        if category == "Furniture and General Items" || category == "Furniture & General Items" {
            if pickupLift != "" && movingFrom_lbl.lowercased() != "ground floor" {
                info.append(MenuItemStruct.init(title: "Lift at Pick Up", value: (pickupLift == "0") ? "No" : "Yes"))
            }
            if dropoffLift != "" && movingTo_lbl.lowercased() != "ground floor" {
                info.append(MenuItemStruct.init(title: "Lift at Drop Off", value: (dropoffLift == "0") ? "No" : "Yes"))
            }
        }
        
        if category == "Moving Home" || category == "House Move" {
            if pickupPropertyType != "" {
                info.append(MenuItemStruct.init(title: "Pickup Property Type", value: pickupPropertyType))
            }
            if dropoffPropertyType != "" {
                info.append(MenuItemStruct.init(title: "Dropoff Property Type", value: dropoffPropertyType))
            }
        }
        
        info.append(MenuItemStruct.init(title: "Pickup Date", value: pickUp_date))
        info.append(MenuItemStruct.init(title: "Pickup Time", value: pickUp_time))
        info.append(MenuItemStruct.init(title: "Date Posted", value: Posteddate))
        
        if category == "Dedicated Van" || category == "Man & Van" {
            if vehicleType_lbl != "" && vehicleType_lbl != "N/A" {
                info.append(MenuItemStruct.init(title: "Vehicle Type", value: vehicleType_lbl))
            }
        }
        if category == "Vehicle Move" {
            if vehicleType_lbl != "" && vehicleType_lbl != "N/A" {
                info.append(MenuItemStruct.init(title: "Vehicle Type", value: vehicleType_lbl))
            }
            if carMake != "" {
                info.append(MenuItemStruct.init(title: "Car Make", value: carMake))
            }
            if carModel != "" {
                info.append(MenuItemStruct.init(title: "Car Model", value: carModel))
            }
            if vehicleOperational != "" {
                info.append(MenuItemStruct.init(title: "Vehicle Operational", value: (vehicleOperational == "0") ? "No" : "Yes"))
            }
        } else {
            info.append(MenuItemStruct.init(title: "No. of Helpers", value: no_of_hepler))
        }
        
        if category == "Man & Van", workingHours != "" && workingHours != "N/A" {
            info.append(MenuItemStruct.init(title: "Working Hours Required", value: workingHours))
        }
        
        if extraHalfHours != "" && extraHalfHours != "N/A" {
            info.append(MenuItemStruct.init(title: "Extra Charges", value: "£\(extraHalfHours)/half hour after booked time"))
        }
        
        if noOfPallate != "" && noOfPallate != "N/A" {
            info.append(MenuItemStruct.init(title: "No Of Pallet", value: "\(noOfPallate) Pallet"))
        }
        
        if No_of_vehicle_lbl != "" && No_of_vehicle_lbl != "N/A" {
            info.append(MenuItemStruct.init(title: "No. of Vehicle", value: No_of_vehicle_lbl))
        }
        
        if supermarketName_lbl != "" {
            info.append(MenuItemStruct.init(title: "Supermarket Name", value: supermarketName_lbl))
        }
        self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Summary", detail: info))
        additionalDetailsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?   {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.additionalDetailsTableView.bounds.width, height: 50))
        headerView.title.text = self.routeSummaryDetails[section].title
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
            if routeSummaryDetails.count > 1 {
        return 50
            } else {
                return 0
            }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.routeSummaryDetails.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeSummaryDetails[section].detail.count

  }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: JobSummaryCell.self)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        if self.routeSummaryDetails[indexPath.section].detail[indexPath.row].value == "" {
            cell.title.text = self.routeSummaryDetails[indexPath.section].detail[indexPath.row].title
            cell.title.font = UIFont(name: "Montserrat-Light", size: 13)
            cell.detail.isHidden = true
        } else {
            cell.title.text = self.routeSummaryDetails[indexPath.section].detail[indexPath.row].title
            cell.detail.text = self.routeSummaryDetails[indexPath.section].detail[indexPath.row].value
            cell.detail.isHidden = false
        }
        return cell
        
    }

}
