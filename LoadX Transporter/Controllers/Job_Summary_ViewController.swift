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
        tableView.register(UINib(nibName: "ServiceHeaderCell", bundle: nil), forCellReuseIdentifier: "ServiceHeaderCell")
        tableView.register(UINib(nibName: "InventoryCell", bundle: nil), forCellReuseIdentifier: "InventoryCell")
        
        print("\n this is inventry list value\n\(jsonData_inventory)")
        
        if jsonData[0]["description"].stringValue == ""{
                        
                        self.jobDesrpt_view.isHidden = true
                        self.jobDescrp_height.constant = 0
                        self.jobdescription_lbl.text = "nil"
                    }else{
                        self.jobDesrpt_view.isHidden = false
                        self.jobDescrp_height.constant = 80
                        self.jobdescription_lbl.text = jsonData[0]["description"].stringValue
                    } 
        
        if jsonData[0]["moving_item"].stringValue == "Furniture and General Items" || jsonData[0]["moving_item"].stringValue == "Moving Home" {
        if jsonData_inventory["Triple_Wardrobe"].stringValue != "0" && jsonData_inventory["Triple_Wardrobe"].stringValue != " " {
            print("print it %@",jsonData_inventory["Triple_Wardrobe"].stringValue)
            items.append(MenuItemStruct(title: "Triple Wardrobe", value: jsonData_inventory["Triple_Wardrobe"].stringValue))
        }
        if jsonData_inventory["Single_Wardrobe"].stringValue != "0" && jsonData_inventory["Single_Wardrobe"].stringValue != " "{
            print("print it %@",jsonData_inventory["Single_Wardrobe"].stringValue)
            items.append(MenuItemStruct(title: "Single Wardrobe", value: jsonData_inventory["Single_Wardrobe"].stringValue))
        }
      
        if jsonData_inventory["Single_Bed"].stringValue != "0" && jsonData_inventory["Single_Bed"].stringValue != " "{
                   print("print it %@",jsonData_inventory["Single_Bed"].stringValue)
                   items.append(MenuItemStruct(title: "Single Bed", value: jsonData_inventory["Single_Bed"].stringValue))
               }
        if jsonData_inventory["Television"].stringValue != "0" && jsonData_inventory["Television"].stringValue != " " {
                   print("print it %@",jsonData_inventory["Television"].stringValue)
                   items.append(MenuItemStruct(title: "Television", value: jsonData_inventory["Television"].stringValue))
               }
        if jsonData_inventory["Three_Seater_Sofa"].stringValue != "0" && jsonData_inventory["Three_Seater_Sofa"].stringValue != " " {
                   print("print it %@",jsonData_inventory["Three_Seater_Sofa"].stringValue)
                   items.append(MenuItemStruct(title: "Three Seater Sofa", value: jsonData_inventory["Three_Seater_Sofa"].stringValue))
               }
        if jsonData_inventory["Small_Box"].stringValue != "0" && jsonData_inventory["Small_Box"].stringValue != " " {
                   print("print it %@",jsonData_inventory["Small_Box"].stringValue)
                   items.append(MenuItemStruct(title: "Small Box", value: jsonData_inventory["Small_Box"].stringValue))
               }
        if jsonData_inventory["Dining_Chairs"].stringValue != "0" && jsonData_inventory["Dining_Chairs"].stringValue != " " {
                   print("print it %@",jsonData_inventory["Dining_Chairs"].stringValue)
                   items.append(MenuItemStruct(title: "Dining Chairs", value: jsonData_inventory["Dining_Chairs"].stringValue))
               }
        if jsonData_inventory["Fridge_And_Freezer"].stringValue != "0" && jsonData_inventory["Fridge_And_Freezer"].stringValue != " " {
                print("print it %@",jsonData_inventory["Fridge_And_Freezer"].stringValue)
                items.append(MenuItemStruct(title: "Fridge and Freezer", value: jsonData_inventory["Fridge_And_Freezer"].stringValue))
               }
        
        if jsonData_inventory["Bench"].stringValue != "0" && jsonData_inventory["Bench"].stringValue != " " {
                   print("print it %@",jsonData_inventory["Bench"].stringValue)
                   items.append(MenuItemStruct(title: "Bench", value: jsonData_inventory["Bench"].stringValue))
               }
        if jsonData_inventory["Bookcase"].stringValue != "0" && jsonData_inventory["Bookcase"].stringValue != " " {
                   print("print it %@",jsonData_inventory["Bookcase"].stringValue)
                   items.append(MenuItemStruct(title: "Bookcase", value: jsonData_inventory["Bookcase"].stringValue))
               }
        if jsonData_inventory["Queensize_Bed"].stringValue != "0" && jsonData_inventory["Queensize_Bed"].stringValue != " " {
                   print("print it %@",jsonData_inventory["Queensize_Bed"].stringValue)
                   items.append(MenuItemStruct(title: "Queen Size Bed", value: jsonData_inventory["Queensize_Bed"].stringValue))
               }
        if jsonData_inventory["Bags"].stringValue != "0" && jsonData_inventory["Bags"].stringValue != " " {
                   print("print it %@",jsonData_inventory["Bags"].stringValue)
                   items.append(MenuItemStruct(title: "Bags", value: jsonData_inventory["Bags"].stringValue))
               }
        if jsonData_inventory["Four_Seater_Table_And_Chairs"].stringValue != "0" && jsonData_inventory["Four_Seater_Table_And_Chairs"].stringValue != " " {
                   print("print it %@",jsonData_inventory["Four_Seater_Table_And_Chairs"].stringValue)
                   items.append(MenuItemStruct(title: "Four Seater Table and Chairs", value: jsonData_inventory["Four_Seater_Table_And_Chairs"].stringValue))
               }
        if jsonData_inventory["Office_Chairs"].stringValue != "0" && jsonData_inventory["Office_Chairs"].stringValue != " " {
                print("print it %@",jsonData_inventory["Office_Chairs"].stringValue)
                items.append(MenuItemStruct(title: "Office Chairs", value: jsonData_inventory["Office_Chairs"].stringValue))
               }
      
            if jsonData_inventory["2_Seater_Sofa"].stringValue != "0" && jsonData_inventory["2_Seater_Sofa"].stringValue != " " {
                  print("print it %@",jsonData_inventory["2_Seater_Sofa"].stringValue)
                  items.append(MenuItemStruct(title: "2_Seater_Sofa", value: jsonData_inventory["2_Seater_Sofa"].stringValue))
              }
              if jsonData_inventory["Two_Seater_Sofa"].stringValue != "0" && jsonData_inventory["Two_Seater_Sofa"].stringValue != " " {
                  print("print it %@",jsonData_inventory["Two_Seater_Sofa"].stringValue)
                  items.append(MenuItemStruct(title: "Two_Seater_Sofa", value: jsonData_inventory["Two_Seater_Sofa"].stringValue))
              }
            
              if jsonData_inventory["Double_Mattress"].stringValue != "0" && jsonData_inventory["Double_Mattress"].stringValue != " " {
                         print("print it %@",jsonData_inventory["Double_Mattress"].stringValue)
                         items.append(MenuItemStruct(title: "Double Mattress", value: jsonData_inventory["Double_Mattress"].stringValue))
                     }
              if jsonData_inventory["Suitcases"].stringValue != "0" && jsonData_inventory["Suitcases"].stringValue != " " {
                         print("print it %@",jsonData_inventory["Suitcases"].stringValue)
                         items.append(MenuItemStruct(title: "Suitcases", value: jsonData_inventory["Suitcases"].stringValue))
                     }
              if jsonData_inventory["Microwave"].stringValue != "0" && jsonData_inventory["Microwave"].stringValue != " " {
                         print("print it %@",jsonData_inventory["Microwave"].stringValue)
                         items.append(MenuItemStruct(title: "Microwave", value: jsonData_inventory["Microwave"].stringValue))
                     }
              if jsonData_inventory["Rug"].stringValue != "0" && jsonData_inventory["Rug"].stringValue != " " {
                         print("print it %@",jsonData_inventory["Rug"].stringValue)
                         items.append(MenuItemStruct(title: " Rug", value: jsonData_inventory["Rug"].stringValue))
                     }
              if jsonData_inventory["Four_Seater_Sofa"].stringValue != "0" && jsonData_inventory["Four_Seater_Sofa"].stringValue != " " {
                         print("print it %@",jsonData_inventory["Four_Seater_Sofa"].stringValue)
                         items.append(MenuItemStruct(title: "Four_Seater_Sofa", value: jsonData_inventory["Four_Seater_Sofa"].stringValue))
                     }
              if jsonData_inventory["Curtain_Hanger"].stringValue != "0" && jsonData_inventory["Curtain_Hanger"].stringValue != " " {
                      print("print it %@",jsonData_inventory["Curtain_Hanger"].stringValue)
                      items.append(MenuItemStruct(title: "Curtain_Hanger", value: jsonData_inventory["Curtain_Hanger"].stringValue))
                     }
              
             
              if jsonData_inventory["TV_Stand"].stringValue != "0" && jsonData_inventory["TV_Stand"].stringValue != " " {
                         print("print it %@",jsonData_inventory["TV_Stand"].stringValue)
                         items.append(MenuItemStruct(title: "TV_Stand", value: jsonData_inventory["TV_Stand"].stringValue))
                     }
              if jsonData_inventory["Dishwasher"].stringValue != "0" && jsonData_inventory["Dishwasher"].stringValue != " "{
                         print("print it %@",jsonData_inventory["Dishwasher"].stringValue)
                         items.append(MenuItemStruct(title: "Dishwasher", value: jsonData_inventory["Dishwasher"].stringValue))
                     }
              if jsonData_inventory["Mirror"].stringValue != "0" && jsonData_inventory["Mirror"].stringValue != " " {
                         print("print it %@",jsonData_inventory["Mirror"].stringValue)
                         items.append(MenuItemStruct(title: "Mirror", value: jsonData_inventory["Mirror"].stringValue))
                     }
              if jsonData_inventory["Bathroom_Cabinet"].stringValue != "0" && jsonData_inventory["Bathroom_Cabinet"].stringValue != " " {
                         print("print it %@",jsonData_inventory["Bathroom_Cabinet"].stringValue)
                         items.append(MenuItemStruct(title: "Bathroom_Cabinet ", value: jsonData_inventory["Bathroom_Cabinet"].stringValue))
                     }
              if jsonData_inventory["Washing_Machine"].stringValue != "0" && jsonData_inventory["Washing_Machine"].stringValue != " " {
                      print("print it %@",jsonData_inventory["Washing_Machine"].stringValue)
                      items.append(MenuItemStruct(title: "Washing_Machine ", value: jsonData_inventory["Washing_Machine"].stringValue))
                     }
        
            if jsonData_inventory["Office_Table"].stringValue != "0" && jsonData_inventory["Office_Table"].stringValue != " "  {
                           print("print it %@",jsonData_inventory["Office_Table"].stringValue)
                           items.append(MenuItemStruct(title: "Office_Table", value: jsonData_inventory["Office_Table"].stringValue))
                       }
            if jsonData_inventory["Dryer"].stringValue != "0" && jsonData_inventory["Dryer"].stringValue != " "{
                           print("print it %@",jsonData_inventory["Dryer"].stringValue)
                           items.append(MenuItemStruct(title: "Dryer", value: jsonData_inventory["Dryer"].stringValue))
                       }
                     
            if jsonData_inventory["Kitchen_Chairs"].stringValue != "0" && jsonData_inventory["Kitchen_Chairs"].stringValue != " " {
                                  print("print it %@",jsonData_inventory["Kitchen_Chairs"].stringValue)
                                  items.append(MenuItemStruct(title: "Kitchen_Chairs", value: jsonData_inventory["Kitchen_Chairs"].stringValue))
                              }
                       if jsonData_inventory["Garden_Table"].stringValue != "0" && jsonData_inventory["Garden_Table"].stringValue != " " {
                                  print("print it %@",jsonData_inventory["Garden_Table"].stringValue)
                                  items.append(MenuItemStruct(title: "Garden_Table", value: jsonData_inventory["Garden_Table"].stringValue))
                              }
                       
                       if jsonData_inventory["Kitchen_Table"].stringValue != "0" && jsonData_inventory["Kitchen_Table"].stringValue != " " {
                                  print("print it %@",jsonData_inventory["Kitchen_Table"].stringValue)
                                  items.append(MenuItemStruct(title: " Kitchen_Table", value: jsonData_inventory["Kitchen_Table"].stringValue))
                              }
                       if jsonData_inventory["Coffee_Table"].stringValue != "0" && jsonData_inventory["Coffee_Table"].stringValue != " " {
                                  print("print it %@",jsonData_inventory["Coffee_Table"].stringValue)
                                  items.append(MenuItemStruct(title: "Coffee_Table", value: jsonData_inventory["Coffee_Table"].stringValue))
                              }
                       if jsonData_inventory["Freezer"].stringValue != "0" && jsonData_inventory["Freezer"].stringValue != " " {
                               print("print it %@",jsonData_inventory["Freezer"].stringValue)
                               items.append(MenuItemStruct(title: "Freezer", value: jsonData_inventory["Freezer"].stringValue))
                              }
                       
                       if jsonData_inventory["Bedside_Table"].stringValue != "0" && jsonData_inventory["Bedside_Table"].stringValue != " " {
                                  print("print it %@",jsonData_inventory["Bedside_Table"].stringValue)
                                  items.append(MenuItemStruct(title: "Bedside_Table", value: jsonData_inventory["Bedside_Table"].stringValue))
                              }
                       if jsonData_inventory["Cooker"].stringValue != "0" && jsonData_inventory["Cooker"].stringValue != " " {
                                  print("print it %@",jsonData_inventory["Cooker"].stringValue)
                                  items.append(MenuItemStruct(title: "Cooker", value: jsonData_inventory["Cooker"].stringValue))
                              }
                       if jsonData_inventory["Display_Cabinet"].stringValue != "0" && jsonData_inventory["Display_Cabinet"].stringValue != " " {
                                  print("print it %@",jsonData_inventory["Display_Cabinet"].stringValue)
                                  items.append(MenuItemStruct(title: "Display_Cabinet", value: jsonData_inventory["Display_Cabinet"].stringValue))
                              }
                       if jsonData_inventory["Chest_of_Drawers"].stringValue != "0" && jsonData_inventory["Chest_of_Drawers"].stringValue != " " {
                                  print("print it %@",jsonData_inventory["Chest_of_Drawers"].stringValue)
                                  items.append(MenuItemStruct(title: "Chest_of_Drawers", value: jsonData_inventory["Chest_of_Drawers"].stringValue))
                              }
                       if jsonData_inventory["Kingsize_Bed"].stringValue != "0" && jsonData_inventory["Kingsize_Bed"].stringValue != " "  {
                                  print("print it %@",jsonData_inventory["Kingsize_Bed"].stringValue)
                                  items.append(MenuItemStruct(title: "Kingsize_Bed ", value: jsonData_inventory["Kingsize_Bed"].stringValue))
                              }
                       if jsonData_inventory["Six_Seater_Table_And_Chairs"].stringValue != "0" && jsonData_inventory["Six_Seater_Table_And_Chairs"].stringValue != " " {
                               print("print it %@",jsonData_inventory["Six_Seater_Table_And_Chairs"].stringValue)
                               items.append(MenuItemStruct(title: "Six_Seater_Table_And_Chairs ", value: jsonData_inventory["Six_Seater_Table_And_Chairs"].stringValue))
                              }
        
        if jsonData_inventory["Dressing_Table"].stringValue != "0" && jsonData_inventory["Dressing_Table"].stringValue != " " {
                       print("print it %@",jsonData_inventory["Dressing_Table"].stringValue)
                       items.append(MenuItemStruct(title: "Dressing_Table", value: jsonData_inventory["Dressing_Table"].stringValue))
                   }
                   if jsonData_inventory["Shelf"].stringValue != "0" && jsonData_inventory["Shelf"].stringValue != " " {
                       print("print it %@",jsonData_inventory["Shelf"].stringValue)
                       items.append(MenuItemStruct(title: "Shelf", value: jsonData_inventory["Shelf"].stringValue))
                   }
                 
                   if jsonData_inventory["3_Seater_Sofa"].stringValue != "0" && jsonData_inventory["3_Seater_Sofa"].stringValue != " " {
                              print("print it %@",jsonData_inventory["3_Seater_Sofa"].stringValue)
                              items.append(MenuItemStruct(title: "3_Seater_Sofa", value: jsonData_inventory["3_Seater_Sofa"].stringValue))
                          }
                   if jsonData_inventory["Double_Wardrobe"].stringValue != "0" && jsonData_inventory["Double_Wardrobe"].stringValue != " " {
                              print("print it %@",jsonData_inventory["Double_Wardrobe"].stringValue)
                              items.append(MenuItemStruct(title: "Double_Wardrobe", value: jsonData_inventory["Double_Wardrobe"].stringValue))
                          }
                    if jsonData_inventory["Double_Bed"].stringValue != "0" && jsonData_inventory["Double_Bed"].stringValue != " " {
                              print("print it %@",jsonData_inventory["Double_Bed"].stringValue)
                              items.append(MenuItemStruct(title: "Double_Bed", value: jsonData_inventory["Double_Bed"].stringValue))
                          }
                   if jsonData_inventory["Medium_Box"].stringValue != "0" && jsonData_inventory["Medium_Box"].stringValue != " " {
                              print("print it %@",jsonData_inventory["Medium_Box"].stringValue)
                              items.append(MenuItemStruct(title: " Medium_Box", value: jsonData_inventory["Medium_Box"].stringValue))
                          }
                   if jsonData_inventory["Garden_Chairs"].stringValue != "0" && jsonData_inventory["Garden_Chairs"].stringValue != " " {
                              print("print it %@",jsonData_inventory["Garden_Chairs"].stringValue)
                              items.append(MenuItemStruct(title: "Garden_Chairs", value: jsonData_inventory["Garden_Chairs"].stringValue))
                          }
                  
                   if jsonData_inventory["Fridge"].stringValue != "0" && jsonData_inventory["Fridge"].stringValue != " " {
                              print("print it %@",jsonData_inventory["Fridge"].stringValue)
                              items.append(MenuItemStruct(title: "Fridge", value: jsonData_inventory["Fridge"].stringValue))
                          }
                   if jsonData_inventory["Large_Box"].stringValue != "0" && jsonData_inventory["Large_Box"].stringValue != " " {
                              print("print it %@",jsonData_inventory["Large_Box"].stringValue)
                              items.append(MenuItemStruct(title: "Large_Box", value: jsonData_inventory["Large_Box"].stringValue))
                          }
                   if jsonData_inventory["Arm_Chair"].stringValue != "0" && jsonData_inventory["Arm_Chair"].stringValue != " " {
                              print("print it %@",jsonData_inventory["Arm_Chair"].stringValue)
                              items.append(MenuItemStruct(title: "Arm_Chair", value: jsonData_inventory["Arm_Chair"].stringValue))
            }
        }else{
            print("\n this is not furniture and home moving cat\n\n")
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
                 cell.no_of_helpers_lbl.text = no_of_hepler + " Helper"
             }else{
                 cell.no_of_helpers_lbl.text = no_of_hepler + " Helpers"
             }
             Vehicle_no = jsonData[0]["no_of_vehicle"].stringValue
             d_item = jsonData[0]["d_items"].stringValue
             
             
             let jobID = "LOADX"+String(year)+"J"+del_id!
             cell.jobId_lbl.text = jobID
             
//             if jsonData_inventory.stringValue == "" {
//
//                 cell.inventory_view.isHidden = true
//                 cell.inventory_view_height.constant = 0
//
//             }else{
//                 cell.inventory_view.isHidden = false
//                 cell.inventory_view_height.constant = 120
//             }
             
             if cell.category_lbl.text == "Furniture and General Items" || cell.category_lbl.text == "One Item" || cell.category_lbl.text == "Two Items" || cell.category_lbl.text == "Three or More Items" || cell.category_lbl.text == "Piano"  || cell.category_lbl.text == "Business & Industrial Goods" ||  cell.category_lbl.text == "Machine and Vehicle Parts" || cell.category_lbl.text == "Waste Removal" || cell.category_lbl.text ==  "Office Move" || cell.category_lbl.text == "Other"{
                 
                 cell.noOfBeds_view.isHidden = true
                 cell.noOfBeds_view.isHidden = true
                 cell.noOfVehicle_view.isHidden = true
                 cell.vehicleType_view.isHidden = false
                 cell.vehicleType_height.constant = 44
                 cell.no_ofVehicle_height.constant = 0
                 cell.noOfBed_height.constant = 0
                 cell.jobDetialView_height.constant = 260
                 
                 cell.movingTo_view.isHidden = true
                 cell.movingTo_height.constant = 0
                 cell.MovingFrom_view.isHidden = true
                 cell.movingFrom_height.constant = 0
                 
                 if d_item == "One Item" || cell.category_lbl.text == "One Item" {
                     cell.noOfItems_view.isHidden = false
                     cell.noOfItem_height.constant = 44
                     cell.no_of_items_lbl.text = d_item
                     cell.jobDetialView_height.constant = 404
                     
                 }else if d_item == "Two Items" || cell.category_lbl.text == "Two Items" {
                     cell.noOfItems_view.isHidden = false
                     cell.noOfItem_height.constant = 44
                     cell.no_of_items_lbl.text = d_item
                     cell.jobDetialView_height.constant = 404
                 }else{
                     cell.noOfItems_view.isHidden = true
                     cell.noOfItem_height.constant = 0
                     cell.jobDetialView_height.constant = 360
                 }
             } else {
             
             if cell.category_lbl.text == "Cars & Vehicles" || cell.category_lbl.text == "Cars and Vehicles" || cell.category_lbl.text == "Bikes & Motorcycles"  {
                 cell.movingTo_view.isHidden = true
                 cell.MovingFrom_view.isHidden = true
                 cell.movingTo_height.constant = 0
                 cell.movingFrom_height.constant = 0
                 cell.noOfBeds_view.isHidden = true
                 cell.noOfBed_height.constant = 0
                 cell.noOfVehicle_view.isHidden = true
                 cell.no_ofVehicle_height.constant = 0
                 cell.noOfItems_view.isHidden = true
                 cell.noOfItem_height.constant = 0
                 cell.jobDetialView_height.constant = 316
                 
                 cell.vehicleType_view.isHidden = true
                 cell.vehicleType_height.constant = 0
                 
             }
             
             if cell.category_lbl.text == "Moving Home" {
                 cell.no_of_helpers_lbl.text = "2"+" Persons"
                 cell.noOfBeds_view.isHidden = false
                 cell.noOfBed_height.constant = 44
                 
//                 cell.jobDetialView_height.constant = 400
                 if Vehicle_no == "1"{
                     cell.No_of_vehicle_lbl.text = Vehicle_no! + " Vehicle"
                 }else{
                     cell.No_of_vehicle_lbl.text = Vehicle_no! + " Vehicles"
                 }
             }
             
             return cell
            }
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
            cell.no_of_helpers_lbl.text = no_of_hepler + " Helper"
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
        
        if cell.category_lbl.text == "Furniture and General Items" || cell.category_lbl.text == "One Item" || cell.category_lbl.text == "Two Items" || cell.category_lbl.text == "Three or More Items" || cell.category_lbl.text == "Piano"  || cell.category_lbl.text == "Business & Industrial Goods" ||  cell.category_lbl.text == "Machine and Vehicle Parts" || cell.category_lbl.text == "Waste Removal" || cell.category_lbl.text ==  "Office Move" || cell.category_lbl.text == "Other"{
            
            cell.noOfBeds_view.isHidden = true
            cell.noOfBeds_view.isHidden = true
            cell.noOfVehicle_view.isHidden = true
            cell.vehicleType_view.isHidden = false
            cell.vehicleType_height.constant = 44
            cell.no_ofVehicle_height.constant = 0
            cell.noOfBed_height.constant = 0
            cell.jobDetialView_height.constant = 260
            
            cell.movingTo_view.isHidden = true
            cell.movingTo_height.constant = 0
            cell.MovingFrom_view.isHidden = true
            cell.movingFrom_height.constant = 0
            
            if d_item == "One Item" || cell.category_lbl.text == "One Item" {
                cell.noOfItems_view.isHidden = false
                cell.noOfItem_height.constant = 44
                cell.no_of_items_lbl.text = d_item
                cell.jobDetialView_height.constant = 404
                
            }else if d_item == "Two Items" || cell.category_lbl.text == "Two Items" {
                cell.noOfItems_view.isHidden = false
                cell.noOfItem_height.constant = 44
                cell.no_of_items_lbl.text = d_item
                cell.jobDetialView_height.constant = 404
            }else{
                cell.noOfItems_view.isHidden = true
                cell.noOfItem_height.constant = 0
                cell.jobDetialView_height.constant = 360
            }
        }
        
        if cell.category_lbl.text == "Cars & Vehicles" || cell.category_lbl.text == "Cars and Vehicles" || cell.category_lbl.text == "Bikes & Motorcycles"  {
            cell.movingTo_view.isHidden = true
            cell.MovingFrom_view.isHidden = true
            cell.movingTo_height.constant = 0
            cell.movingFrom_height.constant = 0
            cell.noOfBeds_view.isHidden = true
            cell.noOfBed_height.constant = 0
            cell.noOfVehicle_view.isHidden = true
            cell.no_ofVehicle_height.constant = 0
            cell.noOfItems_view.isHidden = true
            cell.noOfItem_height.constant = 0
            cell.jobDetialView_height.constant = 316
            
            cell.vehicleType_view.isHidden = true
            cell.vehicleType_height.constant = 0
            
        }
        
        if cell.category_lbl.text == "Moving Home" {
            cell.no_of_helpers_lbl.text = "2"+" Persons"
            cell.noOfBeds_view.isHidden = false
            cell.noOfBed_height.constant = 44
            
            cell.jobDetialView_height.constant = 400
            if Vehicle_no == "1"{
                cell.No_of_vehicle_lbl.text = Vehicle_no! + " Vehicle"
            }else{
                cell.No_of_vehicle_lbl.text = Vehicle_no! + " Vehicles"
            }
        }
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
