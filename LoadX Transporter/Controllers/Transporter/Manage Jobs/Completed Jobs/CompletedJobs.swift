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
import RxSwift
//@available(iOS 13.0, *)
class CompletedJobs: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
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
    
    //routes
    private let disposeBag = DisposeBag()
    var routes = [BookedRoute]()
    //route jobs
    //For Routes. Top view setup
    @IBOutlet weak var topPagerView: UIView!
    @IBOutlet weak var leadingSearchJobs: NSLayoutConstraint!
    @IBOutlet weak var trailingSearchJobs: NSLayoutConstraint!
    @IBOutlet weak var leadingRouteJobs: NSLayoutConstraint!
    @IBOutlet weak var trailingRouteJobs: NSLayoutConstraint!
    @IBOutlet weak var pagerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchJobsBtn: UIButton!
    @IBOutlet weak var routeJobsBtn: UIButton!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var routesTableView: UITableView!
    
    func setConstraints(leadingSearch: Bool, trailingSearch: Bool, leadingRoute: Bool, trailingRoute: Bool) {
        UIView.animate(withDuration: 3.0) { [weak self] in
            self?.leadingSearchJobs.isActive = leadingSearch
            self?.trailingSearchJobs.isActive = trailingSearch
            self?.leadingRouteJobs.isActive = leadingRoute
            self?.trailingRouteJobs.isActive = trailingRoute
        }
    }
    var searchCount : String?
    var routeCount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRouteAccess()
        guard let completeJob = UserDefaults.standard.string(forKey: "complete_job") else { return }
        completeJobCount_lbl.text = "(" + completeJob + ")"
        //self.title = "Completed Jobs"+" ("+userCompletedJobs+")"
        stackView.isHidden = true
        getCompletedJobs(url: "api/transporterCompletedJobs")
        businessJobs = false
        
        self.navigationController?.navigationBar.isHidden = true
        
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CompletedJobsCell", bundle: nil) , forCellReuseIdentifier: "completedJobs")
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(CompletedJobs.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        
        //routes table view
        configureRoutesTableView()
        bindButtons()
        getRoutes()
        routeJobsBtn.alpha = 0.5
    }
    override func viewWillAppear(_ animated: Bool) {
        darkMood()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkRouteAccess()
    }
    func darkMood(){
        if switchCheck == true {
            noJob.textColor = UIColor.white
            self.tableView.backgroundColor = UIColor.black
        }else{
            
        }
    }
    
    func configureRoutesTableView() {
        routesTableView.delegate = self
        routesTableView.dataSource = self
        routesTableView.register(cellType: RouteCompletedView.self)
    }
    
    func checkRouteAccess() {
        if let isLoadxDrive = UserDefaults.standard.string(forKey: "isLoadxDriver") {
            if isLoadxDrive == "0" {
                self.pagerViewHeight.constant = 0
                self.topPagerView.isHidden = true
                self.view.layoutIfNeeded()
            } else {
                self.pagerViewHeight.constant = 55
                self.topPagerView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func bindButtons() {
        searchJobsBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.routesTableView.isHidden = true
            self?.setConstraints(leadingSearch: true, trailingSearch: true, leadingRoute: false, trailingRoute: false)
            self?.topLabel.text = "Completed Jobs"
            self?.routeJobsBtn.alpha = 0.5
            self?.searchJobsBtn.alpha = 1.0
            self?.completeJobCount_lbl.text = self?.searchCount ?? "(0)"
            if (self?.completedJobsModel.count ?? 0) > 0 {
            self?.tableView.isHidden = false
            self?.stackView.isHidden = true
            } else {
            self?.stackView.isHidden = false
            self?.tableView.isHidden = true
            self?.noJob.text = "Currently no completed jobs"
            }
        }).disposed(by: disposeBag)
        
        routeJobsBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.routeJobsBtn.alpha = 1.0
            self?.searchJobsBtn.alpha = 0.5
            self?.tableView.isHidden = true
            self?.topLabel.text = "Completed Routes"
            self?.completeJobCount_lbl.text = self?.routeCount ?? "(0)"
            self?.setConstraints(leadingSearch: false, trailingSearch: false, leadingRoute: true, trailingRoute: true)
            if (self?.routes.count ?? 0) > 0 {
                self?.routesTableView.isHidden = false
                self?.stackView.isHidden = true
            } else {
                self?.routesTableView.isHidden = true
                self?.stackView.isHidden = false
                self?.noJob.text = "Currently no completed routes"
            }
        }).disposed(by: disposeBag)
        
    }
    
    func getRoutes() {
        self.routeJobsBtn.isUserInteractionEnabled = false
        APIManager.apiPost(serviceName: "api/getCompletedRouteList", parameters: ["user_id" : user_id ?? ""]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                self.routeJobsBtn.isUserInteractionEnabled = true
            }
            do {
                self.routes = try JSONDecoder().decode([BookedRoute].self, from: data ?? Data())
                print("completed Route json is \(String(describing: json))")
                self.routeCount = "(\(self.routes.count))"
                self.routesTableView.reloadData()
                self.routeJobsBtn.isUserInteractionEnabled = true
            } catch {
                self.routeJobsBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    func filterList() {
        //  tableView.sorted() { $0. > $1.fruitName } // sort the fruit by name
        tableView.reloadData(); // notify the table view the data has changed
    }
    
    @IBAction func search_btn(_ sender: Any) {
        self.searchbool = true
    }
    
    @IBAction func search_filter_action(_ sender: Any) {
        if completedJobsModel.count == 0 {
            stackView.isHidden = false
        }else{
            stackView.isHidden = true
        }
    }
    
    @objc func populate() {
        DispatchQueue.main.async {
            self.getCompletedJobs(url: "api/transporterCompletedJobs")
            self.refresher.endRefreshing()
        }
    }
    
    func getCompletedJobs(url: String) {
        guard Connectivity.isConnectedToInternet() else { return self.present(showAlert(title: "Alert", message: "You are not connected to Internet"), animated: true, completion: nil)}
        guard user_id != nil else { return self.present(showAlert(title: "Alert", message: "User id is missing"), animated: true, completion: nil)}
        SVProgressHUD.show(withStatus: "Getting details...")
        let activeJobs_URL = main_URL+url
        let parameters : Parameters = ["user_id" : user_id!]
        Alamofire.request(activeJobs_URL, method : .post, parameters : parameters).responseJSON {
            response in
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
                                self.completedJobsModelBusiness = try JSONDecoder().decode([CompletedJobsModelBusiness].self, from: data ?? Data())
                                SVProgressHUD.dismiss()
                                //print(self.completedJobsModelBusiness)
                                
                                DispatchQueue.main.async {
                                    self.stackView.isHidden = true
                                    self.tableView.reloadData()
                                }
                            } else {
                                self.completedJobsModel = try JSONDecoder().decode([CompletedJobsModel].self, from: data ?? Data())
                                self.completeJobCount_lbl.text = "(\(self.completedJobsModel.count))"
                                self.searchCount = "(\(self.completedJobsModel.count))"
                                SVProgressHUD.dismiss()
                                
                                DispatchQueue.main.async {
                                    self.stackView.isHidden = true
                                    self.tableView.reloadData()
                                }
                            }
                        } catch {
                            SVProgressHUD.dismiss()
                            self.present(showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                        }
                    }
                }
            } else {
                SVProgressHUD.dismiss()
                self.present(showAlert(title: "Error", message: response.result.error?.localizedDescription ?? ""), animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == routesTableView {
            return routes.count
        }
        if businessJobs == true {
            return completedJobsModelBusiness.count
        } else {
            return completedJobsModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == routesTableView {
            return 260
        }
        return 260
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Routes Table View
        if tableView == routesTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RouteCompletedView.self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundView = nil
            cell.backgroundColor = nil
            cell.layer.shadowRadius = 10
            cell.dataSource = routes[indexPath.row]
            cell.parentViewController = self
            return cell
        }
        
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
            if payment_type1 == "full" || payment_type1 == "Full" {
                if due_amount_status == "Pending" {
                    cell.receivedAmount.text = "Pending"
                    cell.receivedAmount.textColor = UIColor.init(hexString: "#F6AD4E")
                    
                } else if due_amount_status == "paid" || due_amount_status == "Paid" {
                    cell.receivedAmount.text = "Received"
                    cell.receivedAmount.textColor = UIColor.init(hexString: "#4A9B4B")
                }
            } else if due_amount_status == "paid" || due_amount_status == "Paid" {
                cell.receivedAmount.text = "Received"
                cell.receivedAmount.textColor = UIColor.init(hexString: "#4A9B4B")
            } else if payment_type1 == "initial" || payment_type1 == "Initial" {
                if due_amount_status == "Pending" {
                    cell.receivedAmount.text = "Received"
                    cell.receivedAmount.textColor = UIColor.init(hexString: "#4A9B4B")
                } else if due_amount_status == "paid" || due_amount_status == "Paid" {
                    cell.receivedAmount.text = "Received"
                    cell.receivedAmount.textColor = UIColor.init(hexString: "#4A9B4B")
                }
            }
            
            let movingItem = completedJobsRow.moving_item
            cell.moving_item.text = movingItem.capitalized
            cell.pick_up.text = completedJobsRow.pu_house_no ?? "" + " " + completedJobsRow.pick_up
            cell.drop_off.text = completedJobsRow.do_house_no ?? "" + " " + completedJobsRow.drop_off
            let stringDate = completedJobsRow.date
            let convertedDate = convertDateFormatter(stringDate)
            cell.date.text = convertedDate
//            let contactPerson = completedJobsRow.contact_person
            //            cell.driver_name.setTitle(contactPerson.capitalized, for: .normal)
            
            let currentBid = completedJobsRow.current_bid
            
            if completedJobsRow.transporter_share != "0" {
                let str = Double(completedJobsRow.transporter_share) ?? 0.0
                cell.price.text = "£ "+String(format: "%.2f", str)
            } else {
                let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
                let  doubleValue = Double(x)
                cell.price.text = "£ "+"\(getDoubleValue(currentBid: Double(currentBid) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
            }
            
            let payment_type = completedJobsRow.is_company_job
            if payment_type != "0" {
                    cell.payment_type_lbl.text = "Account Job"
            }else{
                    cell.payment_type_lbl.text = "Cash Job"
            }
        } else {
            
            let completedJobsRow = completedJobsModel[indexPath.row]
            let payment_type = completedJobsRow.payment_type
            if payment_type != "" {
                    cell.payment_type_lbl.text = "Account Job"
            }else{
                    cell.payment_type_lbl.text = "Cash Job"
            }
            let is_companyJob = completedJobsRow.is_company_job
            
            if is_companyJob == "1" {
                cell.businessPatti.isHidden = false
                cell.widthBusiness.constant = 82
                if switchCheck == true {
                    cell.payment_type_lbl.text = "Account Job"
                }else{
                    cell.payment_type_lbl.text = "Account Job"
                }
            } else {
                cell.businessPatti.isHidden = true
                cell.widthBusiness.constant = 0
            }
            
            let due_amount_status = completedJobsRow.due_amount_status
            
            let payment_type2 = completedJobsRow.payment_type
            if payment_type2 == "full"  {
                cell.payment_type_lbl.text = "Account Job"
            }else{
                cell.payment_type_lbl.text = "Cash Job"
            }
            
            if payment_type2 == "full" || payment_type2 == "Full" {
                if due_amount_status == "Pending" {
                    cell.receivedAmount.text = "Pending"
                    cell.receivedAmount.textColor = UIColor.init(hexString: "#F6AD4E")
                    
                } else if due_amount_status == "paid" || due_amount_status == "Paid" {
                    cell.receivedAmount.text = "Received"
                    cell.receivedAmount.textColor = UIColor.init(hexString: "#4A9B4B")
                }
            } else if due_amount_status == "paid" || due_amount_status == "Paid" {
                cell.receivedAmount.text = "Received"
                cell.receivedAmount.textColor = UIColor.init(hexString: "#4A9B4B")
            } else if payment_type2 == "initial" || payment_type2 == "Initial" {
                if due_amount_status == "Pending" {
                    cell.receivedAmount.text = "Received"
                    cell.receivedAmount.textColor = UIColor.init(hexString: "#4A9B4B")
                } else if due_amount_status == "paid" || due_amount_status == "Paid" {
                    cell.receivedAmount.text = "Received"
                    cell.receivedAmount.textColor = UIColor.init(hexString: "#4A9B4B")
                }
            }
            
            let movingItem = completedJobsRow.moving_item
            cell.moving_item.text = movingItem.capitalized
            cell.pick_up.text = "\(completedJobsRow.pu_house_no ?? "") \(completedJobsRow.pick_up)"
            cell.drop_off.text = "\(completedJobsRow.do_house_no ?? "") \(completedJobsRow.drop_off)"
            
            let stringDate = completedJobsRow.date
            let convertedDate = convertDateFormatter(stringDate)
            cell.date.text = convertedDate
            
//            let contactPerson = completedJobsRow.contact_person
            
            let currentBid = completedJobsRow.current_bid
            if completedJobsRow.transporter_share != "0" {
                let str = Double(completedJobsRow.transporter_share) ?? 0.0
                cell.price.text = "£ "+String(format: "%.2f", str)
            } else {
                let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
                let  doubleValue = Double(x)
                cell.price.text = "£ "+"\(getDoubleValue(currentBid: Double(currentBid) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
            }
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
            
            UIView.animate(withDuration: 0.3, animations: {
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
        cell.detailJobRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            if businessJobs == true {
                del_id = self.completedJobsModelBusiness[indexPath.row].del_id
                jobs_completed = true
                
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
    @IBAction func PopView_noBtn_action(_ sender: Any) {
        self.delete_popview.removeFromSuperview()
        self.tableView.alpha = 1
    }
    @IBAction func popUp_yesBtn(_ sender: Any) {
        self.deleteJob()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == routesTableView {
            if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteDetailsViewController") as? RouteDetailsViewController {
                vc.routeId = self.routes[indexPath.row].lr_id
                vc.isBooked = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
        let cell = tableView.cellForRow(at: indexPath) as! CompletedJobsCell
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if businessJobs == true {
            del_id = self.completedJobsModelBusiness[indexPath.row].del_id
            jobs_completed = true
            //            self.performSegue(withIdentifier: "detail", sender: self)
            //            jobPrice = self.completedJobsModelBusiness[indexPath.row]
            
            if #available(iOS 13.0, *) {
                let vc = storyboard.instantiateViewController(identifier: "JobDetial_ViewController") as JobDetial_ViewController
                vc.showHouseNumber = true
                vc.pickupAdd = cell.pick_up.text
                vc.dropoffAdd = cell.drop_off.text
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            jobs_completed = true
            
            del_id = self.completedJobsModel[indexPath.row].del_id
            //        self.performSegue(withIdentifier: "detail", sender: self)
            
            if #available(iOS 13.0, *) {
                let vc = storyboard.instantiateViewController(identifier: "JobDetial_ViewController") as JobDetial_ViewController
                vc.showHouseNumber = true
                vc.pickupAdd = cell.pick_up.text
                vc.dropoffAdd = cell.drop_off.text
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        }
    }
    func deleteJob() {
        guard Connectivity.isConnectedToInternet() else { return self.present(showAlert(title: "Alert", message: "You are not connected to Internet"), animated: true, completion: nil)}
        SVProgressHUD.show(withStatus: "Deleting Job...")
        if del_id != nil && user_id != nil {
            let deleteJob_URL = main_URL+"api/transporterCompletedJobDelete"
            let parameters : Parameters = ["del_id" : del_id!, "user_id" : user_id!]
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
                    self.present(showAlert(title: "Error", message: response.result.error?.localizedDescription ?? ""), animated: true, completion: nil)
                }
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error!", message: "Please enter your email address", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

