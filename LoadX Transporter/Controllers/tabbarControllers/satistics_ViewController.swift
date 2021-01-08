//
//  satistics_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 06/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IBAnimatable

//@available(iOS 13.0, *)
class satistics_ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var totalCompleted_view: UIView!
    @IBOutlet weak var totalCompletedRoutesView: UIView!
    @IBOutlet weak var routesEarning: UILabel!
    @IBOutlet weak var totalPrice_view: UIView!
    @IBOutlet weak var totalEarning: UILabel!
    @IBOutlet weak var totalOutstanding: UILabel!
    @IBOutlet weak var totalCompletedJob_lbl: UILabel!
    @IBOutlet weak var toDate_tf: AnimatableTextField!
    @IBOutlet weak var fromDate_tf: AnimatableTextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    let picker = UIDatePicker()
    var businessJobs : Bool?
    lazy var completedJobsModel = [CompletedJobsModel]()
    lazy var completedJobsModelBusiness = [CompletedJobsModelBusiness]()
    var roundedPrice: Double = 0.0
    var resultRemaining = 0.0
    private var rowID : Int?
    var switchCheck: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDate_tf.delegate = self
        fromDate_tf.delegate = self
        createDatePicker()
        stackView.isHidden = true
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        if let totalEarningAmount = UserDefaults.standard.string(forKey: "total_earning") {
        totalEarning.text = "£ \(totalEarningAmount)"
        }
        if let totalOutstandingAmount = UserDefaults.standard.string(forKey: "totalOutstanding") {
            totalOutstanding.text = "£ \(totalOutstandingAmount)"
        }
        if let routeEarning = UserDefaults.standard.string(forKey: "totalRouteCompleted") {
            self.routesEarning.text = routeEarning
        }
        if let isLoadxDrive = UserDefaults.standard.string(forKey: "isLoadxDriver") {
            if isLoadxDrive == "0" {
                self.totalCompletedRoutesView.isHidden = true
            } else {
                self.totalCompletedRoutesView.isHidden = false
            }
        }
        
        guard let totalCompletedJob = UserDefaults.standard.string(forKey: "complete_job") else { return }
               totalCompletedJob_lbl.text =  totalCompletedJob
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "CompletedJobsCell", bundle: nil) , forCellReuseIdentifier: "completedJobs")
    }
    override func viewWillAppear(_ animated: Bool) {
        totalCompleted_view.layer.cornerRadius = 5
        // shadow
        totalCompleted_view.layer.shadowColor = UIColor.black.cgColor
        totalCompleted_view.layer.shadowOffset = CGSize(width: 2, height: 2)
        totalCompleted_view.layer.shadowOpacity = 0.4
        totalCompleted_view.layer.shadowRadius = 4.0
        
        totalPrice_view.layer.cornerRadius = 5
        // shadow
        totalPrice_view.layer.shadowColor = UIColor.black.cgColor
        totalPrice_view.layer.shadowOffset = CGSize(width: 2, height: 2)
        totalPrice_view.layer.shadowOpacity = 0.4
        totalPrice_view.layer.shadowRadius = 4.0
        
        totalCompletedRoutesView.layer.cornerRadius = 5
        // shadow
        totalCompletedRoutesView.layer.shadowColor = UIColor.black.cgColor
        totalCompletedRoutesView.layer.shadowOffset = CGSize(width: 2, height: 2)
        totalCompletedRoutesView.layer.shadowOpacity = 0.4
        totalCompletedRoutesView.layer.shadowRadius = 4.0
    }
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
       
    //MARK: - Function for UIDatepicker
    func createDatePicker() {
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
           let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
           toolbar.setItems([done], animated: false)
          
        toDate_tf.inputAccessoryView = toolbar
        toDate_tf.inputView = picker
        picker.datePickerMode = .date
        
        fromDate_tf.inputAccessoryView = toolbar
        fromDate_tf.inputView = picker
        picker.datePickerMode = .date
       
    }
       
      @objc func donePressed() {
       let formatter = DateFormatter()
       formatter.dateFormat = "dd-MM-yyyy"
       let dateString = formatter.string(from: picker.date)
       if toDate_tf.isFirstResponder {
       toDate_tf.text = "\(dateString)"
       }
       if fromDate_tf.isFirstResponder{
       fromDate_tf.text = "\(dateString)"
       }
       self.view.endEditing(true)
    }
    @IBAction func search_action(_ sender: Any) {
        if  fromDate_tf.text != ""  &&  toDate_tf.text != "" {
            searchCompletedJob()
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please Enter Dates", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
  func searchCompletedJob() {
          SVProgressHUD.show(withStatus: "Getting details...")
                     let searchCompletedJob = main_URL+"api/searchtransporterCompletedJobs"
                  let parameters : Parameters = ["user_id" : user_id ?? "", "start_date": fromDate_tf.text! , "end_date" : toDate_tf.text! ]
                     if Connectivity.isConnectedToInternet() {
                         Alamofire.request(searchCompletedJob, method : .post, parameters : parameters).responseJSON {
                             response in
                             if response.result.isSuccess {
                                 SVProgressHUD.dismiss()
                              
                                 let jsonData : JSON = JSON(response.result.value!)
                                 print("Search Transporter Completed Job that is: \n \(jsonData)")
                              let result = jsonData[0]["result"].stringValue
//                              let message1 = jsonData[0]["message"].stringValue
                              let totaljobs = jsonData[0]["totaljobs"].stringValue
                                print("this is total complete job:\n\(totaljobs)")
                              let total_income = jsonData[0]["total_income"].doubleValue
                                let routeIncome = jsonData[0]["route_payment"].doubleValue
                                let totalIncome = total_income+routeIncome
                               print("this is total income job:\n\(total_income)")
                              
                                
                                
                                if result == "0" {
                                    self.totalEarning.text = "£0.00"
                                    self.totalCompletedJob_lbl.text = "0"
                                   self.completedJobsModel.removeAll()
                                    
//                                  self.tableView.reloadData()
                                 
                                  self.stackView.isHidden = false
                                 self.tableView.isHidden = false
//                                  self.tableView.backgroundView = nil
//                                  SVProgressHUD.showError(withStatus: message1)
                               //   self.total_compeleted_job.text = "0"
                             //     self.total_income_count.text = "0"
                              } else {
                                    if total_income == 0 {
                                        self.totalEarning.text = "£0.00"
                                    } else {
                                    self.totalEarning.text = "£" + "\(totalIncome)"
                                    }
                                    self.totalCompletedJob_lbl.text =  totaljobs
                                    self.stackView.isHidden = true
//                                  self.getCompletedJobs(url: "api/transporterCompletedJobs")
                                    self.tableView.isHidden = false
//                                    self.tableView.backgroundColor = UIColor.init(hexString: "EAEAEA")
                             //     self.liveView.isHidden = false
//                                  self.search_filter_backbtn.isHidden = false
//                                  self.searchResult_view.isHidden = false
//
//                                  self.total_compeleted_job.text = totaljobs
//                                  self.total_income_count.text = total_income
                                 
                              }
                              
                          }else {
                              SVProgressHUD.dismiss()
                                let alert = UIAlertController(title: "Alert", message: response.error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                              alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                              self.present(alert, animated: true, completion: nil)
                              print("Error \(response.result.error!)")
                          }
                      }                                                                 
                      }else {
                          SVProgressHUD.dismiss()
                          let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                          alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                          self.present(alert, animated: true, completion: nil)
                         
                      }

      }

        func getCompletedJobs(url: String) {
            SVProgressHUD.show(withStatus: "Getting details...")
            if user_id != nil {
                let activeJobs_URL = main_URL+url
                let parameters : Parameters = ["user_id" : user_id!]
                if Connectivity.isConnectedToInternet() {
                    Alamofire.request(activeJobs_URL, method : .post, parameters : parameters).responseJSON {
                        response in
                        let response1 = response.result.value
                        
                        print("this is completed job api response.../n \(String(describing: response1))")
                        if response.result.isSuccess {
                            SVProgressHUD.dismiss()
                            
                            let jsonData : JSON = JSON(response.result.value!)
                            print("completed Jobs jsonData is \(jsonData)")
                            let result = jsonData[0]["result"].stringValue
                            self.completedJobsModel.removeAll()
                            self.completedJobsModelBusiness.removeAll()
                           
                            if result == "0" {
//                                self.tableView.backgroundView = nil
                                self.stackView.isHidden = false
                                self.tableView.reloadData()
                            } else {
                            
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    if url == "api/transporterCompletedJobsBusiness" {
                                        self.completedJobsModelBusiness = try JSONDecoder().decode([CompletedJobsModelBusiness].self, from: data ?? Data())
                                        SVProgressHUD.dismiss()
                                        
                                        DispatchQueue.main.async {
    //                                        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
                                            self.tableView.isHidden = false
                                            self.stackView.isHidden = true
                                            self.tableView.reloadData()
                                        }
                                    } else {
                                        self.completedJobsModel = try JSONDecoder().decode([CompletedJobsModel].self, from: data ?? Data())
                                        SVProgressHUD.dismiss()
                                        
                                        DispatchQueue.main.async {
//                                            self.tableView.backgroundcolor = UIColor(hexString: "")
                                            self.tableView.isHidden = false
                                            self.stackView.isHidden = true
                                            self.tableView.reloadData()
                                        }
                                    }
                                } catch {
                                    print(error)
                                    let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            }
                        } else {
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            print("Error \(response.result.error!)")
                        }
                    }
                } else {
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "Internet connection is missing", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if businessJobs == true {
          return completedJobsModelBusiness.count
          } else {
          return completedJobsModel.count
          }
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "completedJobs") as! CompletedJobsCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundView = nil
            cell.backgroundColor = nil
          
            cell.cellBackground_view.layer.cornerRadius = 10
            cell.completion_dateView.clipsToBounds = true
            cell.completion_dateView.layer.cornerRadius = 10
            cell.completion_dateView.layer.maskedCorners = [.layerMinXMaxYCorner]
            
            cell.delete_btn.layer.cornerRadius = 10
            cell.delete_btn.clipsToBounds = true
            cell.delete_btn.layer.maskedCorners = [ .layerMaxXMaxYCorner  ]
           
            if businessJobs == true {
            let completedJobsRow = completedJobsModelBusiness[indexPath.row]
//                let payment_type1 = completedJobsRow.payment_type
//                let due_amount_status = completedJobsRow.due_amount_status
                        
               /*  if payment_type1 == "full" {
                    if due_amount_status == "Pending" {
                        cell.receivedAmount.text = "Pending Amount"
                        cell.receivedAmount.textColor = UIColor(red: 253/255, green: 179/255, blue: 62/255, alpha: 1)
                    } else {
                        cell.receivedAmount.text = "Received Amount"
                        cell.receivedAmount.textColor = UIColor(red: 5/255, green: 130/255, blue: 6/255, alpha: 1)
                    }
                    }else {
                        cell.receivedAmount.text = "Received Amount"
                        cell.receivedAmount.textColor = UIColor(red: 5/255, green: 130/255, blue: 6/255, alpha: 1)
                    }
      */
                let movingItem = completedJobsRow.moving_item
                cell.moving_item.text = movingItem.capitalized
                cell.pick_up.text = completedJobsRow.pu_house_no ?? "" + " " + completedJobsRow.pick_up
                cell.drop_off.text = completedJobsRow.do_house_no ?? "" + " " + completedJobsRow.drop_off
                let stringDate = completedJobsRow.date
                let convertedDate = self.convertDateFormatter(stringDate)
                cell.date.text = convertedDate
//                let contactPerson = completedJobsRow.contact_person
    //            cell.driver_name.setTitle(contactPerson.capitalized, for: .normal)
                
                let currentBid = completedJobsRow.current_bid
                let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
                let doubleValue = Double(x)
                let resultInitialPrice = Double(currentBid)! * Double(doubleValue!/100)
    //            let resultInitialPrice = Double(currentBid)! * Double(0.25)
                self.roundedPrice = Double(resultInitialPrice).rounded(toPlaces: 2)
                
    //            let resultRemaining1 = Double(currentBid)! - self.roundedPrice
                cell.price.text = "£ "+"\(getDoubleValue(currentBid: Double(currentBid) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
           
                let payment_type = completedJobsRow.is_company_job
                  if payment_type != "0" {
                    if switchCheck == true {
    //                    cell.payment_type_icon.image = UIImage(named: "bank_dark")
                        cell.payment_type_lbl.text = "Account Job"
                    }else{
    //                cell.payment_type_icon.image = UIImage(named: "bank")
                    cell.payment_type_lbl.text = "Account Job"
                  }
                  }else{
                    if switchCheck == true {
    //                      cell.payment_type_icon.image = UIImage(named: "cash_dark")
                          cell.payment_type_lbl.text = "Cash Job"
                      }else{
    //                  cell.payment_type_icon.image = UIImage(named: "cash")
                      cell.payment_type_lbl.text = "Cash Job"
                    }
                }
              // self.priceValue = "\(resultRemaining)"
            } else {
                
            let completedJobsRow = completedJobsModel[indexPath.row]
                let payment_type = completedJobsRow.payment_type
                if payment_type != "" {
                    if switchCheck == true {
    //                    cell.payment_type_icon.image = UIImage(named: "bank_dark")
                        cell.payment_type_lbl.text = "Account Job"
                    }else{
    //                    cell.payment_type_icon.image = UIImage(named:"bank")
                        cell.payment_type_lbl.text = "Account Job"
                    }
                    }else{
                        if switchCheck == true {
    //                        cell.payment_type_icon.image = UIImage(named: "cash_dark")
                            cell.payment_type_lbl.text = "Cash Job"
                        }else{
    //                        cell.payment_type_icon.image = UIImage(named: "cash")
                            cell.payment_type_lbl.text = "Cash Job"
                        }
                }
                let is_companyJob = completedJobsRow.is_company_job
                
                if is_companyJob == "1" {
                    cell.businessPatti.isHidden = false
                    cell.widthBusiness.constant = 82
                     if switchCheck == true {
    //                    cell.payment_type_icon.image = UIImage(named: "bank_dark")
                        cell.payment_type_lbl.text = "Account Job"
                    }else{
    //                    cell.payment_type_icon.image = UIImage(named:"bank")
                        cell.payment_type_lbl.text = "Account Job"
                    }
                } else {
                    cell.businessPatti.isHidden = true
                    cell.widthBusiness.constant = 0
              //      cell.payment_type_icon.image = UIImage(named: "cash")
              //      cell.payment_type_lbl.text = "Cash Job"
                }
                
    //            let driverGetPayment = completedJobsRow.driver_get_job_payment
//                let due_amount_status = completedJobsRow.due_amount_status
                
              /*  if payment_type == "full" {
                    if due_amount_status == "Pending" {
                    cell.receivedAmount.text = "Pending Amount"
                    cell.receivedAmount.textColor = UIColor(red: 253/255, green: 179/255, blue: 62/255, alpha: 1)
                } else {
                    cell.receivedAmount.text = "Received Amount"
                    cell.receivedAmount.textColor = UIColor(red: 5/255, green: 130/255, blue: 6/255, alpha: 1)
                }
                }else {
                    cell.receivedAmount.text = "Received Amount"
                    cell.receivedAmount.textColor = UIColor(red: 5/255, green: 130/255, blue: 6/255, alpha: 1)
                }*/
                
                let payment_type2 = completedJobsRow.payment_type
                    if payment_type2 == "full"  {
                     if switchCheck == true {
    //                    cell.payment_type_icon.image = UIImage(named: "bank_dark")
                        cell.payment_type_lbl.text = "Account Job"
                    }else{
    //                    cell.payment_type_icon.image = UIImage(named:"bank")
                        cell.payment_type_lbl.text = "Account Job"
                    }
                }else{
                    if switchCheck == true {
    //                    cell.payment_type_icon.image = UIImage(named: "cash_dark")
                        cell.payment_type_lbl.text = "Cash Job"
                    }else{
    //                   cell.payment_type_icon.image = UIImage(named: "cash")
                        cell.payment_type_lbl.text = "Cash Job"
                }
            }
               
                let movingItem = completedJobsRow.moving_item
                cell.moving_item.text = movingItem.capitalized
                cell.pick_up.text = "\(completedJobsRow.pu_house_no ?? "") \(completedJobsRow.pick_up)"
                cell.drop_off.text = "\(completedJobsRow.do_house_no ?? "") \(completedJobsRow.drop_off)"
               
                let stringDate = completedJobsRow.date
                let convertedDate = self.convertDateFormatter(stringDate)
                cell.date.text = convertedDate
                
//                let contactPerson = completedJobsRow.contact_person
    //            cell.driver_name.setTitle(contactPerson.capitalized, for: .normal)
                
                let currentBid = completedJobsRow.current_bid
                let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
                let doubleValue = Double(x)
                let resultInitialPrice = Double(currentBid)! * Double(doubleValue!/100)
    //            let resultInitialPrice = Double(currentBid)! * Double(0.25)
                self.roundedPrice = Double(resultInitialPrice).rounded(toPlaces: 2)
                
                resultRemaining = Double(currentBid)! - self.roundedPrice
                
               // self.priceValue = "\(resultRemaining)"
                cell.price.text = "£ "+"\(getDoubleValue(currentBid: Double(currentBid) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
            }
            
            cell.deleteRow = { (selectedCell) in
                let selectedIndex = self.tableView.indexPath(for: selectedCell)
                self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
                
                if self.businessJobs == true {
                    del_id = self.completedJobsModelBusiness[indexPath.row].del_id
                        self.rowID = indexPath.row
                        //self.deleteJob()
                    } else {
                        del_id = self.completedJobsModel[indexPath.row].del_id
                        self.rowID = indexPath.row
                       // self.deleteJob()
                        }
                    
                
                
    //            let refreshAlert = UIAlertController(title: "Delete!", message: "Do you want to delete this job?", preferredStyle: UIAlertController.Style.alert)
    //
    //            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
    //
    //
    //            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
    //                print("Handle Cancel Logic here")
    //            }))
    //
    //            self.present(refreshAlert, animated: true, completion: nil)
                
//                UIView.animate(withDuration: 0.3, animations: {
//    //                self.delete_popview.layer.borderColor = UIColor.gray.cgColor
//    //                self.delete_popview.layer.borderWidth = 1
//                    self.delete_popview.layer.cornerRadius = 18
//                    self.tableView.alpha = 0.5
//
//                    self.logo_popupView.clipsToBounds = true
//                    self.logo_popupView.layer.cornerRadius = 18
//                    self.logo_popupView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
//
//                    self.view.addSubview(self.delete_popview)
//                    self.delete_popview.center = self.view.center
//                })
            
        }
            
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
            cell.detailJobRow = {[weak self] (selectedCell) in
                guard let self = self else { return }
                let selectedIndex = self.tableView.indexPath(for: selectedCell)
                self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
                if self.businessJobs == true {
                    del_id = self.completedJobsModelBusiness[indexPath.row].del_id
                    jobs_completed = true
    //                self.performSegue(withIdentifier: "detail", sender: self)

                    if #available(iOS 13.0, *) {
                        let vc = storyboard.instantiateViewController(identifier: "JobDetial_ViewController") as JobDetial_ViewController
                        vc.bookedJobPrice = cell.price.text
                        vc.showHouseNumber = true
                        vc.pickupAdd = cell.pick_up.text
                        vc.dropoffAdd = cell.drop_off.text
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                } else {
                del_id = self.completedJobsModel[indexPath.row].del_id
                jobs_completed = true
               
                    if #available(iOS 13.0, *) {
                        let vc = storyboard.instantiateViewController(identifier: "JobDetial_ViewController") as JobDetial_ViewController
                        vc.bookedJobPrice = cell.price.text
                            vc.showHouseNumber = true
                            vc.pickupAdd = cell.pick_up.text
                            vc.dropoffAdd = cell.drop_off.text
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
              
            }
            }
            
            cell.transporterProfileRow = { (selectedCell) in
                let selectedIndex = self.tableView.indexPath(for: selectedCell)
                self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
    //            transporter_id = self.completedJobsModel[indexPath.row].user_id
    //            self.performSegue(withIdentifier: "profile", sender: self)
            }
            
            return cell
            
        }
    

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if businessJobs == true {
                del_id = self.completedJobsModelBusiness[indexPath.row].del_id
                jobs_completed = true
    //            self.performSegue(withIdentifier: "detail", sender: self)
    //            jobPrice = self.completedJobsModelBusiness[indexPath.row]
               
                let vc = storyboard.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            
            } else {
                jobs_completed = true
              
            del_id = self.completedJobsModel[indexPath.row].del_id
    //        self.performSegue(withIdentifier: "detail", sender: self)

            let vc = storyboard.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
            self.navigationController?.pushViewController(vc, animated: true)
                  
            }
    }
    
    func deleteJob() {
        SVProgressHUD.show(withStatus: "Deleting Job...")
        if del_id != nil && user_id != nil {
            let deleteJob_URL = main_URL+"api/transporterCompletedJobDelete"
            let parameters : Parameters = ["del_id" : del_id!, "user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(deleteJob_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("delete job jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        //let message = jsonData[0]["message"].stringValue
                        if self.businessJobs == true {
                        self.completedJobsModelBusiness.remove(at: self.rowID!)
                        } else {
                        self.completedJobsModel.remove(at: self.rowID!)
                        }
                        
                        self.tableView.reloadData()
                        if result == "1" {
                            self.performSegue(withIdentifier: "deleted", sender: self)
                        }
                    } else {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("Error \(response.result.error!)")
                    }
                }
            } else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error!", message: "Please enter your email address", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func convertDateFormatter(_ date: String) -> String
       {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "dd-MM-yyyy"
           let date = dateFormatter.date(from: date)
           dateFormatter.dateFormat = "dd-MMM-yyyy"
           return  dateFormatter.string(from: date!)
       }
}
