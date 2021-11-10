//
//  Job_Jummary_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 30/01/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class Job_Summary_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var routeSummaryDetails = [RouteSummaryDetails]()
//    private var items: [MenuItemStruct] = []
    
    @IBOutlet weak var jobDesrpt_view: UIView!
    
    @IBOutlet weak var jobdescription_lbl: UILabel!
    @IBOutlet weak var jobDescrp_height: NSLayoutConstraint!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var jobImage1: UIImageView!
    @IBOutlet weak var jobImage2: UIImageView!
    @IBOutlet weak var jobImage3: UIImageView!
    
    var jsonData : JSON = []
    var jsonData_inventory : JSON = []
    
    var del_id: String?
    var Vehicle_no: String?
    var d_item: String?
    let year = Calendar.current.component(.year, from: Date())
    var Posteddate: String?
    var isJobNotBooked: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            self.jobDesrpt_view.isHidden = true
            self.jobDescrp_height.constant = 0
            self.jobdescription_lbl.text = "nil"
    
        configureTableView()
        getData()
        addZoomInimages()
    }
    
    func addZoomInimages() {
        jobImage1.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(imageTapped1(_:)))
        jobImage1.addGestureRecognizer(tap1)

        jobImage2.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(imageTapped2(_:)))
        jobImage2.addGestureRecognizer(tap2)
        
        jobImage3.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(imageTapped3(_:)))
        jobImage3.addGestureRecognizer(tap3)
    }
    
    @objc func imageTapped1(_ sender: UITapGestureRecognizer) {
        if #available(iOS 13.0, *) {
            let zoomCtrl = VKImageZoom()
            zoomCtrl.image = jobImage1.image
            self.present(zoomCtrl, animated: true, completion: nil)
        }
    }
    
    @objc func imageTapped2(_ sender: UITapGestureRecognizer) {
        if #available(iOS 13.0, *) {
            let zoomCtrl = VKImageZoom()
            zoomCtrl.image = jobImage2.image
            self.present(zoomCtrl, animated: true, completion: nil)
        }
    }
    
    @objc func imageTapped3(_ sender: UITapGestureRecognizer) {
        if #available(iOS 13.0, *) {
            let zoomCtrl = VKImageZoom()
            zoomCtrl.image = jobImage3.image
            self.present(zoomCtrl, animated: true, completion: nil)
        }
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: JobSummaryCell.self)
        tableView.tableFooterView = footerView
        tableView.tableHeaderView = UIView()
    }
    
    func getData() {
        var info = [MenuItemStruct]()
        let customData = jsonData_inventory.dictionary ?? [:]
        let inventoryList = customData.map({ (key, value) -> MenuItemStruct in
            return MenuItemStruct.init(title: key.replacingOccurrences(of: "_", with: " "), value: value.stringValue)
        })
        
        let desc = jsonData[0]["description"].stringValue
        if desc != "" {
            self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Description", detail: [MenuItemStruct.init(title: desc, value: "")]))
        }
        
        if inventoryList.count > 0 {
            self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Inventory List", detail: inventoryList))
        }
        self.del_id = jsonData[0]["del_id"].stringValue
        
        let category = jsonData[0]["add_type"].stringValue
		let jobID = AppUtility.shared.getLoadXJobID(id: del_id ?? "")
//        let jobID = jsonData[0]["formated_job_id"].stringValue
        let pickUp_date = convertDateFormatter(jsonData[0]["date"].stringValue)
        let pickUp_time = jsonData[0]["timeslot"].stringValue
        let Posteddate = convertDateFormatter(jsonData[0]["job_posted_date"].stringValue)
        let vehicleOperational = jsonData[0]["is_car_operational"].stringValue
        var no_of_hepler : String = ""
        if AppUtility.shared.country == .Pakistan {
        let helper = jsonData[0]["no_of_helper"].stringValue
        no_of_hepler = (helper == "0" || helper == "N/A") ? "No Help Required" : (helper == "1" ? "1 Helper" : "\(helper) Helpers")
        } else {
        no_of_hepler = (jsonData[0]["no_of_helper"].stringValue == "1") ? "Driver Only" : ("\(jsonData[0]["no_of_helper"].stringValue) Helpers")
        }
//        let no_of_hepler = (jsonData[0]["no_of_helper"].stringValue == "1") ? "Driver Only" : ("\(jsonData[0]["no_of_helper"].stringValue) Helpers")
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
        let weightUnit = jsonData[0]["weight_unit"].stringValue
        let estimatedWeight = jsonData[0]["est_weight"].stringValue
        let goodsType = jsonData[0]["good_type"].stringValue
        let image1 = jsonData[0]["image1"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let image2 = jsonData[0]["image2"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let image3 = jsonData[0]["image3"].stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let audioFileName = jsonData[0]["audio_file_name"].stringValue

            let url1 = URL(string: "\(main_URL)public/assets/job_images/\(image1)") ?? URL(fileURLWithPath: "\(main_URL)public/assets/job_images/\(image1)")
            jobImage1.sd_setImage(with: url1, completed: .none)

            let url2 = URL(string: "\(main_URL)public/assets/job_images/\(image2)") ?? URL(fileURLWithPath: "\(main_URL)public/assets/job_images/\(image2)")
            jobImage2.sd_setImage(with: url2, completed: .none)

            let url3 = URL(string: "\(main_URL)public/assets/job_images/\(image3)") ?? URL(fileURLWithPath: "\(main_URL)public/assets/job_images/\(image3)")
            jobImage3.sd_setImage(with: url3, completed: .none)

        
        info.append(MenuItemStruct.init(title: "Job ID", value: jobID))
        if !(AppUtility.shared.country == .Pakistan) {
        info.append(MenuItemStruct.init(title: "Category", value: category))
        }
        
        info.append(MenuItemStruct.init(title: "Pickup Date", value: pickUp_date))
        info.append(MenuItemStruct.init(title: "Pickup Time", value: pickUp_time))
        
        if isJobNotBooked != true {
            if AppUtility.shared.country == .Pakistan {
                if pickupHouseNo != "" {
                    info.append(MenuItemStruct.init(title: "Pickup Unit/Door No.", value: pickupHouseNo))
                }
                if dropoffHouseNo != "" {
                    info.append(MenuItemStruct.init(title: "Drop Off Unit/Door No.", value: dropoffHouseNo))
                }
            } else {
        if pickupHouseNo != "" {
            info.append(MenuItemStruct.init(title: "Pickup House No.", value: pickupHouseNo))
        }
        if dropoffHouseNo != "" {
            info.append(MenuItemStruct.init(title: "Drop Off House No.", value: dropoffHouseNo))
        }
            }
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
        
        
//        info.append(MenuItemStruct.init(title: "Date Posted", value: Posteddate))
        
        if category == "Dedicated Van" || category == "Man & Van" {
            if vehicleType_lbl != "" && vehicleType_lbl != "N/A" {
                info.append(MenuItemStruct.init(title: "Vehicle Type", value: vehicleType_lbl))
            }
        }
        
        if goodsType != "" && goodsType != "N/A" {
            info.append(MenuItemStruct.init(title: "Goods Type", value: goodsType))
        }
        if weightUnit != "" && weightUnit != "N/A" && estimatedWeight != "" && estimatedWeight != "N/A" {
            info.append(MenuItemStruct.init(title: "Estimated Weight", value: "\(estimatedWeight) \(weightUnit)"))
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
        
        if category == "Man & Van", workingHours != "" && workingHours != "N/A" && workingHours != "0" {
            info.append(MenuItemStruct.init(title: "Job Booked For", value: workingHours+"Hours"))
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
        
        if audioFileName != "" && audioFileName != "N/A" {
            let audioFileURL = "\(main_URL)public/assets/user_audio/\(audioFileName)"
            info.append(MenuItemStruct.init(title: "Voice Note", value: audioFileURL))
        }
//        "\(main_URL)public/assets/job_images/\(image1)"
        
        self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Job Summary", detail: info))
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 50))
        headerView.title.text = self.routeSummaryDetails[section].title
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        self.routeSummaryDetails.count
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
            cell.audioView.isHidden = true
        } else {
            cell.detail.isHidden = false
            cell.audioView.isHidden = true
            if self.routeSummaryDetails[indexPath.section].detail[indexPath.row].title == "Voice Note" {
                cell.audioUrl = self.routeSummaryDetails[indexPath.section].detail[indexPath.row].value
                cell.detail.isHidden = true
                cell.audioView.isHidden = false
            }
            cell.title.text = self.routeSummaryDetails[indexPath.section].detail[indexPath.row].title
            cell.detail.text = self.routeSummaryDetails[indexPath.section].detail[indexPath.row].value
        }
        return cell
    }

}


public struct MenuItemStruct {
    public let title: String
    public let value  : String
}
