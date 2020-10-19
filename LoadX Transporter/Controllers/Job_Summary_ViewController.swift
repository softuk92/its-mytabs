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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customData = jsonData_inventory.dictionary ?? [:]
        items = customData.map({ (key, value) -> MenuItemStruct in
            return MenuItemStruct.init(title: key.replacingOccurrences(of: "_", with: " "), value: value.stringValue)
        })
        tableView.register(UINib(nibName: "ServiceHeaderCell", bundle: nil), forCellReuseIdentifier: "ServiceHeaderCell")
        tableView.register(UINib(nibName: "InventoryCell", bundle: nil), forCellReuseIdentifier: "InventoryCell")
        
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
         return 1
       }  else {
        if section == 0 {
            return self.items.count
        } else {
            return 1
        }
      }
//    }
  }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.items.count == 0 {
            return 525
        } else {
            if indexPath.section == 0 {
                return 50

            } else {
                return 525      
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if self.items.count == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! job_DetialView_TableViewCell
        
        self.del_id = jsonData[0]["del_id"].stringValue
        cell.jobId_lbl.text = "LOADX"+String(year)+"J"+(del_id ?? "")
        cell.category_lbl.text = jsonData[0]["add_type"].stringValue
        let pickUp_date = jsonData[0]["date"].stringValue
        
        if pickUp_date != ""{
            cell.pickUp_lbl.text = convertDateFormatter(pickUp_date)
        }
        cell.pickUp_time.text = jsonData[0]["timeslot"].stringValue
        
        self.Posteddate = jsonData[0]["job_posted_date"].stringValue
        
        if Posteddate != ""{
            cell.postedDate_lbl.text = convertDateFormatter(Posteddate)
        }
        let no_of_hepler = jsonData[0]["no_of_helper"].stringValue
        if no_of_hepler == "1" {
            cell.no_of_helpers_lbl.text = "Driver Only"
        }else{
            cell.no_of_helpers_lbl.text = no_of_hepler + " Helpers"
        }
        
        cell.supermarketName_lbl.text = jsonData[0]["super_market_name"].stringValue
        
        cell.movingFrom_lbl.text = jsonData[0]["moving_from"].stringValue
        cell.movingTo_lbl.text = jsonData[0]["moving_to"].stringValue
             
             cell.vehicleType_lbl.text = jsonData[0]["vehicle_type"].stringValue
             cell.No_of_vehicle_lbl.text = jsonData[0]["no_of_vehicle"].stringValue
             
             Vehicle_no = jsonData[0]["no_of_vehicle"].stringValue
             d_item = jsonData[0]["d_items"].stringValue
        
        if cell.category_lbl.text == "Dedicated Van" {
            cell.noOfHelpers_view.isHidden = false
            cell.noOfHelper_height.constant = 44
            
            cell.MovingFrom_view.isHidden = true
            cell.movingFrom_height.constant = 0
            cell.movingTo_view.isHidden = true
            cell.movingTo_height.constant = 0
            cell.vehicleType_view.isHidden = true
            cell.vehicleType_height.constant = 0
            cell.noOfVehicle_view.isHidden = true
            cell.no_ofVehicle_height.constant = 0
            cell.noOfBeds_view.isHidden = true
            cell.noOfBed_height.constant = 0
            cell.noOfItems_view.isHidden = true
            cell.noOfItem_height.constant = 0
            cell.supermarketName_view.isHidden = true
            cell.supermarketName_height.constant = 0
            cell.vehicleOperational_view.isHidden = true
            cell.vehicleOperational_height.constant = 0
            cell.jobDetialView_height.constant = 260
        }

//             if cell.category_lbl.text == "Furniture and General Items" || cell.category_lbl.text == "One Item" || cell.category_lbl.text == "Two Items" || cell.category_lbl.text == "Three or More Items" || cell.category_lbl.text == "Piano"  || cell.category_lbl.text == "Business & Industrial Goods" ||  cell.category_lbl.text == "Machine and Vehicle Parts" || cell.category_lbl.text == "Waste Removal" || cell.category_lbl.text ==  "Office Move" || cell.category_lbl.text == "Other"{
//
//                 cell.noOfBeds_view.isHidden = true
//                 cell.noOfVehicle_view.isHidden = true
//                 cell.vehicleType_view.isHidden = false
//                 cell.vehicleType_height.constant = 44
//                 cell.no_ofVehicle_height.constant = 0
//                 cell.noOfBed_height.constant = 0
//                 cell.jobDetialView_height.constant = 260
//
//                 cell.movingTo_view.isHidden = true
//                 cell.movingTo_height.constant = 0
//                 cell.MovingFrom_view.isHidden = true
//                 cell.movingFrom_height.constant = 0
//
//                 if d_item == "One Item" || cell.category_lbl.text == "One Item" {
//                     cell.noOfItems_view.isHidden = false
//                     cell.noOfItem_height.constant = 44
//                     cell.no_of_items_lbl.text = d_item
//                     cell.jobDetialView_height.constant = 404
//
//                 }else if d_item == "Two Items" || cell.category_lbl.text == "Two Items" {
//                     cell.noOfItems_view.isHidden = false
//                     cell.noOfItem_height.constant = 44
//                     cell.no_of_items_lbl.text = d_item
//                     cell.jobDetialView_height.constant = 404
//                 }else{
//                     cell.noOfItems_view.isHidden = true
//                     cell.noOfItem_height.constant = 0
//                     cell.jobDetialView_height.constant = 360
//                 }
//             } else {
             
//             if cell.category_lbl.text == "Cars & Vehicles" || cell.category_lbl.text == "Cars and Vehicles" || cell.category_lbl.text == "Bikes & Motorcycles"  {
//                 cell.movingTo_view.isHidden = true
//                 cell.MovingFrom_view.isHidden = true
//                 cell.movingTo_height.constant = 0
//                 cell.movingFrom_height.constant = 0
//                 cell.noOfBeds_view.isHidden = true
//                 cell.noOfBed_height.constant = 0
//                 cell.noOfVehicle_view.isHidden = true
//                 cell.no_ofVehicle_height.constant = 0
//                 cell.noOfItems_view.isHidden = true
//                 cell.noOfItem_height.constant = 0
//                 cell.jobDetialView_height.constant = 316
//
//                 cell.vehicleType_view.isHidden = true
//                 cell.vehicleType_height.constant = 0
//
//             }
             
//             if cell.category_lbl.text == "Moving Home" {
//                 cell.no_of_helpers_lbl.text = "2"+" Persons"
//                 cell.noOfBeds_view.isHidden = false
//                 cell.noOfBed_height.constant = 44
//
////                 cell.jobDetialView_height.constant = 400
//                 if Vehicle_no == "1"{
//                     cell.No_of_vehicle_lbl.text = Vehicle_no! + " Vehicle"
//                 }else{
//                     cell.No_of_vehicle_lbl.text = Vehicle_no! + " Vehicles"
//                 }
//             }
             
             return cell
//            }
        }
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell") as! InventoryCell
            let menuItem = items[indexPath.row]
            cell.lblInventoryName.text = menuItem.title
            cell.lblInventoryNum.text = menuItem.value

         return cell

      } else  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! job_DetialView_TableViewCell
        
        self.del_id = jsonData[0]["del_id"].stringValue
        
//        
//        if jsonData[0]["description"].stringValue == ""{
//            
//            cell.jobDesrpt_view.isHidden = true
//            cell.jobDescrp_height.constant = 0
//            cell.job_description_lbl.text = "nil"
//        }else{
//            cell.jobDesrpt_view.isHidden = false
//            cell.jobDescrp_height.constant = 80
//            cell.job_description_lbl.text = jsonData[0]["description"].stringValue
//        }
        cell.category_lbl.text = jsonData[0]["add_type"].stringValue
        cell.movingFrom_lbl.text = jsonData[0]["moving_from"].stringValue
        cell.movingTo_lbl.text = jsonData[0]["moving_to"].stringValue
        
        cell.pickUp_time.text = jsonData[0]["timeslot"].stringValue
        
        self.Posteddate = jsonData[0]["job_posted_date"].stringValue
        let pickUp_date = jsonData[0]["date"].stringValue
        
        if pickUp_date != ""{
            let converted_pickUpDate = convertDateFormatter(pickUp_date)
            
            cell.pickUp_lbl.text = converted_pickUpDate
        }
        if Posteddate != ""{
            let convertedJobPostedDate = convertDateFormatter(Posteddate)
            cell.postedDate_lbl.text = convertedJobPostedDate
        }
        cell.vehicleType_lbl.text = jsonData[0]["vehicle_type"].stringValue
        cell.No_of_vehicle_lbl.text = jsonData[0]["no_of_vehicle"].stringValue
        let no_of_hepler = jsonData[0]["no_of_helper"].stringValue
        if no_of_hepler == "1" {
            cell.no_of_helpers_lbl.text = "Driver Only"
        }else{
            cell.no_of_helpers_lbl.text = no_of_hepler + " Helpers"
        }
        Vehicle_no = jsonData[0]["no_of_vehicle"].stringValue
        d_item = jsonData[0]["d_items"].stringValue
        
        
        let jobID = "LOADX"+String(year)+"J"+del_id!
        cell.jobId_lbl.text = jobID
        
//        if jsonData_inventory.stringValue == "" {
//
//            cell.inventory_view.isHidden = true
//            cell.inventory_view_height.constant = 0
//
//        }else{
//            cell.inventory_view.isHidden = false
//            cell.inventory_view_height.constant = 120
//        }
        
//        if cell.category_lbl.text == "Furniture and General Items" || cell.category_lbl.text == "One Item" || cell.category_lbl.text == "Two Items" || cell.category_lbl.text == "Three or More Items" || cell.category_lbl.text == "Piano"  || cell.category_lbl.text == "Business & Industrial Goods" ||  cell.category_lbl.text == "Machine and Vehicle Parts" || cell.category_lbl.text == "Waste Removal" || cell.category_lbl.text ==  "Office Move" || cell.category_lbl.text == "Other"{
//
//            cell.noOfBeds_view.isHidden = true
//            cell.noOfBeds_view.isHidden = true
//            cell.noOfVehicle_view.isHidden = true
//            cell.vehicleType_view.isHidden = false
//            cell.vehicleType_height.constant = 44
//            cell.no_ofVehicle_height.constant = 0
//            cell.noOfBed_height.constant = 0
//            cell.jobDetialView_height.constant = 260
//
//            cell.movingTo_view.isHidden = true
//            cell.movingTo_height.constant = 0
//            cell.MovingFrom_view.isHidden = true
//            cell.movingFrom_height.constant = 0
//
//            if d_item == "One Item" || cell.category_lbl.text == "One Item" {
//                cell.noOfItems_view.isHidden = false
//                cell.noOfItem_height.constant = 44
//                cell.no_of_items_lbl.text = d_item
//                cell.jobDetialView_height.constant = 404
//
//            }else if d_item == "Two Items" || cell.category_lbl.text == "Two Items" {
//                cell.noOfItems_view.isHidden = false
//                cell.noOfItem_height.constant = 44
//                cell.no_of_items_lbl.text = d_item
//                cell.jobDetialView_height.constant = 404
//            }else{
//                cell.noOfItems_view.isHidden = true
//                cell.noOfItem_height.constant = 0
//                cell.jobDetialView_height.constant = 360
//            }
//        }
        
//        if cell.category_lbl.text == "Cars & Vehicles" || cell.category_lbl.text == "Cars and Vehicles" || cell.category_lbl.text == "Bikes & Motorcycles"  {
//            cell.movingTo_view.isHidden = true
//            cell.MovingFrom_view.isHidden = true
//            cell.movingTo_height.constant = 0
//            cell.movingFrom_height.constant = 0
//            cell.noOfBeds_view.isHidden = true
//            cell.noOfBed_height.constant = 0
//            cell.noOfVehicle_view.isHidden = true
//            cell.no_ofVehicle_height.constant = 0
//            cell.noOfItems_view.isHidden = true
//            cell.noOfItem_height.constant = 0
//            cell.jobDetialView_height.constant = 316
//
//            cell.vehicleType_view.isHidden = true
//            cell.vehicleType_height.constant = 0
//
//        }
//
//        if cell.category_lbl.text == "Moving Home" {
//            cell.no_of_helpers_lbl.text = "2"+" Persons"
//            cell.noOfBeds_view.isHidden = false
//            cell.noOfBed_height.constant = 44
//
//            cell.jobDetialView_height.constant = 400
//            if Vehicle_no == "1"{
//                cell.No_of_vehicle_lbl.text = Vehicle_no! + " Vehicle"
//            }else{
//                cell.No_of_vehicle_lbl.text = Vehicle_no! + " Vehicles"
//            }
//        }
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
