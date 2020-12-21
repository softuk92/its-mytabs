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

class JobsInProgress: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    private let disposeBag = DisposeBag()
    var routes = [BookedRoute]()
    var isRouteStarted = ""
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
    @IBOutlet var popupView: UIView!
//    @IBOutlet weak var searchBtn: UIButton!
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
      //  self.title = "Booked Jobs"+" ("+userInprogressJobs+")"
        self.popup_iconView.clipsToBounds = true
        self.popup_iconView.layer.cornerRadius = 18
        self.popup_iconView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        self.Cancel_popup_iconView.clipsToBounds = true
        self.Cancel_popup_iconView.layer.cornerRadius = 18
        self.Cancel_popup_iconView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        stackView.isHidden = true
//        searchBtn.isHidden = true
       
        getBookedJobs(url: "api/transporterInprogresJobs")
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
//        tableView.backgroundColor = UIColor.white
//        tableView.tableHeaderView = topView
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
        
        tableView.register(UINib(nibName: "JobsInProgressCell", bundle: nil) , forCellReuseIdentifier: "jobsInProgress")
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(JobsInProgress.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        
        guard let bookJob = UserDefaults.standard.string(forKey: "Book_job") else { return }
        book_job_lbl.text = "(" + bookJob + ")"
        
        //routes table view
        configureRoutesTableView()
        bindButtons()
        getRoutes()
        routeJobsBtn.alpha = 0.5
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelect), name: NSNotification.Name(rawValue: "didSelect"), object: nil)
    }
    
    @objc func didSelect(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) { [weak self] in
            self?.goToRoute()
            self?.routesTableView.isHidden = false
            self?.stackView.isHidden = true
        }
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
        if isRoute {
            goToRoute()
            self.setConstraints(leadingSearch: false, trailingSearch: false, leadingRoute: true, trailingRoute: true)
        } else {
            self.setConstraints(leadingSearch: true, trailingSearch: true, leadingRoute: false, trailingRoute: false)
        }
        getBookedJobs(url: "api/transporterInprogresJobs")
        getRoutes()
        checkRouteAccess()
    }
    
    func bindButtons() {
        searchJobsBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.isRoute = false
            self?.routesTableView.isHidden = true
            self?.setConstraints(leadingSearch: true, trailingSearch: true, leadingRoute: false, trailingRoute: false)
            self?.topLabel.text = "Booked Jobs"
            self?.routeJobsBtn.alpha = 0.5
            self?.searchJobsBtn.alpha = 1.0
            self?.book_job_lbl.text = self?.searchCount ?? "(0)"
            if (self?.jobsInProgressModel.count ?? 0) > 0 {
            self?.tableView.isHidden = false
            self?.stackView.isHidden = true
            } else {
            self?.stackView.isHidden = false
            self?.tableView.isHidden = true
            self?.noJob_lbl.text = "Currently no booked jobs"
            }
        }).disposed(by: disposeBag)
        
        routeJobsBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            guard let self = self else { return }
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
        }).disposed(by: disposeBag)
        
    }
    
    func goToRoute() {
        self.routeJobsBtn.alpha = 1.0
        self.searchJobsBtn.alpha = 0.5
        self.tableView.isHidden = true
        self.topLabel.text = "Booked Routes"
        self.book_job_lbl.text = self.routeCount ?? "(0)"
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
                print("Booked Route json is \(String(describing: json))")
                self.routeCount = "(\(self.routes.count))"
                self.routesTableView.reloadData()
                self.routeJobsBtn.isUserInteractionEnabled = true
            } catch {
                self.routeJobsBtn.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func populate() {
        
        DispatchQueue.main.async {
//         if self.progressJobs == false {
//            } else {
//           self.getBookedJobs(url: "api/transporterInprogresJobsBusiness")
//            }
            self.getBookedJobs(url: "api/transporterInprogresJobs")
            self.refresher.endRefreshing()
            }
    }
  
    
    func getBookedJobs(url: String) {
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
                        if result == "0" {
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
//                                    self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
                                    self.stackView.isHidden = true
//                                    self.searchBtn.isHidden = true
                                    self.tableView.reloadData()
                                    self.routesTableView.reloadData()
                                }
                            } catch {
                                print(error)
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
        return 311
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
            cell.cancelRoute.rx.tap.subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                self.lr_id = self.routes[indexPath.row].lr_id
                UIView.animate(withDuration: 0.3, animations: {
                    self.jobCancel_popview.layer.cornerRadius = 18
                    self.routesTableView.alpha = 0.5
                    self.jobCancelReason.text = "Are you sure you want to cancel this route?"
                    self.isCancel = false
                    self.view.addSubview(self.jobCancel_popview)
                    self.jobCancel_popview.center = self.view.center
                })
            }).disposed(by: disposeBag)
            
            cell.startRoute.rx.tap.subscribe(onNext: {[weak self] (_) in
                guard let self = self else { return }
                self.startRoute(lrID: self.routes[indexPath.row].lr_id, isRouteStarted: self.routes[indexPath.row].is_route_started ?? "")
            }).disposed(by: disposeBag)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobsInProgress") as! JobsInProgressCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        
        let jobsInProgressRow = jobsInProgressModel[indexPath.row]
        
        cell.innerView.layer.cornerRadius = 10
        cell.jobCompleted_btn.layer.cornerRadius = 10
        cell.jobCompleted_btn.clipsToBounds = true
        cell.jobCompleted_btn.layer.maskedCorners = [ .layerMaxXMaxYCorner]
               
        cell.deletBtnOutlet.layer.cornerRadius = 10
        cell.deletBtnOutlet.clipsToBounds = true
        cell.deletBtnOutlet.layer.maskedCorners = [.layerMinXMaxYCorner]

        let switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
        
        let movingItem = jobsInProgressRow.moving_item
        cell.moving_item.text = movingItem.capitalized
        
        cell.pick_up.text = "\(jobsInProgressRow.pu_house_no ?? "") \(jobsInProgressRow.pick_up)"
        cell.drop_off.text = "\(jobsInProgressRow.do_house_no ?? "") \(jobsInProgressRow.drop_off)"
        
        cell.date.text = convertDateFormatter(jobsInProgressRow.date)
        
            let payment_type = jobsInProgressRow.payment_type
            if  payment_type == "full" {
                if switchCheck == true {
                    cell.payment_method_lbl.text = "Account Job"
                }else{
                    cell.payment_method_lbl.text = "Account Job"
                }
            }else{
                if switchCheck == true {
                     cell.payment_method_lbl.text = "Cash Job"
                }else{
                    cell.payment_method_lbl.text = "Cash Job"
                }
        }

        let is_companyJob = jobsInProgressRow.is_company_job
        
        if is_companyJob == "1" {
            cell.businessPatti.isHidden = false
            cell.widthBusiness.constant = 65
            cell.businessCharges.isHidden = false
        } else {
            cell.businessPatti.isHidden = true
            cell.widthBusiness.constant = 0
            cell.businessCharges.isHidden = true
        }
        
        let bookedJob_id = jobsInProgressRow.is_booked_job
        
        if bookedJob_id == "1" {
        cell.deletBtnOutlet.isHidden = false
       
        let currentBid = jobsInProgressRow.current_bid
        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
        let doubleValue = Double(x)
            cell.jobPrice.text = "£ "+"\(getDoubleValue(currentBid: Double(currentBid) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
        } else {
        cell.deletBtnOutlet.isHidden = true
        }
        
        let currentBid = jobsInProgressRow.current_bid
        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
        let doubleValue = Double(x)
        let resultInitialPrice = Double(currentBid)! * Double(doubleValue!/100)
        self.roundedPrice = Double(resultInitialPrice).rounded(toPlaces: 2)
                
        cell.detailJobRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            protected = true
            let bookedJob_id = jobsInProgressRow.is_booked_job
            
            if bookedJob_id == "1" {
                bookedPriceBool = true
                let currentBid2 = jobsInProgressRow.current_bid
                let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
                let doubleValue = Double(x)
                self.bookedPrice = "£ "+"\(getDoubleValue(currentBid: Double(currentBid2) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
                del_id = jobsInProgressRow.del_id
                let vc = self.sb.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
                vc.bookedJobPrice = self.bookedPrice
                vc.showHouseNumber = true
                vc.pickupAdd = cell.pick_up.text
                vc.dropoffAdd = cell.drop_off.text
                self.navigationController?.pushViewController(vc, animated: true)
//                self.performSegue(withIdentifier: "detail", sender: self)
            } else {
                del_id = jobsInProgressRow.del_id
                let vc = self.sb.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
                vc.bookedJobPrice = self.bookedPrice
                vc.showHouseNumber = true
                vc.pickupAdd = cell.pick_up.text
                vc.dropoffAdd = cell.drop_off.text
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        cell.completeJobRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
           
            jb_id = self.jobsInProgressModel[indexPath.row].jb_id
            self.contact_person = self.jobsInProgressModel[indexPath.row].contact_person
            self.contact_no = self.jobsInProgressModel[indexPath.row].contact_phone
            self.refference_no = "LOADX"+String(self.year)+"J"+self.jobsInProgressModel[indexPath.row].del_id
            self.showCompleteAlertView()
//            UIView.animate(withDuration: 0.3, animations: {
//                    self.jobComplete_popview.layer.cornerRadius = 18
//                    self.tableView.alpha = 0.5
//                    self.view.addSubview(self.jobComplete_popview)
//                    self.jobComplete_popview.center = self.view.center
//                      })
           
            }
        
        cell.deleteRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            jb_id = self.jobsInProgressModel[indexPath.row].jb_id

            UIView.animate(withDuration: 0.3, animations: {
                        self.jobCancel_popview.layer.cornerRadius = 18
                        self.tableView.alpha = 0.5
                        self.jobCancelReason.text = "Are you sure you want to cancel this job?"
                        self.isCancel = true
                        self.view.addSubview(self.jobCancel_popview)
                        self.jobCancel_popview.center = self.view.center
            })
        }
    
        
        cell.callRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            let callNumber = self.jobsInProgressModel[indexPath.row].contact_phone
            if callNumber != "" {
                if let url = URL(string: "tel://\(callNumber)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
        
        cell.emailRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            let email = self.jobsInProgressModel[indexPath.row].contact_mail
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
        cell.transporterProfileRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            transporter_id = self.jobsInProgressModel[indexPath.row].user_id
            self.performSegue(withIdentifier: "transporter", sender: self)
        }
        
        return cell
        
    }
    
    func showCompleteAlertView() {
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
                vc.isRouteStarted = self.routes[indexPath.row].is_route_started ?? ""
                vc.isBooked = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
        
        protected = true
        let cell = tableView.cellForRow(at: indexPath) as! JobsInProgressCell
        let bookedJob_id = self.jobsInProgressModel[indexPath.row].is_booked_job
        
        if bookedJob_id == "1" {
            bookedPriceBool = true
            let currentBid2 = self.jobsInProgressModel[indexPath.row].current_bid
            let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
            let doubleValue = Double(x)
            let resultInitialPrice2 = Double(currentBid2)! * Double(doubleValue!/100)
            self.roundedPrice = Double(resultInitialPrice2).rounded(toPlaces: 2)
            let resultRemaining2 = Double(currentBid2)! - self.roundedPrice
            self.bookedPrice = "£"+"\(resultRemaining2)"
            del_id = self.jobsInProgressModel[indexPath.row].del_id
            let vc = self.sb.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
               vc.bookedJobPrice = bookedPrice
            vc.showHouseNumber = true
            vc.pickupAdd = cell.pick_up.text
            vc.dropoffAdd = cell.drop_off.text
        self.navigationController?.pushViewController(vc, animated: true)
        } else {
            del_id = self.jobsInProgressModel[indexPath.row].del_id
            let vc = self.sb.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
               vc.bookedJobPrice = bookedPrice
            vc.showHouseNumber = true
            vc.pickupAdd = cell.pick_up.text
            vc.dropoffAdd = cell.drop_off.text
            self.navigationController?.pushViewController(vc, animated: true)
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
    
    
    @IBOutlet weak var myImage1: UIImageView!
    @IBOutlet weak var receiverName: UITextField!
    @IBAction func selectImage(_ sender: UIButton) {
        imagePick(sender: sender.tag)
    }
    
    func imagePick(sender: Int) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        //2
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicked = sender
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera Not Available")
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicked = sender
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = self.view;
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 800, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let packedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if imagePicked == 1 {
            self.myImage1.image = packedImage
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        completeJobData()
    }
    
    func completeJobData() {
        SVProgressHUD.show(withStatus: "Completing Job...")
        if user_id != nil && jb_id != nil {
            let updateBid_URL = main_URL+"api/transporterCompleteJobData"
            let parameters = ["jb_id" : jb_id!, "user_id" : user_id!, "receivername" : self.receiverName.text!]
            if imagePicked == 1 {
                var image1 = myImage1.image
                image1 = image1?.resizeWithWidth(width: 500)
                imageData1 = image1?.jpegData(compressionQuality: 0.2)
            }
            
            Alamofire.upload(multipartFormData: {
                (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if self.imagePicked == 1 {
                    multipartFormData.append(self.imageData1!, withName: "delprofimg", fileName: "swift_file1.jpeg", mimeType: "image/jpeg")
                }
            }, to:updateBid_URL)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
//                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        if response.result.value != nil {

                            let jsonData : JSON = JSON(response.result.value!)
                            print("JSON: \(jsonData)")
                            let result = jsonData[0]["result"].stringValue
                            let message = jsonData[0]["message"].stringValue
                            SVProgressHUD.dismiss()
                            if result == "1" {
                                let vc = self.sb.instantiateViewController(withIdentifier: "completedJob") as! SuccessController
                            self.navigationController?.pushViewController(vc, animated: true)
                                
                            } else {
                                self.present(showAlert(title: "Alert", message: message), animated: true, completion: nil)
                            }
                        } else {
                            SVProgressHUD.dismiss()
                            self.present(showAlert(title: "Error", message: response.result.error?.localizedDescription ?? ""), animated: true, completion: nil)
                        }
                    }
                    
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                    SVProgressHUD.dismiss()
                    self.present(showAlert(title: "Error", message: encodingError.localizedDescription), animated: true, completion: nil)
                }
            }
        } else {
            SVProgressHUD.dismiss()
            self.present(showAlert(title: "Alert", message: "Please enter receiver name / upload proof image"), animated: true, completion: nil)
        }
    }
    
    @IBAction func crosssBtn(_ sender: Any) {
        popupView.removeFromSuperview()
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
}

extension JobsInProgress {
    public func startRoute(lrID: String, isRouteStarted: String) {
        APIManager.apiPost(serviceName: "api/startlRoute", parameters: ["lr_id": lrID]) { (data, json, error) in
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
