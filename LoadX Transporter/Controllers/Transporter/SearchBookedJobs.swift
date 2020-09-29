//
//  SearchBookedJobs.swift
//  CTS Move Transporter
//
//  Created by Fahad Baig on 20/05/2019.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import SDWebImage
import DropDown
import IBAnimatable
import GoogleMaps
import GooglePlaces
import CoreLocation

var bookedPriceBool : Bool?

class SearchBookedJobs: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    lazy var searchBookModel = [SearchBookedJobsModel]()
    var locationPicked = 0
    var pickup_city = ""
    var dropoff_city = ""
    var menuShowing = false
    var HEADER_HEIGHT = 0
    var bookedPrice : String?
    var roundedPrice: Double = 0.0
    var SearchListJob : Bool?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var pickupLocation: UITextField!
    @IBOutlet weak var dropOff: UITextField!
    @IBOutlet weak var selectCategory: iOSDropDown!
    @IBOutlet weak var keywords: AnimatableTextField!
    @IBOutlet weak var pickup_radius: iOSDropDown!
    
    @IBOutlet weak var searchFilter: UIView!
     
    @IBOutlet var parentView: UIView!
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var jobPrice: UILabel!
    @IBOutlet var popUpView: UIView!
    @IBOutlet var popUpView2: UIView!
    
    @IBOutlet weak var logoView_popview: UIView!
    @IBOutlet weak var logoView_popView1: UIView!
    
    
    @IBOutlet weak var unique_id: UITextField!
    @IBOutlet weak var businessJobPrice: UILabel!
    @IBOutlet weak var no_data_image: UIImageView!
  /*  @IBOutlet weak var search_filter_btn: UIButton!
    @IBOutlet weak var searchfliter_img: UIImageView!
    @IBOutlet weak var searchJob_btn: UIButton!
    @IBOutlet weak var searchfliterIcon_img: UIImageView! */
    @IBOutlet weak var noJobRecordFound_lable: UILabel!
    @IBOutlet weak var popup_lable: UILabel!
    @IBOutlet weak var popup_yes_btn: UIButton!
    @IBOutlet weak var popup_no_btn: UIButton!
    @IBOutlet weak var popup2_lbl: UILabel!
    @IBOutlet weak var popup2_yes_btn: UIButton!
    @IBOutlet weak var popup2_no_btn: UIButton!
    @IBOutlet weak var searchCount_job_lbl: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    
    let categoryList = ["Small Van",
    "Medium Van",
    "Large Van",
    "Luton Van",
    "Rubbish Removal Truck",
    "3.5 Ton Vehicle Recovery Truck",
    "7.5 Ton Vehicle Recovery Truck",
    "7.5 Ton Truck",
    "Container Truck",
    "Other"]
    let radiusList = ["20 Miles", "40 Miles", "60 Miles", "80 Miles", "100 Miles"]
    
    var pageNumber = 1
    var isLoading = false
    var puStreet_Route = ""
    var pu_City_Route = ""
    var pu_allAddress = ""
    var doStreet_Route = ""
    var do_City_Route = ""
    var do_allAddress = ""
    var refresher: UIRefreshControl!
    let picker = UIDatePicker()
    var vehicleType = ""
    var searchCount : String?
    var blurView: UIVisualEffectView?
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        SearchListJob = false
//        self.title = "Search Jobs"
     
        pickupLocation.delegate = self
        dropOff.delegate = self
        selectCategory.delegate = self
        pickup_radius.delegate = self
        searchFilter.isHidden = true
        keywords.delegate = self
    
        createDatePicker()
        
      selectCategory.optionArray = categoryList
        selectCategory.isSearchEnable = false
      
        if #available(iOS 13.0, *) {
                  if UITraitCollection.current.userInterfaceStyle == .dark  {
                      selectCategory.rowBackgroundColor = UIColor.secondarySystemBackground
                      selectCategory.arrowSize = 17.0
                      selectCategory.arrow.backgroundColor = .gray
                      
                      pickup_radius.rowBackgroundColor = UIColor.secondarySystemBackground
                      pickup_radius.arrow.backgroundColor = .gray
                      pickup_radius.arrowSize = 17.0
                 
                  }
              } else {
                  // Fallback on earlier versions
              }
//        NotificationCenter.default.addObserver(self, selector: #selector(self.searchChange(notification:)), name: Notification.Name("SearchBarSelect"), object: nil)

        selectCategory.didSelect{(selectedText , index ,id) in
            self.selectCategory.text = selectedText
            
            
        }
       
        
        pickup_radius.optionArray = radiusList
        pickup_radius.isSearchEnable = false
        
        pickup_radius.didSelect{(selectedText , index ,id) in
            self.pickup_radius.text = selectedText
        }
          
        searchDeliveriesFunc {
            
            if self.searchBookModel.isEmpty {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                self.stackView.isHidden = false
//                self.tableView.backgroundView = UIColor.
            } else {
                SVProgressHUD.dismiss()
                self.stackView.isHidden = true
                self.tableView.reloadData()
              
            }
        }
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
//        self.topView.backgroundColor = UIColor.blue
//        tableView.tableHeaderView = topView
        tableView.tableHeaderView?.frame.size = CGSize(width:tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
        tableView.register(UINib(nibName: "SearchDeliveriesCell", bundle: nil) , forCellReuseIdentifier: "allDeliveries")
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(SearchDeliveriesController.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        
//        popup_yes_btn.layer.masksToBounds = true
//        popup_no_btn.layer.masksToBounds = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
//                searchDeliveriesFunc {
//                    
//                    if self.searchBookModel.isEmpty {
//                        SVProgressHUD.dismiss()
//                        self.tableView.reloadData()
//                        self.stackView.isHidden = false
//        //                self.tableView.backgroundView = UIColor.
//                    } else {
//                        SVProgressHUD.dismiss()
//                        self.stackView.isHidden = true
//                        self.tableView.reloadData()
//                      
//                    }
//                }
//        print("search job relaod..... n\n/")
    }
 
    @objc  func searchChange(notification: NSNotification) {
                let x = appDelegate.searchBtn_bool
                if x == true {
                    self.navigationController?.view.addSubview(self.searchFilter)
                    self.searchFilter.frame.size.height = (self.navigationController?.view.bounds.height)!
                    self.searchFilter.frame.size.width = (self.navigationController?.view.bounds.width)!
                    self.searchFilter.alpha = 0.0
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        self.searchFilter.layer.borderColor = UIColor.gray.cgColor
                        self.searchFilter.layer.borderWidth = 1
                        self.searchFilter.layer.cornerRadius = 5
                        self.searchFilter.isHidden = false
                        self.searchFilter.alpha = 1.0
                        //self.searchFilter.pinEdges(to: self.parentView)
                        self.view.addSubview(self.searchFilter)
                        self.searchFilter.center = self.view.center
                    })
                      
                    print("this is search button press for showing search filter view")
                } else{
                    print("this is main search list ")
                }

    }
    @IBAction func searchFilter_action(_ sender: Any) {
        self.navigationController?.view.addSubview(self.searchFilter)
        self.searchFilter.frame.size.height = (self.navigationController?.view.bounds.height)!
        self.searchFilter.frame.size.width = (self.navigationController?.view.bounds.width)!
        self.searchFilter.alpha = 0.0
        
   UIView.animate(withDuration: 0.3, animations: {
       self.searchFilter.layer.borderColor = UIColor.gray.cgColor
       self.searchFilter.layer.borderWidth = 1
       self.searchFilter.layer.cornerRadius = 5
       self.searchFilter.isHidden = false
       self.searchFilter.alpha = 1.0
       //self.searchFilter.pinEdges(to: self.parentView)
       self.view.addSubview(self.searchFilter)
       self.searchFilter.center = self.view.center
   })
        
    }
    
    @objc func populate() {
        pickupLocation.text = ""
        dropOff.text = ""
        selectCategory.text = ""
        keywords.text = ""
        pickup_radius.text = ""
        searchDeliveriesFunc {
            if  self.searchBookModel.isEmpty {
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                self.stackView.isHidden = false
//                self.tableView.backgroundView = nil
            } else {
                SVProgressHUD.dismiss()
                self.stackView.isHidden = true
                self.tableView.reloadData()
//                self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
            }
        }
        self.refresher.endRefreshing()
    }
    
    @IBAction func SearchFliter_back_Action(_ sender: Any) {
        self.searchFilter.removeFromSuperview()
        self.searchFilter.isHidden = true
         self.searchFilter.alpha = 0.0
    }
    
    @IBAction func viewAll_job(_ sender: Any) {

                searchDeliveriesFunc {
                    
                    if self.searchBookModel.isEmpty {
                        SVProgressHUD.dismiss()
                        self.tableView.reloadData()
                        self.stackView.isHidden = false
        //                self.tableView.backgroundView = UIColor.
                    } else {
                        SVProgressHUD.dismiss()
                        self.stackView.isHidden = true
                        self.tableView.reloadData()
                      
                    }
                }
        self.searchFilter.removeFromSuperview()
               self.searchFilter.isHidden = true
                self.searchFilter.alpha = 0.0
    }
    
      @IBAction func searchFilterBtn(_ sender: Any) {

        if  searchBookModel.count < 1 {
             self.stackView.isHidden = false
        }else{
            self.stackView.isHidden = true
        }
       
    }
    
    func dropDownFunc() {
        if menuShowing == false {
            if ( UI_USER_INTERFACE_IDIOM() == .pad )
                {
                    UIView.animate(withDuration: 0.1, animations: {
    //                    self.searchFilter.isHidden = false
                        self.menuShowing = true
                        self.HEADER_HEIGHT = 745
//                        self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
//                        self.tableView.tableHeaderView = self.topView
                        self.tableView.layoutIfNeeded()
                        
                        self.view.layoutIfNeeded()
                    })
                } else {
                UIView.animate(withDuration: 0.1, animations: {
//                  self.searchFilter.isHidden = false
                    self.menuShowing = true
//                    self.HEADER_HEIGHT = 745
//                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
//                    self.tableView.tableHeaderView = self.topView
//                    self.tableView.layoutIfNeeded()

                    self.view.layoutIfNeeded()
                })
            }
            
        } else if menuShowing == true {
            if ( UI_USER_INTERFACE_IDIOM() == .pad )
            {
                UIView.animate(withDuration: 0.1, animations: {
//                    self.searchFilter.isHidden = true
                    self.menuShowing = false
//                    self.HEADER_HEIGHT = 300
//
//                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
//                    self.tableView.tableHeaderView = self.topView
//                    self.tableView.layoutIfNeeded()
//
                   
                    self.view.layoutIfNeeded()
                    })
            } else {
            UIView.animate(withDuration: 0.1, animations: {
//                self.searchFilter.isHidden = true
                self.menuShowing = false
//                self.HEADER_HEIGHT = 220
//
//                self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
//                self.tableView.tableHeaderView = self.topView
//                self.tableView.layoutIfNeeded()
//
                self.view.layoutIfNeeded()
            })
        }
        }
    }
    
    //MARK: - Pickuplocation for UITEXTFIELD
    /***************************************************************/
    
    @IBAction func pickupLocationButton(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "UK"
        autocompleteController.autocompleteFilter = filter
        locationPicked = sender.tag
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func dropOffLocation(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "UK"
        autocompleteController.autocompleteFilter = filter
        locationPicked = sender.tag
        present(autocompleteController, animated: true, completion: nil)
    }
    
    //back function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if let vc = segue.destination as? JobDetial_ViewController {
            vc.bookedJobPrice = bookedPrice
//            vc.searchJobDetail = true
        }
    }
    
    //MARK: - Function of Search Deliveries
    /***************************************************************/
    
    func searchDeliveriesFunc(completed: @escaping () -> ()) {
        SVProgressHUD.show(withStatus: "Getting Jobs...")
        let url = URL(string: main_URL+"api/SearchBookedJobs")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.searchBookModel.removeAll()
                    self.searchBookModel = try JSONDecoder().decode([SearchBookedJobsModel].self, from: data!)
                    SVProgressHUD.dismiss()
                    print("Search all jobs json is \(self.searchBookModel)")
                    
                    self.searchCount = String(self.searchBookModel.count)
                    
                    
                    
                    DispatchQueue.main.async {
                        completed()
                        self.searchCount_job_lbl.text = "(" + String(self.searchBookModel.count) + ")"
                        SVProgressHUD.dismiss()
                    }
                } catch {
                    SVProgressHUD.dismiss()
                    print(error)
                    DispatchQueue.main.async {
                        self.stackView.isHidden = false
//                        self.tableView.backgroundView = nil
                    }
                    
                }
            }
            }.resume()
        
       
    }
    
    //MARK: - UITABLEVIEW Delegate methods
    /***************************************************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (pageNumber * 10 > searchBookModel.count) {
            return searchBookModel.count
        } else {
            return pageNumber * 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 236
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 0 {
            let indexPath = IndexPath(row: searchBookModel.count-1, section: 0)
            
            if indexPath.row == searchBookModel.count - 1 {
                pageNumber = pageNumber + 1
                self.spinner.isHidden = false
                self.spinner.startAnimating()
                self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
            }
        }
    }
    
    @objc func loadTable() {
        self.tableView.reloadData()
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allDeliveries") as! SearchDeliveriesCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        cell.layer.shadowRadius = 10
        cell.innerView.layer.cornerRadius = 10
        
        
        cell.bidNowBtn.layer.cornerRadius = 10
        cell.bidNowBtn.clipsToBounds = true
        cell.bidNowBtn.layer.maskedCorners = [ .layerMaxXMaxYCorner  ]
        
        cell.Dates_View.layer.cornerRadius = 10
        cell.Dates_View.clipsToBounds = true
        cell.Dates_View.layer.maskedCorners = [ .layerMinXMaxYCorner]
       
        
        
        let searchDeliveriesRow = searchBookModel[indexPath.row]
        
        let companyJob = searchDeliveriesRow.is_company_job
        
        if companyJob == "1" {
            cell.businessPatti.isHidden = false
        } else {
            cell.businessPatti.isHidden = true
        }
        let movingItem = searchDeliveriesRow.moving_item
        cell.moving_item.text = movingItem.capitalized
        cell.dropOffLabel.text = searchDeliveriesRow.drop_off
        let vanType = searchDeliveriesRow.SVehicle
        if vanType == "SWB Van" {
            cell.quotes.text = "Small Van"
        } else if vanType == "MWB Van" {
            cell.quotes.text = "Medium Van"
        } else if vanType == "LWB Van" {
            cell.quotes.text = "Large Van"
        } else {
            cell.quotes.text = vanType
        }
//        cell.quotesOutlet.text = "Van Type"
        
        let puStreet = searchDeliveriesRow.pu_street
        let puRoute = searchDeliveriesRow.pu_route
        let puCity = searchDeliveriesRow.pu_city
        let puPostCode = searchDeliveriesRow.pu_post_code
        
        if puStreet != "" || puRoute != "" {
            puStreet_Route = puStreet+" "+puRoute+","
            cell.pickupLabel.text = puStreet
        } else {
            puStreet_Route = ""
        }
        if puCity != "" {
            pu_City_Route = puStreet_Route+" "+puCity+","
            cell.pickupLabel.text = pu_City_Route
        } else {
            pu_City_Route = puStreet_Route
        }
        if puPostCode != "" {
            let spaceCount = puPostCode.filter{$0 == " "}.count
            if spaceCount > 0 {
                if let first = puPostCode.components(separatedBy: " ").first {
                    pu_allAddress = pu_City_Route+" "+first
                    cell.pickupLabel.text = pu_allAddress
                }
            } else if spaceCount == 0 {
                pu_allAddress = pu_City_Route+" "+puPostCode
                cell.pickupLabel.text = pu_allAddress
            }
        }
        
        let doStreet = searchDeliveriesRow.do_street
        let doRoute = searchDeliveriesRow.do_route
        let doCity = searchDeliveriesRow.do_city
        let doPostCode = searchDeliveriesRow.do_post_code
        
        if doStreet != "" || doRoute != "" {
            doStreet_Route = doStreet+" "+doRoute+","
            cell.dropOffLabel.text = doStreet
        } else {
            doStreet_Route = ""
        }
        if doCity != "" {
            do_City_Route = doStreet_Route+" "+doCity+","
            cell.dropOffLabel.text = do_City_Route
        } else {
            do_City_Route = doStreet_Route
        }
        if doPostCode != "" {
            let spaceCount = doPostCode.filter{$0 == " "}.count
            if spaceCount > 0 {
                if let first = doPostCode.components(separatedBy: " ").first {
                    do_allAddress = do_City_Route+" "+first
                    cell.dropOffLabel.text = do_allAddress
                }
            } else if spaceCount == 0 {
                do_allAddress = do_City_Route+" "+doPostCode
                cell.dropOffLabel.text = do_allAddress
            }
        }
        let stringDate3 = searchDeliveriesRow.job_posted_date
          cell.postedDateLabel.text = stringDate3
       
       
        
        
        let stringDate2 = searchDeliveriesRow.date
        let convertedDate2 = self.convertDateFormatter(stringDate2)
        cell.deliveryDateLabel.text = convertedDate2
        
        let currentBid = searchDeliveriesRow.price
//        let allJobs = String(searchDeliveriesRow.alljobs)
//        let allTransporters = String(searchDeliveriesRow.allTransporter)
        
//        self.availableJobs.text = allJobs
//        self.transporterPartners.text = allTransporters
//        cell.lowestBidOutlet.text = "Job Price"
        cell.bidNowBtn.setTitle("Accept Job", for: .normal)
       
        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
        let  doubleValue = Double(x)
        if currentBid != "NoBid" {
            cell.lowest_bid.text = "£ "+"\(getDoubleValue(currentBid: Double(currentBid) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
        } else {
            cell.lowest_bid.text = "N/A"
        }
        
        cell.bidNowRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            if user_id != nil {
                if ic_status == "pending" || dl_status == "pending" {
                    let alert = UIAlertController(title: "Alert!", message: "Please wait for documents approval", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else if ic_status == "Reject" || dl_status == "Reject" || ic_status == "" || dl_status == "" {
                    let alert = UIAlertController(title: "Alert!", message: "Please upload your documents.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Upload Documents", style: .default, handler: { (action: UIAlertAction!) in

                        self.performSegue(withIdentifier: "edit", sender: self)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        print("Handle Cancel Logic here")
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if companyJob == "1" {
                    del_id = self.searchBookModel[indexPath.row].del_id
                        let currentPrice = cell.lowest_bid.text
                        self.businessJobPrice.text = currentPrice
                        UIView.animate(withDuration: 0.3, animations: {
//                            self.popUpView2.layer.borderColor = UIColor.gray.cgColor
//                            self.popUpView2.layer.borderWidth = 1
                            self.popUpView2.layer.cornerRadius = 25
//                            self.tableView.alpha = 0.5
                            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
                            let blurEffectView = UIVisualEffectView(effect: blurEffect)
                             blurEffectView.frame = self.view.bounds
                             blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                            self.view.addSubview(blurEffectView)

                            self.logoView_popview.layer.cornerRadius = 25
                            self.logoView_popview.clipsToBounds = true
                            self.logoView_popview.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
//                            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
//                            self.blurView?.effect = blurEffect
//                            self.view.addSubview(self.blurView!)
                            self.view.addSubview(self.popUpView2)
                            self.popUpView2.center = self.view.center

                        })
                    } else {
                    del_id = self.searchBookModel[indexPath.row].del_id
                    let currentPrice = cell.lowest_bid.text
                    self.jobPrice.text = currentPrice
                        self.timeLabel.text = self.searchBookModel[indexPath.row].timeslot
                        self.dateLabel.text = self.convertDateFormatter2(self.searchBookModel[indexPath.row].date)
                   
                    UIView.animate(withDuration: 0.3, animations: {
                      //  self.popUpView.layer.borderColor = UIColor.gray.cgColor
                     //   self.popUpView.layer.borderWidth = 1
                        self.popUpView.layer.cornerRadius = 25
//                        self.tableView.alpha = 0.5
                        
                       let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
                       let blurEffectView = UIVisualEffectView(effect: blurEffect)
                        blurEffectView.frame = self.view.bounds
                       blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                        self.view.addSubview(blurEffectView)
                        
                        self.logoView_popView1.layer.cornerRadius = 25
                        self.logoView_popView1.clipsToBounds = true
                        self.logoView_popView1.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
            
                        self.view.addSubview(self.popUpView)
                        self.popUpView.center = self.view.center

                    })
                    }
                }

            } else {
                let refreshAlert = UIAlertController(title: "Alert", message: "Please login/signup to book this job", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action: UIAlertAction!) in

                    self.performSegue(withIdentifier: "login", sender: self)
                }))

                refreshAlert.addAction(UIAlertAction(title: "Signup", style: .default, handler: { (action: UIAlertAction!) in
                    self.performSegue(withIdentifier: "signup", sender: self)
                }))

                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    print("Handle Cancel Logic here")
                }))

                self.present(refreshAlert, animated: true, completion: nil)
            }
        }
        
        cell.getDetail = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            bookedPriceBool = true
            let currentBid2 = self.searchBookModel[indexPath.row].price
            let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
            let doubleValue = Double(x)
            self.bookedPrice = "£ "+"\(getDoubleValue(currentBid: Double(currentBid2) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
            del_id = self.searchBookModel[indexPath.row].del_id
            //self.performSegue(withIdentifier: "detail", sender: self)
            self.SearchListJob = true
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobDetial_ViewController") as? JobDetial_ViewController
            vc?.bookedJobPrice = self.bookedPrice
            vc?.selectSearchJob = self.SearchListJob
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        //image Download
        let image_cell1 = searchDeliveriesRow.image1
        let image_cell2 = searchDeliveriesRow.image2
        let image_cell3 = searchDeliveriesRow.image3
        
        if image_cell1 != nil && image_cell1 != "" {
            let urlString = main_URL+"assets/job_images/"+image_cell1!
            if let url = URL(string: urlString) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                    //                        print(received, expected)
                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                    if let imageCell = imageReceived {
                        cell.image1.image = imageCell
                    }
                }
            }
            
        } else if image_cell2 != nil && image_cell2 != "" {
            let urlString = main_URL+"assets/job_images/"+image_cell2!
            if let url = URL(string: urlString) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                    //                        print(received, expected)
                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                    if let imageCell = imageReceived {
                        cell.image1.image = imageCell
                    }
                }
            }
        } else if image_cell3 != nil && image_cell3 != "" {
            let urlString = main_URL+"assets/job_images/"+image_cell3!
            if let url = URL(string: urlString) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                    //                        print(received, expected)
                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                    if let imageCell = imageReceived {
                        cell.image1.image = imageCell
                    }
                }
            }
        } else {
            let imageCell = UIImage(named: "notfound")
            cell.image1.image = imageCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        del_id = self.searchBookModel[indexPath.row].del_id
        bookedPriceBool = true
        let currentBid2 = self.searchBookModel[indexPath.row].price
        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
        let doubleValue = Double(x)
        let resultInitialPrice2 = Double(currentBid2)! * Double(doubleValue!/100)
//        let resultInitialPrice2 = Double(currentBid2)! * Double(0.25)
        self.roundedPrice = Double(resultInitialPrice2).rounded(toPlaces: 2)
        let resultRemaining2 = Double(currentBid2)! - self.roundedPrice
        self.bookedPrice = "£"+"\(resultRemaining2)"
       // self.performSegue(withIdentifier: "detail", sender: self)
      
        self.SearchListJob = true
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "JobDetial_ViewController") as? JobDetial_ViewController
        vc?.bookedJobPrice = bookedPrice
        vc?.selectSearchJob = SearchListJob
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func bookedJobFunc() {
    SVProgressHUD.show(withStatus: "Please wait...")
    if user_id != nil && del_id != nil && user_email != nil {
    let forgetPassword_URL = main_URL+"api/GetBookedJob"
        let parameters : Parameters = ["user_id" : user_id!, "user_email" : user_email!, "del_id" : del_id!]
    if Connectivity.isConnectedToInternet() {
    Alamofire.request(forgetPassword_URL, method : .post, parameters : parameters).responseJSON {
    response in
    if response.result.isSuccess {
    SVProgressHUD.dismiss()
    
    let jsonData : JSON = JSON(response.result.value!)
    print("booked job jsonData is \(jsonData)")
    let result = jsonData[0]["result"].stringValue
    let message = jsonData[0]["message"].stringValue
    
    if result == "false" && message == "All fields are required." {
    let alert = UIAlertController(title: "Alert", message: "Email is incorrect.", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
    } else {
           let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "jobBooked_successController") as? SuccessController
         self.navigationController?.pushViewController(vc!, animated: true)
        
//    self.performSegue(withIdentifier: "success", sender: self)
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
    
    func bookedJobFunc2() {
        SVProgressHUD.show(withStatus: "Please wait...")
        if user_id != nil && del_id != nil && user_email != nil && unique_id.text != "" {
            let forgetPassword_URL = main_URL+"api/GetBookedJob"
            let parameters : Parameters = ["user_id" : user_id!, "user_email" : user_email!, "del_id" : del_id!, "uniq_id" : self.unique_id.text!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(forgetPassword_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("booked job jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        let message = jsonData[0]["message"].stringValue
                        
                        if result == "0" || message == "All fields are required." {
                            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "jobBooked_successController") as? SuccessController
                            self.navigationController?.pushViewController(vc!, animated: true)
                                  
                            
//                            self.performSegue(withIdentifier: "success", sender: self)
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
            let alert = UIAlertController(title: "Error!", message: "Please enter unique id...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- search jobs
    
    @IBAction func searchJobs(_ sender: Any) {
        searchJobsFunc()
    }
    
    func searchJobsFunc() {
        SVProgressHUD.show(withStatus: "Search Jobs...")
        
        if selectCategory.text == "Small Van"{
                   self.vehicleType = "SWB Van"
               }else if selectCategory.text == "Medium Van"{
                   self.vehicleType = "MWB Van"
               }else if selectCategory.text == "Large Van"{
                   self.vehicleType = "LWB Van"
               }else if selectCategory.text == "Luton Van"{
                   self.vehicleType = "Luton Van"
               }else if selectCategory.text == "Rubbish Removal Truck"{
                   self.vehicleType = "Rubbish Removal Truck"
               }else if selectCategory.text == "3.5 Ton Vehicle Recovery Truck"{
                   self.vehicleType = "3.5 Ton Vehicle Recovery Truck"
               }else if selectCategory.text == "7.5 Ton Truck"{
                   self.vehicleType = "7.5 Ton Truck"
               }else if selectCategory.text == "7.5 Ton Vehicle Recovery Truck"{
                   self.vehicleType = "7.5 Ton Vehicle Recovery Truck"
               }else if selectCategory.text == "Container Truck"{
                   self.vehicleType = "Container Truck"
               }else if selectCategory.text == "Other"{
                   self.vehicleType = "Other"
            }
        
        
        let search_job_url = main_URL+"api/SearchBookedJobs"
        
        var SearchParameter : Parameters = [:]
       
        if self.pickup_radius.text != "" {
            SearchParameter = ["pickup_location" : pickupLocation.text!, "dropof_location" :  dropOff.text!, "vehicle_type" : vehicleType, "del_date" : keywords.text!, "radious" : self.pickup_radius.text!, "latitude" : ""  , "longititude" : ""]
            //String(currentCoordinate.latitude), "longititude" : String(currentCoordinate.longitude)
        }else{
            SearchParameter = ["pickup_location" : pickupLocation.text!, "dropof_location" : dropOff.text!, "vehicle_type" : vehicleType, "del_date" : keywords.text! , "radious" : "", "latitude" : ""  , "longititude" : "" ]
        }
         
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(search_job_url, method : .post, parameters : SearchParameter).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        self.searchBookModel.removeAll()
//                         let jsonData = response.result.value
                        let jsonData : JSON = JSON(response.result.value!)
                        print("Search Jobs json Data is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        let message = jsonData[0]["message"].stringValue
                        
                        if result == "0" {
                            self.tableView.reloadData()
                            if self.menuShowing == false{
                            self.stackView.isHidden = false
                            }else{
                                self.stackView.isHidden = true
                            }
                            self.tableView.backgroundView = nil
                            SVProgressHUD.showError(withStatus: message)
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.searchBookModel = try JSONDecoder().decode([SearchBookedJobsModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    print(self.searchBookModel)
//
//                                    for items in self.searchBookModel {
//                                        self.availableJobs.text = String(items.alljobs)
//                                        self.transporterPartners.text = String(items.allTransporter)
//                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.stackView.isHidden = true
                                        self.searchFilter.removeFromSuperview()
                                        self.searchFilter.isHidden = true
                                        self.searchFilter.alpha = 0.0
                                        
                                        self.tableView.reloadData()
//                                        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
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
    }
   
    func convertDateFormatter(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
    public func convertDateFormatter2(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
    //MARK: - Function for UIDatepicker
    /***************************************************************/
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        keywords.inputAccessoryView = toolbar
        keywords.inputView = picker
        picker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: picker.date)
        keywords.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    @IBAction func yesBtn(_ sender: Any) {
    bookedJobFunc()
    }
    
    @IBAction func yesBtn2(_ sender: Any) {
        bookedJobFunc2()
    }
    
    @IBAction func NoBtn(_ sender: Any) {
//        self.tableView.alpha = 1
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        self.blurView?.effect = blurEffect
       
        for subview in self.view.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        self.popUpView.removeFromSuperview()
        self.popUpView2.removeFromSuperview()
//        self.view.willRemoveSubview(self.blurView!)
//
    }
    
}

//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension SearchBookedJobs: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewConqtroller: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if locationPicked == 1 {
//            print("Place name: \(place.name)")
            dismiss(animated: true, completion: nil)
            pickupLocation.text = place.formattedAddress
           
            if let placeFormat = place.formattedAddress {
                self.pickup_city = placeFormat
            }
            let lat = place.coordinate.latitude
            let lon = place.coordinate.longitude
            let locationData = CLLocation(latitude: lat, longitude: lon)
            
            CLGeocoder().reverseGeocodeLocation(locationData, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    SVProgressHUD.dismiss()
                    return
                }else if let city = placemarks?.first?.subAdministrativeArea {
                    SVProgressHUD.dismiss()
                    print("administrative area is \(city)")
                    
                    print("city is \(String(describing: placemarks?.first?.locality))")
                }
                
            })
            
            
        }
        else if locationPicked == 2 {
            print("Place name: \(place.name)")
            dismiss(animated: true, completion: nil)
            dropOff.text = place.formattedAddress
            if let placeFormat = place.formattedAddress {
                self.dropoff_city = placeFormat
            }
            
            let lat = place.coordinate.latitude
            let lon = place.coordinate.longitude
            let locationData = CLLocation(latitude: lat, longitude: lon)
            
            CLGeocoder().reverseGeocodeLocation(locationData, completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    SVProgressHUD.dismiss()
                    return
                }else if let city = placemarks?.first?.subAdministrativeArea {
                    SVProgressHUD.dismiss()
                    print("administrative area is \(city)")
                    self.dropoff_city = city
                    print("city is \(String(describing: placemarks?.first?.locality))")
                    
                }
            })
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
