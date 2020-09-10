//
//  CompletedJobs.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

//
//  ActiveJobs.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import Cosmos
import IBAnimatable

@available(iOS 13.0, *)
class CompletedJobs: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    /*@IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchFilter_View: UIView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var SearchField_view: UIView!
    @IBOutlet weak var fromDate: AnimatableTextField!
    @IBOutlet weak var toDate: AnimatableTextField!
    @IBOutlet weak var search_btn: UIButton!
    @IBOutlet weak var searchResult_view: UIView!
    @IBOutlet weak var total_compeleted_job: UILabel!
    @IBOutlet weak var total_income_count: UILabel!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var search_filter_backbtn: UIButton!
    @IBOutlet weak var searchField_height: NSLayoutConstraint!
    
    @IBOutlet weak var searchFilter_btn: UIButton!
    @IBOutlet weak var search_fliter_btn: UIImageView!
    @IBOutlet weak var searchFilter_arrow: UIImageView!
    @IBOutlet weak var searchBtn_icon: UIImageView!
    @IBOutlet weak var dateTo_Icon: UIImageView!
    @IBOutlet weak var dateFrom_icon: UIImageView! */
    @IBOutlet weak var noJob: UILabel!
    @IBOutlet weak var completeJobCount_lbl: UILabel!
    
    @IBOutlet var delete_popview: UIView!
    @IBOutlet weak var logo_popupView: UIView!
    
    lazy var completedJobsModel = [CompletedJobsModel]()
    lazy var completedJobsModelBusiness = [CompletedJobsModelBusiness]()
    private var rowID : Int?
    var refresher: UIRefreshControl!
    var roundedPrice: Double = 0.0
    var completedJobs = false
    var completeJobPrice : String?
    var resultRemaining = 0.0
    var priceValue: String?
    var HEADER_HEIGHT = 58
    var menuShowing = false
    var searchbool = false
    let picker = UIDatePicker()
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    let sb = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let completeJob = UserDefaults.standard.string(forKey: "complete_job") else { return }
        completeJobCount_lbl.text = "(" + completeJob + ")"
//        self.title = "Completed Jobs"+" ("+userCompletedJobs+")"
        stackView.isHidden = true
        getCompletedJobs(url: "api/transporterCompletedJobs")
        businessJobs = false
        
        self.navigationController?.navigationBar.isHidden = true
//        liveView.isHidden = true
//        search_filter_backbtn.isHidden = true
//        searchResult_view.isHidden = true
//
//        tableView.tableHeaderView = topView
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
//        tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CompletedJobsCell", bundle: nil) , forCellReuseIdentifier: "completedJobs")
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(CompletedJobs.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        
//        self.SearchField_view.isHidden = true
//        toDate.delegate = self
//        fromDate.delegate = self
//        createDatePicker()
//        searchResult_view.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
           darkMood()
       }
    func darkMood(){
        if switchCheck == true {
               /* self.arrow.image = UIImage(named: "arrowDownDark")

                searchBtn_icon.image = UIImage(named: "filterDarkMood")
                
                topView.backgroundColor = UIColor.darkGray
                search_fliter_btn.image = UIImage(named: "darkMood_yellowBtn")
                searchFilter_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                searchFilter_btn.setTitleColor(.white, for: .normal)
                self.fromDate.backgroundColor = UIColor(hexString: "252A2D")
                self.toDate.backgroundColor = UIColor(hexString: "252A2D")
                self.fromDate.textColor = UIColor.white
                self.toDate.textColor = UIColor.white
                dateTo_Icon.image = UIImage(named: "deliveryDateDark")
                dateFrom_icon.image = UIImage(named: "deliveryDateDark")
                search_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                search_btn.setTitleColor(.white, for: .normal)
            
                search_filter_backbtn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
                search_filter_backbtn.setTitleColor(.white, for: .normal)
                */
                noJob.textColor = UIColor.white
                self.tableView.backgroundColor = UIColor.black
        }else{
            
        }
    }
    func filterList() {
      //  tableView.sorted() { $0. > $1.fruitName } // sort the fruit by name
        tableView.reloadData(); // notify the table view the data has changed
    }
    
  /*  func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
       
        toDate.inputAccessoryView = toolbar
//        toDate.inputView = picker
        picker.datePickerMode = .date
        
        fromDate.inputAccessoryView = toolbar
//        fromDate.inputView = picker
        picker.datePickerMode = .date
        
    }
    */
   /* @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: picker.date)
        if toDate.isFirstResponder {
        toDate.text = "\(dateString)"
        }
        if fromDate.isFirstResponder{
        fromDate.text = "\(dateString)"
        }
        self.view.endEditing(true)
    }*/
    
    /*@IBAction func search_filter_back(_ sender: Any) {
        SearchField_view.isHidden = true
        UIView.animate(withDuration: 0.1, animations: {
                       self.SearchField_view.isHidden = true
                       self.menuShowing = false
                       self.HEADER_HEIGHT = 58
                       self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                       self.tableView.tableHeaderView = self.topView
                       self.tableView.layoutIfNeeded()
                       self.arrow.image = UIImage(named: "downArrow-1")
                       self.view.layoutIfNeeded()
                   })
        searchbool = false
    }
    */
    @IBAction func search_btn(_ sender: Any) {
      //  searchCompletedJob()
        //self.getCompletedJobs(url: "api/transporterCompletedJobs")
//        self.searchField_height.constant = 400
        self.searchbool = true
        //dropDownFunc()
    }
    
  /*  func searchCompletedJob() {
        SVProgressHUD.show(withStatus: "Getting details...")
               if user_id != nil {
                   let searchCompletedJob = main_URL+"api/searchtransporterCompletedJobs"
                let parameters : Parameters = ["user_id" : user_id!, "start_date": fromDate.text! , "end_date" : toDate.text! ]
                   if Connectivity.isConnectedToInternet() {
                       Alamofire.request(searchCompletedJob, method : .post, parameters : parameters).responseJSON {
                           response in
                           if response.result.isSuccess {
                               SVProgressHUD.dismiss()
                            
                               let jsonData : JSON = JSON(response.result.value!)
                               print("Search Transporter Completed Job that is: \n \(jsonData)")
                            let result = jsonData[0]["result"].stringValue
                            let message1 = jsonData[0]["message"].stringValue
                            let totaljobs = jsonData[0]["totaljobs"].stringValue
                            let total_income = jsonData[0]["total_income"].stringValue
                            
                            if result == "0" {
                                
                                self.completedJobsModel.removeAll()
                                                          
                                self.tableView.reloadData()
                                if self.menuShowing == false{
                                self.stackView.isHidden = false
                                }else{
                                    self.stackView.isHidden = true
                                }
                                self.tableView.backgroundView = nil
                                SVProgressHUD.showError(withStatus: message1)
                                self.total_compeleted_job.text = "0"
                                self.total_income_count.text = "0"
                            } else {
                                //self.getCompletedJobs(url: "api/transporterCompletedJobs")
                                self.liveView.isHidden = false
                                self.search_filter_backbtn.isHidden = false
                                self.searchResult_view.isHidden = false
                                
                                self.total_compeleted_job.text = totaljobs
                                self.total_income_count.text = total_income
                               
                            }
                            
                        }else {
                            SVProgressHUD.dismiss()
                            let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
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
        }else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           
        }
    } */
    @IBAction func search_filter_action(_ sender: Any) {
      //  dropDownFunc()
               if completedJobsModel.count == 0 {
                   stackView.isHidden = false
               }else{
                   stackView.isHidden = true
               }
    }
    
 /*   func dropDownFunc() {
        if menuShowing == false {
            if ( UI_USER_INTERFACE_IDIOM() == .pad )
            {
                UIView.animate(withDuration: 0.1, animations: {
                    self.SearchField_view.isHidden = false
                     //self.searchField_height.constant = 235
                    self.fromDate.text! = ""
                    self.toDate.text! = ""
                    self.liveView.isHidden = true
                    self.search_filter_backbtn.isHidden = true
                    self.searchResult_view.isHidden = true
                    self.menuShowing = true
                    self.HEADER_HEIGHT = 300
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    if self.switchCheck == true {
                        self.arrow.image = UIImage(named: "arrowupDark")
                    }else{
                        self.arrow.image = UIImage(named: "upArrow")
                    }
                    
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.SearchField_view.isHidden = false
                   // self.searchField_height.constant = 235
                    self.liveView.isHidden = true
                    self.search_filter_backbtn.isHidden = true
                    self.searchResult_view.isHidden = true
                    self.fromDate.text! = ""
                    self.toDate.text! = ""
                    self.menuShowing = true
                    self.HEADER_HEIGHT = 280
                    
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    if self.switchCheck == true {
                        self.arrow.image = UIImage(named: "arrowupDark")
                    }else{
                        self.arrow.image = UIImage(named: "upArrow")
                    }
                   
                    self.view.layoutIfNeeded()
                })
                
               
            }
            
        } else if menuShowing == true {
            if searchbool == true{
                
                UIView.animate(withDuration: 0.1, animations: {
                self.SearchField_view.isHidden = false
                // self.searchField_height.constant = 235
                self.liveView.isHidden = false
                self.search_filter_backbtn.isHidden = false
                self.searchResult_view.isHidden = false
                self.menuShowing = true
                self.HEADER_HEIGHT = 445
                            
                self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                self.tableView.tableHeaderView = self.topView
                self.tableView.layoutIfNeeded()
                    
                if self.switchCheck == true {
                    self.arrow.image = UIImage(named: "arrowupDark")
                }else{
                    self.arrow.image = UIImage(named: "upArrow")
                }
                
                self.view.layoutIfNeeded()
                self.searchbool = false
                })
               
            }else{
            UIView.animate(withDuration: 0.1, animations: {
                self.SearchField_view.isHidden = true
                self.menuShowing = false
                self.HEADER_HEIGHT = 58
                self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                self.tableView.tableHeaderView = self.topView
                self.tableView.layoutIfNeeded()
                if self.switchCheck == true {
                    self.arrow.image = UIImage(named: "arrowDownDark")
                }else{
                self.arrow.image = UIImage(named: "downArrow-1")
                }
                self.view.layoutIfNeeded()
            })
            }
        }
    } */
//    @IBAction func completedJobsBtn(_ sender: Any) {
//        if completedJobs == false {
//            businessJobs = true
//            completedJobsOutlet.setTitle("Completed Jobs ("+userCompletedJobs+")", for: .normal)
//            self.getCompletedJobs(url: "api/transporterCompletedJobsBusiness")
//            self.title = "Business Completed Jobs"+" ("+User_Completed_Jobs_Business+")"
//            completedJobs = true
//        } else {
//            businessJobs = false
//            completedJobsOutlet.setTitle("Business Completed Jobs ("+User_Completed_Jobs_Business+")", for: .normal)
//            self.getCompletedJobs(url: "api/transporterCompletedJobs")
//            self.title = "Completed Jobs"+" ("+userCompletedJobs+")"
//            completedJobs = false
//        }
//    }
    
    @objc func populate() {
        DispatchQueue.main.async {
//        if self.completedJobs == false {
//            businessJobs = false
//            self.getCompletedJobs(url: "api/transporterCompletedJobs")
//        } else {
//            businessJobs = true
//            self.getCompletedJobs(url: "api/transporterCompletedJobsBusiness")
//        }
        self.getCompletedJobs(url: "api/transporterCompletedJobs")
        self.refresher.endRefreshing()
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
                    
//                    print("this is completed job api response.../n \(String(describing: response1))")
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("completed Jobs jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        self.completedJobsModel.removeAll()
                        self.completedJobsModelBusiness.removeAll()
                       
                        if result == "0" {
                            self.tableView.backgroundView = nil
                            self.stackView.isHidden = false
                            self.tableView.reloadData()
                        } else {
                        let error = response.error
                        let data = response.data
                        if error == nil {
                            do {
                                if url == "api/transporterCompletedJobsBusiness" {
                                    self.completedJobsModelBusiness = try JSONDecoder().decode([CompletedJobsModelBusiness].self, from: data!)
                                    SVProgressHUD.dismiss()
//                                    print(self.completedJobsModelBusiness)
                                    
                                    DispatchQueue.main.async {
//                                        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
                                        self.stackView.isHidden = true
                                        self.tableView.reloadData()
                                    }
                                } else {
                                    self.completedJobsModel = try JSONDecoder().decode([CompletedJobsModel].self, from: data!)
                                    SVProgressHUD.dismiss()
//print(self.completedJobsModel)
                                    
                                    DispatchQueue.main.async {
//                                        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
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
            let payment_type1 = completedJobsRow.payment_type
            let due_amount_status = completedJobsRow.due_amount_status
                    
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
            let contactPerson = completedJobsRow.contact_person
//            cell.driver_name.setTitle(contactPerson.capitalized, for: .normal)
            
            let currentBid = completedJobsRow.current_bid
            let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
            let doubleValue = Double(x)
            let resultInitialPrice = Double(currentBid)! * Double(doubleValue!/100)
//            let resultInitialPrice = Double(currentBid)! * Double(0.25)
            self.roundedPrice = Double(resultInitialPrice).rounded(toPlaces: 2)
            
            let resultRemaining1 = Double(currentBid)! - self.roundedPrice
            cell.price.text = "£"+String(resultRemaining1)
       
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
            let due_amount_status = completedJobsRow.due_amount_status
            
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
            
            let contactPerson = completedJobsRow.contact_person
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
            
              if businessJobs == true {
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
            
            UIView.animate(withDuration: 0.3, animations: {
//                self.delete_popview.layer.borderColor = UIColor.gray.cgColor
//                self.delete_popview.layer.borderWidth = 1
                self.delete_popview.layer.cornerRadius = 18
                self.tableView.alpha = 0.5
                
                self.logo_popupView.clipsToBounds = true
                self.logo_popupView.layer.cornerRadius = 18
                self.logo_popupView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
                
                self.view.addSubview(self.delete_popview)
                self.delete_popview.center = self.view.center
            })
        
    }
        
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
        cell.detailJobRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            if businessJobs == true {
                del_id = self.completedJobsModelBusiness[indexPath.row].del_id
                jobs_completed = true
//                self.performSegue(withIdentifier: "detail", sender: self)

                let vc = storyboard.instantiateViewController(identifier: "JobDetial_ViewController") as JobDetial_ViewController
                vc.bookedJobPrice = cell.price.text
             
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
            del_id = self.completedJobsModel[indexPath.row].del_id
            jobs_completed = true
           
            let vc = storyboard.instantiateViewController(identifier: "JobDetial_ViewController") as JobDetial_ViewController
            vc.bookedJobPrice = cell.price.text
            self.navigationController?.pushViewController(vc, animated: true)
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
    @IBAction func PopView_noBtn_action(_ sender: Any) {
        self.delete_popview.removeFromSuperview()
               self.tableView.alpha = 1
    }
    @IBAction func popUp_yesBtn(_ sender: Any) {
        self.deleteJob()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if businessJobs == true {
            del_id = self.completedJobsModelBusiness[indexPath.row].del_id
            jobs_completed = true
//            self.performSegue(withIdentifier: "detail", sender: self)
//            jobPrice = self.completedJobsModelBusiness[indexPath.row]
           
            let vc = storyboard.instantiateViewController(identifier: "JobDetial_ViewController") as JobDetial_ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        
        } else {
            jobs_completed = true
          
        del_id = self.completedJobsModel[indexPath.row].del_id
//        self.performSegue(withIdentifier: "detail", sender: self)

        let vc = storyboard.instantiateViewController(identifier: "JobDetial_ViewController") as JobDetial_ViewController
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
                        if businessJobs == true {
                        self.completedJobsModelBusiness.remove(at: self.rowID!)
                        } else {
                        self.completedJobsModel.remove(at: self.rowID!)
                        }
                        
                        self.tableView.reloadData()
                        if result == "1" {
//                            self.performSegue(withIdentifier: "deleted", sender: self)
                            let vc = self.sb.instantiateViewController(withIdentifier: "deletedJob") as! SuccessController
                    self.navigationController?.pushViewController(vc, animated: true)
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
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        return  dateFormatter.string(from: date!)
    }
    
}

