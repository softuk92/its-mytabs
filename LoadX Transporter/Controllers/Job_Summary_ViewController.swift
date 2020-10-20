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

struct SummaryData {
    let label: String
    let detail: String
}

class Job_Summary_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var items: [MenuItemStruct] = []
    
    @IBOutlet weak var jobDesrpt_view: UIView!
    
    @IBOutlet weak var jobdescription_lbl: UILabel!
    @IBOutlet weak var jobDescrp_height: NSLayoutConstraint!
    var jsonData : JSON = []
    var jsonData_inventory : JSON = []
    
    var del_id: String?
    var Vehicle_no: String?
    var d_item: String?
    let year = Calendar.current.component(.year, from: Date())
    var Posteddate: String?
    var summaryData = [SummaryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customData = jsonData_inventory.dictionary ?? [:]
        items = customData.map({ (key, value) -> MenuItemStruct in
            return MenuItemStruct.init(title: key.replacingOccurrences(of: "_", with: " "), value: value.stringValue)
        })
        tableView.register(UINib(nibName: "ServiceHeaderCell", bundle: nil), forCellReuseIdentifier: "ServiceHeaderCell")
        tableView.register(UINib(nibName: "InventoryCell", bundle: nil), forCellReuseIdentifier: "InventoryCell")
        tableView.register(cellType: JobSummaryCell.self)
        
        print("\n this is inventry list value\n\(items)")
        
        if jsonData[0]["description"].stringValue == ""{
            
            self.jobDesrpt_view.isHidden = true
            self.jobDescrp_height.constant = 0
            self.jobdescription_lbl.text = "nil"
        }else{
            self.jobDesrpt_view.isHidden = false
            self.jobDescrp_height.constant = 80
            self.jobdescription_lbl.text = jsonData[0]["description"].stringValue
        }
    
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    
    func getData() {
        self.del_id = jsonData[0]["del_id"].stringValue
        
        let category = jsonData[0]["add_type"].stringValue
        let jobID = "LOADX"+String(year)+"J"+(del_id ?? "")
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
        
        summaryData.append(SummaryData(label: "Job ID", detail: jobID))
        summaryData.append(SummaryData(label: "Category", detail: category))
        
        if movingFrom_lbl != "" {
        summaryData.append(SummaryData(label: "Moving From", detail: movingFrom_lbl))
        }
        if movingTo_lbl != "" {
        summaryData.append(SummaryData(label: "Moving To", detail: movingTo_lbl))
        }
        
        summaryData.append(SummaryData(label: "Pickup Date", detail: pickUp_date))
        summaryData.append(SummaryData(label: "Pickup Time", detail: pickUp_time))
        summaryData.append(SummaryData(label: "Date Posted", detail: Posteddate))
        summaryData.append(SummaryData(label: "No. of Helpers", detail: no_of_hepler))
        
        if vehicleType_lbl != "" && vehicleType_lbl != "N/A" {
        summaryData.append(SummaryData(label: "Vehicle Type", detail: vehicleType_lbl))
        }
        
        if No_of_vehicle_lbl != "" && No_of_vehicle_lbl != "N/A" {
        summaryData.append(SummaryData(label: "No. of Vehicle", detail: No_of_vehicle_lbl))
        }

        if supermarketName_lbl != "" {
        summaryData.append(SummaryData(label: "Supermarket Name", detail: supermarketName_lbl))
        }
        
        if noOfPallate != "" && noOfPallate != "N/A" {
        summaryData.append(SummaryData(label: "No Of Pallet", detail: "\(noOfPallate) Pallet"))
        }
        
        if vehicleOperational != "" {
        summaryData.append(SummaryData(label: "Vehicle Operational", detail: "Yes"))
        }
    
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?   {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "ServiceHeaderCell") as! ServiceHeaderCell
        if items.count == 0 {
            headerCell.titleOfHeader.text = "Job Summary"
        } else {
            if section == 0 {
                headerCell.titleOfHeader.text = "Inventory List"
            } else {
                headerCell.titleOfHeader.text = "Job Summary"
            }
        }
        return headerCell.contentView

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if items.count == 0 {
            return 1
        } else {
            return 2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if items.count == 0 {
        return summaryData.count
        }  else {
        if section == 0 {
            return self.items.count
        } else {
            return summaryData.count
        }
      }
//    }
  }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count == 0 {
            return 50
        } else {
            if indexPath.section == 0 {
                return 50

            } else {
                return 50
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if self.items.count == 0 {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: JobSummaryCell.self)
//         cell.backgroundColor = nil
//        cell.backgroundView = nil
        cell.title.text = self.summaryData[indexPath.row].label
        cell.detail.text = self.summaryData[indexPath.row].detail
             
        return cell
        }
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell") as! InventoryCell
            let menuItem = items[indexPath.row]
            cell.lblInventoryName.text = menuItem.title
            cell.lblInventoryNum.text = menuItem.value

         return cell

      } else  {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: JobSummaryCell.self)
//             cell.backgroundColor = nil
//            cell.backgroundView = nil
        cell.title.text = self.summaryData[indexPath.row].label
        cell.detail.text = self.summaryData[indexPath.row].detail
             
        return cell

        }
       }
//    }
    
    func convertDateFormatter(_ date: String?) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date!)
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
}


struct MenuItemStruct {
    let title: String
    let value  : String
}
