//
//  JobsInProgress.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IBAnimatable
import RxSwift
import SwiftMessages

var businessJobs : Bool?
var route_id: String?
var is_route_started: String?
var islastIndex: Int?

class JobsInProgress: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    private let disposeBag = DisposeBag()
    var routes = [BookedRoute]()
    var isRouteStarted = ""
    let locationManager = CLocationManager.shared
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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet var jobCancel_popview: UIView!
    @IBOutlet var jobCancelReason: UILabel!
    @IBOutlet var jobComplete_popview: UIView!
    @IBOutlet weak var noJob_lbl: UILabel!
    @IBOutlet weak var book_job_lbl: UILabel!
    
    @IBOutlet weak var popup_iconView: UIView!
    @IBOutlet weak var Cancel_popup_iconView: UIView!
    
    var isCancel: Bool = true
    var contact_person: String?
    var contact_no: String?
    var refference_no: String?
    
    let picker = UIDatePicker()
    lazy var jobsInProgressModel = [JobsInProgressModel]()
    var roundedPrice: Double = 0.0
    var refresher: UIRefreshControl!
    var routeTableViewRefresher: UIRefreshControl!
    var bookedPrice : String?
    var imagePicker = UIImagePickerController()
    private var imagePicked = 0
    private var imageData1 : Data?
    var progressJobs = false
    var HEADER_HEIGHT = 60
    var menuShowing = false
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let year = Calendar.current.component(.year, from: Date())
    var searchCount : String?
    var routeCount: String?
    var lr_id: String?
    var isRoute = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkRouteAccess()
        self.popup_iconView.clipsToBounds = true
        self.popup_iconView.layer.cornerRadius = 18
        self.popup_iconView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        self.Cancel_popup_iconView.clipsToBounds = true
        self.Cancel_popup_iconView.layer.cornerRadius = 18
        self.Cancel_popup_iconView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        stackView.isHidden = true
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
        
        tableView.register(UINib(nibName: "JobsInProgressCell", bundle: nil) , forCellReuseIdentifier: "jobsInProgress")
        
        guard let bookJob = UserDefaults.standard.string(forKey: "Book_job") else { return }
        book_job_lbl.text = "(" + bookJob + ")"
        
        //        getBookedJobs(url: "api/transporterInprogresJobs")
        //routes table view
        configureRoutesTableView()
        tableViewsRefreshControl()
        routeJobsBtn.alpha = 0.5
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelect), name: NSNotification.Name(rawValue: "didSelect"), object: nil)
    }
    
    func tableViewsRefreshControl() {
        refresher = UIRefreshControl()
        refresher.tintColor = R.color.textfieldTextColor()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: R.color.textfieldTextColor() ?? .gray])
        refresher.addTarget(self, action: #selector(JobsInProgress.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        
        routeTableViewRefresher = UIRefreshControl()
        routeTableViewRefresher.tintColor = R.color.textfieldTextColor()
        routeTableViewRefresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: R.color.textfieldTextColor() ?? .gray])
        routeTableViewRefresher.addTarget(self, action: #selector(refreshRouteData), for: UIControl.Event.valueChanged)
        routesTableView.addSubview(routeTableViewRefresher)
    }
    
    @objc func refreshRouteData() {
        callAPIs()
        self.routeTableViewRefresher.endRefreshing()
    }
    
    @objc func didSelect(_ notification: Notification) {
        //        routesJobsBtnFunc()
        //        if islastIndex == 1 {
        //
        //        } else {
        //        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteDetailsViewController") as? RouteDetailsViewController {
        //            vc.routeId = route_id
        //            vc.isRouteStarted = is_route_started ?? ""
        //            vc.isBooked = true
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
        //        }
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
    
    func configureRoutesTableView() {
        routesTableView.delegate = self
        routesTableView.dataSource = self
        routesTableView.register(cellType: RouteBookedView.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callAPIs()
    }
    
    func callAPIs() {
        getRoutes()
        checkRouteAccess()
        
        getBookedJobs(url: "api/transporterInprogresJobs") {
            if let isLoadxDrive = UserDefaults.standard.string(forKey: "isLoadxDriver") {
                if isLoadxDrive == "0" {
                    self.searchJobsBtnFunc()
                } else {
                    if !self.isRoute {
                        self.searchJobsBtnFunc()
                    } else {
                        self.routesJobsBtnFunc()
                    }
                }
            } else {
                self.searchJobsBtnFunc()
            }
        }
    }
    
    @IBAction func searchJobsAct(_ sender: Any) {
        searchJobsBtnFunc()
    }
    
    @IBAction func routesJobsAct(_ sender: Any) {
        routesJobsBtnFunc()
    }
    
    func searchJobsBtnFunc() {
        isRoute = false
        routesTableView.isHidden = true
        setConstraints(leadingSearch: true, trailingSearch: true, leadingRoute: false, trailingRoute: false)
        topLabel.text = "Booked Jobs"
        routeJobsBtn.alpha = 0.5
        searchJobsBtn.alpha = 1.0
        book_job_lbl.text = "(\(jobsInProgressModel.count))"
        if (jobsInProgressModel.count) > 0 {
            tableView.isHidden = false
            stackView.isHidden = true
        } else {
            stackView.isHidden = false
            tableView.isHidden = true
            noJob_lbl.text = "Currently no booked jobs"
        }
    }
    
    func routesJobsBtnFunc() {
        self.isRoute = true
        self.goToRoute()
        if (self.routes.count) > 0 {
            self.routesTableView.isHidden = false
            self.stackView.isHidden = true
        } else {
            self.routesTableView.isHidden = true
            self.stackView.isHidden = false
            self.noJob_lbl.text = "Currently no booked routes"
        }
    }
    
    func goToRoute() {
        self.routeJobsBtn.alpha = 1.0
        self.searchJobsBtn.alpha = 0.5
        self.tableView.isHidden = true
        self.topLabel.text = "Booked Routes"
        self.book_job_lbl.text = "(\(self.routes.count))"
        self.setConstraints(leadingSearch: false, trailingSearch: false, leadingRoute: true, trailingRoute: true)
    }
    
    func getRoutes() {
        self.routeJobsBtn.isUserInteractionEnabled = false
        APIManager.apiPost(serviceName: "api/userDashboardRouteJobs", parameters: ["user_id" : user_id ?? ""]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                self.routeJobsBtn.isUserInteractionEnabled = true
            }
            do {
                self.routes = try JSONDecoder().decode([BookedRoute].self, from: data ?? Data())
                //                print("Booked Route json is \(String(describing: json))")
                self.routeCount = "(\(self.routes.count))"
                self.routesTableView.reloadData()
                self.routeJobsBtn.isUserInteractionEnabled = true
            } catch {
                self.routeJobsBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func populate() {
        callAPIs()
        self.refresher.endRefreshing()
    }
    
    
    func getBookedJobs(url: String, completed: @escaping () -> ()) {
        guard Connectivity.isConnectedToInternet() else { return self.present(showAlert(title: "Alert", message: "You are not connected to Internet"), animated: true, completion: nil)}
        guard user_id != nil else { return self.present(showAlert(title: "Alert", message: "User id is missing"), animated: true, completion: nil)}
        SVProgressHUD.show(withStatus: "Getting details...")
        let bookedJobs_URL = main_URL+url
        let parameters : Parameters = ["user_id" : user_id!]
        Alamofire.request(bookedJobs_URL, method : .post, parameters : parameters).responseJSON { [weak self]
            response in
            guard let self = self else { return }
            if response.result.isSuccess {
                SVProgressHUD.dismiss()
                
                let jsonData : JSON = JSON(response.result.value!)
                //                        print("Jobs In Progress jsonData is \(jsonData)")
                let result = jsonData[0]["result"].stringValue
                //                        let message = jsonData[0]["message"].stringValue
                self.jobsInProgressModel.removeAll()
                if result == "0" && self.leadingSearchJobs.isActive {
                    self.tableView.backgroundView = nil
                    self.stackView.isHidden = false
                    //                            self.searchBtn.isHidden = false
                    self.tableView.reloadData()
                } else {
                    let error = response.error
                    let data = response.data
                    if error == nil {
                        do {
                            self.jobsInProgressModel = try JSONDecoder().decode([JobsInProgressModel].self, from: data ?? Data())
                            self.searchCount = "(\(self.jobsInProgressModel.count))"
                            self.book_job_lbl.text = "(\(self.jobsInProgressModel.count))"
                            SVProgressHUD.dismiss()
                            //                                print(self.jobsInProgressModel)
                            
                            DispatchQueue.main.async {
                                completed()
                                //                                    self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
                                self.stackView.isHidden = true
                                //                                    self.searchBtn.isHidden = true
                                self.tableView.reloadData()
                                self.routesTableView.reloadData()
                            }
                        } catch {
                            print(error)
                            //                                self.present(showAlert(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
                        }
                    }
                }
            } else {
                SVProgressHUD.dismiss()
                //                        self.present(showAlert(title: "Error", message: response.result.error?.localizedDescription ?? ""), animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - UITABLEVIEW Delegate methods
    /***************************************************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == routesTableView {
            return routes.count
        }
        return jobsInProgressModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == routesTableView {
            return 326
        }
        return 345
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    //        UIView.animate(withDuration: 0.2) {
    //            cell.transform = CGAffineTransform.identity
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Routes Table View
        if tableView == routesTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RouteBookedView.self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundView = nil
            cell.backgroundColor = nil
            cell.layer.shadowRadius = 10
            cell.dataSource = routes[indexPath.row]
            cell.parentViewController = self
            cell.cancelRouteAct = {[weak self] (selectedCell) in
                guard let self = self else { return }
                let selectedIndex = self.tableView.indexPath(for: selectedCell)
                self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
                self.lr_id = self.routes[indexPath.row].lr_id
                UIView.animate(withDuration: 0.3, animations: {
                    self.jobCancel_popview.layer.cornerRadius = 18
                    self.routesTableView.alpha = 0.5
                    self.jobCancelReason.text = "Are you sure you want to cancel this route?"
                    self.isCancel = false
                    self.view.addSubview(self.jobCancel_popview)
                    self.jobCancel_popview.center = self.view.center
                })
            }
            
            cell.startRouteAct = {[weak self] (selectedCell) in
                guard let self = self else { return }
                let selectedIndex = self.tableView.indexPath(for: selectedCell)
                self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
                self.startRoute(lrID: self.routes[indexPath.row].lr_id, isRouteStarted: self.routes[indexPath.row].is_route_started ?? "")
            }
            
            return cell
        }
        
        //simple jobs table view
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobsInProgress") as! JobsInProgressCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        
        let jobsInProgressRow = jobsInProgressModel[indexPath.row]
        
        if jobsInProgressRow.is_job_started == nil || jobsInProgressRow.is_job_started == "0" {
            cell.startJobBtn.isHidden = false
        } else {
            cell.startJobBtn.isHidden = true
        }
        
        //setJobBookedFor Status
        cell.setJobBookedForView(workingHours: jobsInProgressRow.working_hours, category: jobsInProgressRow.add_type)
        cell.setData(model: jobsInProgressRow)
        
        let movingItem = jobsInProgressRow.moving_item
        cell.moving_item.text = movingItem.capitalized
        cell.jobId.text = "LX000"+(jobsInProgressRow.del_id)
        cell.pick_up.text = "\(jobsInProgressRow.pu_house_no ?? "") \(jobsInProgressRow.pick_up)"
        cell.drop_off.text = "\(jobsInProgressRow.do_house_no ?? "") \(jobsInProgressRow.drop_off)"
        
        cell.date.text = convertDateFormatter(jobsInProgressRow.date)
        cell.pickupTime.text = jobsInProgressRow.timeslot?.uppercased()
        
        if AppUtility.shared.country == .Pakistan {
            let payment_type = jobsInProgressRow.job_payment_type
            if  payment_type == "full" {
                cell.payment_method_lbl.text = "Account Job"
            }else{
                cell.payment_method_lbl.text = "Cash Job"
            }
        } else {
        let payment_type = jobsInProgressRow.payment_type
        if  payment_type == "full" {
            cell.payment_method_lbl.text = "Account Job"
        }else{
            cell.payment_method_lbl.text = "Cash Job"
        }
        }
        
        let is_companyJob = jobsInProgressRow.is_company_job
        
        if is_companyJob == "1" {
            cell.businessPatti.isHidden = false
            cell.widthBusiness.constant = 65
        } else {
            cell.businessPatti.isHidden = true
            cell.widthBusiness.constant = 0
        }
        cell.businessCharges.isHidden = AppUtility.shared.country == .Pakistan ? true : (jobsInProgressRow.is_cz == "0")
        
        let bookedJob_id = jobsInProgressRow.is_booked_job
        
        if bookedJob_id == "1" {
            cell.cancelJobBtn.isHidden = false
            
            let currentBid = jobsInProgressRow.current_bid ?? "0"
            let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
            let doubleValue = Double(x)
            cell.jobPrice.text = "£ "+"\(getDoubleValue(currentBid: Double(currentBid) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
        } else {
            cell.cancelJobBtn.isHidden = true
        }
        
//        if !(AppUtility.shared.country == .Pakistan) {
//        let currentBid = jobsInProgressRow.current_bid ?? "0"
//        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
//        let doubleValue = Double(x)
//        let resultInitialPrice = Double(currentBid)! * Double(doubleValue!/100)
//        self.roundedPrice = Double(resultInitialPrice).rounded(toPlaces: 2)
//        }
        
        cell.startJob = {[weak self] (selectedCell) in
            guard let self = self, let indexPath = tableView.indexPath(for: selectedCell) else { return }
            //            self.goToJobDetail(indexPath: indexPath)
            
            //            self.checkJobStatus(delId: self.jobsInProgressModel[indexPath.row].del_id, indexPath: indexPath)
            self.showStartJobAlertView(delId: self.jobsInProgressModel[indexPath.row].del_id, indexPath: indexPath)
        }
        
        cell.cancelJob = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            jb_id = self.jobsInProgressModel[indexPath.row].jb_id
            self.presentCancelJobView()
        }
        
        return cell
        
    }
    
    func presentCancelJobView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.jobCancel_popview.layer.cornerRadius = 18
            self.tableView.alpha = 0.5
            self.jobCancelReason.text = "Are you sure you want to cancel this job?"
            self.isCancel = true
            self.view.addSubview(self.jobCancel_popview)
            self.jobCancel_popview.center = self.view.center
        })
        
    }
    
    func showStartJobAlertView(delId: String, indexPath: IndexPath) {
 
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.question.text = "Are you sure you want to start this job?"
        aView.ensure.text = ""
        aView.sendPaymentLinkHeight.constant = 0
        aView.sendPaymentLink.isHidden = true
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
        
        aView.yes.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
            self.startBookedJob(delId: delId, indexPath: indexPath)
        }).disposed(by: disposeBag)
        
        aView.no.rx.tap.subscribe(onNext: { (_) in
            aView.removeFromSuperview()
        }).disposed(by: disposeBag)
        
        self.view.addSubview(aView)
    }
    
    func showCompleteAlertView() {
        //            jb_id = self.jobsInProgressModel[indexPath.row].jb_id
        //            self.contact_person = self.jobsInProgressModel[indexPath.row].contact_person
        //            self.contact_no = self.jobsInProgressModel[indexPath.row].contact_phone
        //            self.refference_no = "LOADX"+String(self.year)+"J"+self.jobsInProgressModel[indexPath.row].del_id
        //            self.showCompleteAlertView()
        
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.question.text = "Has the job been completed?"
        aView.ensure.text = "Before continuing ensure you submit the following: \n\n- Name & Signature of Recipient \n- Delivery Image Proof                      "
        aView.sendPaymentLinkHeight.constant = 0
        aView.sendPaymentLink.isHidden = true
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
        
        aView.yes.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
            if let vc = self.sb.instantiateViewController(withIdentifier: "BookJobController") as? BookJobController {
                vc.contact_no = self.contact_no
                vc.ref_no = self.refference_no
                vc.contactName = self.contact_person
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
        
        aView.no.rx.tap.subscribe(onNext: { (_) in
            aView.removeFromSuperview()
        }).disposed(by: disposeBag)
        
        self.view.addSubview(aView)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == routesTableView {
            if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteDetailsViewController") as? RouteDetailsViewController {
                vc.routeId = self.routes[indexPath.row].lr_id
                route_id = self.routes[indexPath.row].lr_id
                vc.isRouteStarted = self.routes[indexPath.row].is_route_started ?? ""
                is_route_started = self.routes[indexPath.row].is_route_started ?? ""
                vc.isBooked = true
                //                self.locationManager.startLocationUpdates()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            
            let jobData = self.jobsInProgressModel[indexPath.row]
            
            if jobData.is_job_started == "1" {
            self.checkJobStatus(delId: jobData.del_id, indexPath: indexPath)
            } else {
                        let percentage = Double(UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25")
                let price = AppUtility.shared.country == .Pakistan ? (AppUtility.shared.currencySymbol+(Int(jobData.transporter_share ?? "")?.withCommas() ?? "0")) : ("£ "+"\(getDoubleValue(currentBid: Double(jobData.current_bid ?? "") ?? 0.0, doubleValue: percentage ?? 0.0))")
          
                        del_id = self.jobsInProgressModel[indexPath.row].del_id
            if let vc = self.sb.instantiateViewController(withIdentifier: "JobDetial_ViewController") as? JobDetial_ViewController {
                           vc.bookedJobPrice = price
                        vc.showHouseNumber = true
            
                        vc.pickupAdd = "\(jobData.pu_house_no ?? "") \(jobData.pick_up)"
                        vc.dropoffAdd = "\(jobData.do_house_no ?? "") \(jobData.drop_off)"
                        self.navigationController?.pushViewController(vc, animated: true)
        }
            }
        }
    }
    @IBAction func jocancel_noBtn_action(_ sender: Any) {
        self.jobCancel_popview.removeFromSuperview()
        self.tableView.alpha = 1
        self.routesTableView.alpha = 1
    }
    @IBAction func jobCancel_YesBtn(_ sender: Any) {
        self.jobCancel_popview.removeFromSuperview()
        self.tableView.alpha = 1
        self.routesTableView.alpha = 1
        if isCancel {
            let vc = self.sb.instantiateViewController(withIdentifier: "jobCancel_ViewController") as! jobCancel_ViewController
            vc.jb_id = jb_id
            vc.isCancel = isCancel
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.sb.instantiateViewController(withIdentifier: "jobCancel_ViewController") as! jobCancel_ViewController
            vc.lr_id = lr_id
            vc.isCancel = isCancel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func jobcomplete_YesBtn(_ sender: Any) {
        self.jobComplete_popview.removeFromSuperview()
        self.tableView.alpha = 1
        let vc = self.sb.instantiateViewController(withIdentifier: "BookJobController") as! BookJobController
        vc.contact_no = contact_no
        vc.ref_no = refference_no
        vc.contactName = contact_person
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func jobComplete_noBtn(_ sender: Any) {
        self.jobComplete_popview.removeFromSuperview()
        self.tableView.alpha = 1
    }
    
    //back function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if let vc = segue.destination as? JobDetailController {
            vc.bookedJobPrice = bookedPrice
        }
    }
    
    //start booked job
    func startBookedJob(delId: String, indexPath: IndexPath) {
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/startBookedJob", parameters: ["del_id": delId]) { [weak self] (_, json, error) in
            guard let self = self else { SVProgressHUD.dismiss(); return }
            SVProgressHUD.dismiss()
            
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            guard let json = json else { return }
            
            let msg = json[0]["msg"].stringValue
            let result = json[0]["result"].stringValue
            
            if result == "1" {
                self.checkJobStatus(delId: delId, indexPath: indexPath)
            } else {
                showAlert(title: "Alert", message: msg, viewController: self)
            }
            
        }
    }
    
    func checkJobStatus(delId: String, indexPath: IndexPath) {
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/jobArrivalInfo", parameters: ["del_id": delId]) { [weak self] (data, json, error) in
            guard let self = self else { SVProgressHUD.dismiss(); return }
            SVProgressHUD.dismiss()
            
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            guard let _ = json, let data = data else { return }
            
            do {
                if let jobStatus = try JSONDecoder().decode([JobStatus].self, from: data).first {
                    self.goToJobDetail(indexPath: indexPath, jobStatus: jobStatus)
                }
            } catch {
                showAlert(title: "Error", message: error.localizedDescription, viewController: self)
            }
            
        }
    }
    
    func goToJobDetail(indexPath: IndexPath, jobStatus: JobStatus) {
        let jobDetailVC = JobPickupDropoffViewController.instantiate()
        let rowData = self.jobsInProgressModel[indexPath.row]
        let pickup = "\(rowData.pu_house_no ?? "") \(rowData.pick_up)"
        let dropoff = "\(rowData.do_house_no ?? "") \(rowData.drop_off)"
        
        let percentage = Double(UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25")
        let jobPrice = AppUtility.shared.country == .Pakistan ? AppUtility.shared.currencySymbol+(Int(rowData.transporter_share ?? "0")?.withCommas() ?? "") : ("£ "+"\(getDoubleValue(currentBid: Double(rowData.current_bid ?? "") ?? 0.0, doubleValue: percentage ?? 0.0))")
        let paymentType = AppUtility.shared.country == .Pakistan ? rowData.job_payment_type : rowData.payment_type
        jobDetailVC.input = .init(pickupAddress: pickup, dropoffAddress: dropoff, customerName: rowData.contact_person.capitalized, customerNumber: rowData.contact_phone, addType: rowData.add_type, delId: rowData.del_id, jbId: rowData.jb_id, paymentType: paymentType == "full" ? .Account : .Cash, jobStatus: jobStatus, jobPrice: jobPrice)
        self.navigationController?.pushViewController(jobDetailVC, animated: true)
    }
}

extension JobsInProgress {
    public func startRoute(lrID: String, isRouteStarted: String) {
        APIManager.apiPost(serviceName: "api/startlRoute", parameters: ["lr_id": lrID]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                
            }
            let msg = json?[0]["msg"].stringValue
            let result = json?[0]["result"].stringValue
            if result == "0" {
                SwiftMessages.show {
                    let view = MessageView.viewFromNib(layout: .centeredView)
                    view.bodyLabel?.text = msg
                    view.button?.setTitle("Okay", for: .normal)
                    view.titleLabel?.isHidden = true
                    view.iconImageView?.isHidden = true
                    view.iconLabel?.isHidden = true
                    view.center = self.view.center
                    return view
                }
                //                self.present(showAlert(title: "Error", message: msg ?? "Error starting route"), animated: true, completion: nil)
            } else {
                self.locationManager.startLocationUpdates()
                self.locationManager.delId = lrID
                self.locationManager.tId = user_id
                self.locationManager.transporterStatus = "Yes"
                if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RouteDetailsViewController") as? RouteDetailsViewController {
                    vc.routeId = lrID /*self.lr_id*/
                    vc.isRouteStarted = isRouteStarted
                    vc.isBooked = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
