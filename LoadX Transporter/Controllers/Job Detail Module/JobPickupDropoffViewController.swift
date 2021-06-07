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
    case cashCollected
    case jobCompleted
}

enum PaymentType {
    case Account
    case Cash
}

enum MovingTo {
    case pickup
    case dropoff
}

class JobPickupDropoffViewController: UIViewController, StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "JobDetail", bundle: nil)
    
    @IBOutlet weak var PickupOrDropOff: UILabel!
    @IBOutlet weak var jobId: UILabel!
    @IBOutlet weak var timeEta: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var jobBookedFor: UILabel!
    @IBOutlet weak var jobBookedForStackView: UIStackView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var additionalDetailsTableView: UITableView!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    @IBOutlet weak var pickupArrivedBtn: UIButton!
    @IBOutlet weak var dropoffArrivedBtn: UIButton!
    @IBOutlet weak var runningLateBtn: UIButton!
    @IBOutlet weak var uploadImagesBtn: UIButton!
    @IBOutlet weak var leavingForDropoffBtn: UIButton!
    @IBOutlet weak var jobCompletedBtn: UIButton!
    @IBOutlet weak var cashCollectedBtn: UIButton!
    @IBOutlet weak var viewJobSummaryBtn: UIButton!
    @IBOutlet weak var sendPaymentLinkBtn: UIButton!
    @IBOutlet weak var upperButtonView: UIView!
    @IBOutlet weak var bottomButtonView: UIView!
    @IBOutlet weak var bottomButtonsStackView: UIStackView!
    @IBOutlet weak var timeCounterLabel: UILabel!
    @IBOutlet weak var cashToBeCollectedView: UIStackView!
    @IBOutlet weak var cashToBeCollected: UILabel!
    @IBOutlet weak var disclaimerView: UIView!
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
        let pickupAddress: String
        let dropoffAddress: String
        let customerName: String
        let customerNumber: String
        let addType: String
        let delId: String
        let jbId: String
        let paymentType: PaymentType
        var jobStatus: JobStatus
        let jobPrice: String
    }
    
    var input: Input!
    private var disposeBag = DisposeBag()
    var jobSummaryMO: JobSummaryModel?
    
    var routeSummaryDetails = [RouteSummaryDetails]()
    var items: [MenuItemStruct] = []
    var jobDescription: String? {
        didSet {
            jobDescriptionTextView.text = jobDescription
        }
    }
    
    var timer:Timer = Timer()
    var startTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.roundCorners(corners: [.topLeft, .topRight], radius: 5)
        bindButtons()
        setJobStatus()
        configureTableView()
        setData(input: input)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if input.jobStatus.arrival_at_pickup == "1" {
            setTimer()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    func setTimer() {
        guard input.jobStatus.is_job_started == "1" else { timeCounterLabel.isHidden = true; return }
        if input.addType == "Man & Van" || input.addType == "Man and Van" {
            timeCounterLabel.isHidden = false
            if let time = UserDefaults.standard.value(forKey: input.delId) as? Int, let previousDate = UserDefaults.standard.value(forKey: "previousTimerTime") as? Date {
                let seconds = Date().seconds(from: previousDate)
                
                startTime = time+seconds
                startTimer()
            } else {
                startTimer()
            }
        } else {
            timeCounterLabel.isHidden = true
        }
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
        self.customerName.text = input.customerName
        self.phoneNumber.text = input.customerNumber
        self.cashToBeCollected.text = input.jobPrice
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
//                self.jobBookedForStackView.isHidden = false
                self.jobBookedFor.text = workingHours + " Hours"
            } else {
//                self.jobBookedForStackView.isHidden = true
            }
            self.getData(jsonData: jsonData, jsonData_inventory: jsonData[1], movingTo: (self.input.jobStatus.p_leaving_f_dropoff == "0") ? .pickup : .dropoff)
            SVProgressHUD.dismiss()
        })
    }
    
    @IBAction func pickupArrivedAct(_ sender: Any) {
        showAlertView(question: "Have you arrived at pickup?", ensure: "", paymentLinkHeight: 0, status: .PickupArrived)
    }
    
    @IBAction func dropoffArrivedAct(_ sender: Any) {
        showAlertView(question: "Have you arrived at dropoff?", ensure: "", paymentLinkHeight: 0, status: .DropoffArrived)
    }
    
    @IBAction func runningLateAct(_ sender: Any) {
        showAlertView(question: "Are you running late?", ensure: "", paymentLinkHeight: 0, status: .RunningLate)
    }
    
    @IBAction func uploadImagesAct(_ sender: Any) {
        showAlertView(question: "Upload Image", ensure: "Please upload images according to the need or requirements.", paymentLinkHeight: 0, status: .UploadImages)
    }
    
    @IBAction func leavingForDropoffAct(_ sender: Any) {
        showAlertView(question: "Has this pickup been completed?", ensure: "", paymentLinkHeight: 0, status: .LeavingForDropoff)
    }
    
    @IBAction func jobCompletedAct(_ sender: Any) {
        showAlertView(question: "Has the job been completed?", ensure: "Before continuing ensure you submit the following: \n\n- Name & Signature of Recipient \n- Delivery Image Proof", paymentLinkHeight: 0, status: .jobCompleted)
    }
    
    @IBAction func cashCollectedAct(_ sender: Any) {
        showCashReceivedAlert()
    }
    
    @IBAction func viewJobSummaryAct(_ sender: Any) {
        viewJobSummary()
    }
    
    @IBAction func sendPaymentLinkAct(_ sender: Any) {
        sendPaymentLinkAlert()
    }
    
    @IBAction func showDislcaimerSceneAct(_ sender: Any) {
        showDisclimerScene()
    }
    
    func showDisclimerScene() {
            if let vc = UIStoryboard.init(name: "JobDetail", bundle: Bundle.main).instantiateViewController(withIdentifier: "DisclaimerViewController") as? DisclaimerViewController {
                vc.modalPresentationStyle = .fullScreen
                vc.jobId = input.delId
                vc.customerName = input.customerName.capitalized
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
    }
    
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertView(question: String, ensure: String, paymentLinkHeight: CGFloat, status: Status) {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
        aView.imageView.tintColor = R.color.mehroonColor()
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
                self.goToUploadDamageScene()
            case .cashCollected:
                self.CashReceivedOfJob()
            case .jobCompleted:
                self.goToJobCompletedScene()
            }
        }
        
        aView.noCall = { (_) in
            aView.removeFromSuperview()
        }
        
        aView.sendPaymentLinkCall = { [weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
            self.sendPaymentLink()
        }
        
        self.view.addSubview(aView)
    }
    
    func sendPaymentLinkAlert() {
        let aView = PaymentLinkView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        
        aView.sendPaymentLinkCall = { [weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
            self.sendPaymentLink()
        }
        
        aView.noCall = { (_) in
            aView.removeFromSuperview()
        }
        
        self.view.addSubview(aView)
    }
    
    func viewJobSummaryAlert(summaryMO: JobSummaryModel) {
        let summaryView = JobSummaryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        summaryView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        summaryView.setJobSummaryViews(input: summaryMO, paymentType: input.paymentType)
        
        summaryView.cashReceivedCall = {[weak self] (_) in
            guard let self = self else { return }
            summaryView.removeFromSuperview()
            self.CashReceivedOfJob()
        }
        
        summaryView.closeCall = { (_) in
            summaryView.removeFromSuperview()
        }
        
        summaryView.sendPaymentLinkCall = { [weak self] (_) in
            guard let self = self else { return }
            summaryView.removeFromSuperview()
            self.sendPaymentLink()
        }
        
        self.view.addSubview(summaryView)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    @objc func timerCounter() -> Void
        {
        UserDefaults.standard.setValue(startTime, forKey: input.delId)
        UserDefaults.standard.setValue(Date(), forKey: "previousTimerTime")
        startTime = startTime + 1
            let time = secondsToHoursMinutesSeconds(seconds: startTime)
            let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
            timeCounterLabel.text = timeString
        }
        
        func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
        {
            return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
        }
        
        func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
        {
            var timeString = ""
            timeString += String(format: "%02d", hours)
            timeString += " : "
            timeString += String(format: "%02d", minutes)
            timeString += " : "
            timeString += String(format: "%02d", seconds)
            return timeString
        }
}

extension JobPickupDropoffViewController: JobDetailSetupDelegate {
    func setView() {
        input.jobStatus.is_img_uploaded = "1"
        setJobStatus()
    }
    
}

extension JobPickupDropoffViewController: UITableViewDelegate, UITableViewDataSource {
    
    //tableview data
    func getData(jsonData: JSON, jsonData_inventory: JSON, movingTo: MovingTo = .pickup) {
        routeSummaryDetails.removeAll()
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
//        let Posteddate = convertDateFormatter(jsonData[0]["job_posted_date"].stringValue)
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
        
        info.append(MenuItemStruct.init(title: "Category", value: category))
        
        if pickupHouseNo != "" {
            info.append(MenuItemStruct.init(title: "Pickup House No.", value: pickupHouseNo))
        }
        if dropoffHouseNo != "" {
            info.append(MenuItemStruct.init(title: "Drop Off House No.", value: dropoffHouseNo))
        }
        
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
            info.append(MenuItemStruct.init(title: "Number of Helpers", value: no_of_hepler))
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
        timeEta.text = pickUp_time.uppercased()
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
