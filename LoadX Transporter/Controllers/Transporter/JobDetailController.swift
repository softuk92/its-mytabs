//
//  JobDetailController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/8/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import GoogleMaps
import GooglePlaces
import SDWebImage
import SKPhotoBrowser

var long_dropoff : Double?
var long_pickup : Double?
var lat_pickup : Double?
var lat_dropoff : Double?
var jobs_completed : Bool?

class JobDetailController: UIViewController, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var jobTitle_lbl: UILabel!
    @IBOutlet weak var pickUp_lbl: UILabel!
    @IBOutlet weak var dropOff_lbl: UILabel!
    @IBOutlet weak var jobDescription_lbl: UILabel!
    @IBOutlet weak var job_image_lbl: UILabel!
    @IBOutlet weak var location_lbl: UILabel!
    @IBOutlet weak var distance_lbl: UILabel!
    @IBOutlet weak var fuelCost_lbl: UILabel!
    @IBOutlet weak var jobSummary_image: UIImageView!
    @IBOutlet weak var jobSummary_btn: UIButton!
    @IBOutlet weak var jobSummary_icon: UIImageView!
    
    @IBOutlet weak var pick_up: UILabel!
    @IBOutlet weak var drop_off: UILabel!
    @IBOutlet weak var job_description: UITextView!
    @IBOutlet weak var job_id: UILabel!
    @IBOutlet weak var add_type: UILabel!
    @IBOutlet weak var moving_from: UILabel!
    @IBOutlet weak var moving_to: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var timeslot: UILabel!
    @IBOutlet weak var job_posted_date: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email_address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var fuel_cost: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var image_view: UIView!
    @IBOutlet weak var mapViewX: GMSMapView!
    @IBOutlet weak var noQuotes: UILabel!
    @IBOutlet weak var lowest_bid: UILabel!
    @IBOutlet weak var lowestBidOutlet: UILabel!
    @IBOutlet weak var jobSummaryView: UIView!
    @IBOutlet weak var userInformationView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var jobSummaryArrow: UIImageView!
    @IBOutlet weak var userInfoArrow: UIImageView!
    @IBOutlet weak var transporterPartnerBids: UIView!
    @IBOutlet weak var vehicleType: UILabel!
    @IBOutlet weak var noOfHelper: UILabel!
    @IBOutlet weak var noOfHelperView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var transportPartnerBids: UIButton!
    @IBOutlet weak var noOfBeds: UILabel!
    @IBOutlet weak var noOfBeds_view: UIView!
    @IBOutlet weak var noOfBeds_height: NSLayoutConstraint!
    
    @IBOutlet weak var movingTo_view: UIView!
    @IBOutlet weak var movingFrom_view: UIView!
    @IBOutlet weak var movingFrom_height: NSLayoutConstraint!
    @IBOutlet weak var movingTo_height: NSLayoutConstraint!
    @IBOutlet weak var vehicleType_view: UIView!
    @IBOutlet weak var vehicleType_height: NSLayoutConstraint!
    
    @IBOutlet weak var noOfVehicle_height: NSLayoutConstraint!
    @IBOutlet weak var noOfVehicle_view: UIView!
    @IBOutlet weak var noOfVehicle_value: UILabel!
    
    @IBOutlet weak var no_of_items: UIView!
    @IBOutlet weak var no_of_Item_value: UILabel!
    @IBOutlet weak var no_of_item_height: NSLayoutConstraint!
    @IBOutlet weak var jobId_lbl: UILabel!
    @IBOutlet weak var category_lbl: UILabel!
    @IBOutlet weak var moving_from_lbl: UILabel!
    @IBOutlet weak var moving_to_lbl: UILabel!
    @IBOutlet weak var pickUp_date: UILabel!
    @IBOutlet weak var pickUp_time_lbl: UILabel!
    @IBOutlet weak var datePosted_lbl: UILabel!
    @IBOutlet weak var vehicle_type_lbl: UILabel!
    @IBOutlet weak var no_of_vehicle_lbl: UILabel!
    @IBOutlet weak var no_of_helper_lbl: UILabel!
    @IBOutlet weak var no_of_beds_lbl: UILabel!
    @IBOutlet weak var no_of_item: UILabel!
    
    @IBOutlet weak var userInformation_image: UIImageView!
    @IBOutlet weak var userInformation_btn: UIButton!
    @IBOutlet weak var userInfo_icon: UIImageView!
    
    @IBOutlet weak var full_name_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var phone_lbl: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var email_height: NSLayoutConstraint!
    
    let year = Calendar.current.component(.year, from: Date())
    lazy var viewAllBidsModel = [ViewAllBidsModel]()
    var userId = ""
    var images = [SKPhoto]()
    var menuShowing = false
    var menuShowing1 = false
    var HEADER_HEIGHT = 825
    var puStreet_Route = ""
    var pu_City_Route = ""
    var pu_allAddress = ""
    var doStreet_Route = ""
    var do_City_Route = ""
    var do_allAddress = ""
    var bookedJobPrice : String?
    var no_Of_Helper : Bool?
    var jobPrice : String?
    var no_of_beds : String?
    var Vehicle_no = ""
    var vanType = ""
    var searchJobDetail: Bool?
    var d_item : String?
    var d_dedicated : String?
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    override func viewWillAppear(_ animated: Bool) {
        getDetailOfJob()
        DarkMood()
    }
    func DarkMood(){
        if switchCheck == true {
            self.tableView.backgroundColor = UIColor.black
            topView.backgroundColor = UIColor(hexString: "454545")
            self.jobTitle_lbl.textColor = UIColor.white
            self.moving_item.textColor = UIColor.white
            self.pickUp_lbl.textColor = UIColor.white
            self.pick_up.textColor = UIColor.white
            self.dropOff_lbl.textColor = UIColor.white
            self.drop_off.textColor = UIColor.white
            self.lowestBidOutlet.textColor = UIColor.white
            self.lowest_bid.textColor = UIColor.white
            self.jobDescription_lbl.textColor = UIColor.white
            self.job_description.backgroundColor = UIColor.darkGray
            self.image_view.backgroundColor = UIColor.darkGray
            self.job_description.textColor = UIColor.white
            self.job_image_lbl.textColor = UIColor.white
            self.location_lbl.textColor = UIColor.white
            self.distance_lbl.textColor = UIColor.white
            self.distance.textColor = UIColor.white
            self.fuelCost_lbl.textColor = UIColor.white
            self.fuel_cost.textColor = UIColor.white
            self.jobSummaryView.backgroundColor = UIColor.darkGray
            self.userInformationView.backgroundColor = UIColor.darkGray
            self.moving_item.textColor = UIColor.white
            self.pickUp_lbl.textColor = UIColor.white
            self.pick_up.textColor = UIColor.white
            
            self.no_of_Item_value.textColor = UIColor.white
            self.jobId_lbl.textColor = UIColor.white
            self.job_id.textColor = UIColor.white
            self.category_lbl.textColor = UIColor.white
            self.add_type.textColor = UIColor.white
            self.moving_from_lbl.textColor = UIColor.white
            self.moving_from.textColor = UIColor.white
            self.moving_to_lbl.textColor = UIColor.white
            self.moving_to.textColor = UIColor.white
            self.pickUp_date.textColor = UIColor.white
            self.date.textColor = UIColor.white
            self.pickUp_time_lbl.textColor = UIColor.white
            self.timeslot.textColor = UIColor.white
            self.datePosted_lbl.textColor = UIColor.white
            self.job_posted_date.textColor = UIColor.white
            self.vehicle_type_lbl.textColor = UIColor.white
            self.vehicleType.textColor = UIColor.white
            self.no_of_vehicle_lbl.textColor = UIColor.white
            self.noOfVehicle_value.textColor = UIColor.white
            self.no_of_helper_lbl.textColor = UIColor.white
            self.noOfHelper.textColor = UIColor.white
            self.no_of_beds_lbl.textColor = UIColor.white
            self.noOfBeds.textColor = UIColor.white
            self.no_of_item.textColor = UIColor.white
            self.no_of_Item_value.textColor = UIColor.white
            self.full_name_lbl.textColor = UIColor.white
            self.fullName.textColor = UIColor.white
            self.email_lbl.textColor = UIColor.white
            self.email_address.textColor = UIColor.white
            self.phone_lbl.textColor = UIColor.white
            self.phone.textColor = UIColor.white
            self.address_lbl.textColor = UIColor.white
            self.address.textColor = UIColor.white
                     
           
            self.jobSummaryArrow.image = UIImage(named: "arrowDownDark")

            jobSummary_icon.image = UIImage(named: "jobSumary_dark")
            jobSummary_image.image = UIImage(named: "darkMod_dashbord_completejobIcon-1")
        
            jobSummary_btn.setTitleColor(.white, for: .normal)
           
            
            self.userInfoArrow.image = UIImage(named: "arrowDownDark")
             userInformation_image.image = UIImage(named: "darkMod_dashbord_completejobIcon-1")
            userInfo_icon.image = UIImage(named: "userIconDark")
       
            userInformation_btn.setTitleColor(.white, for: .normal)
        }
    }
    @IBAction func jobDescriptionBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Job Description", message: self.job_description.text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Job Details"
        protected = false
        email_height.constant = 0
        if bookedPriceBool == true {
            self.lowest_bid.text = bookedJobPrice
            self.lowestBidOutlet.text = "Job Price:"
            transporterPartnerBids.isHidden = true
            noQuotes.isHidden = true
        }else{
         self.lowestBidOutlet.text = "Job Price:"
//            self.lowest_bid.text = "£" + (jobPrice ?? "")
        }
        
        if jobs_completed == true {
            transporterPartnerBids.isHidden = true
            noQuotes.isHidden = true
        } else {
            viewAllBids()
        }
        jobSummaryView.isHidden = true
        userInformationView.isHidden = true
        let jobID = "LOADX"+String(year)+"J"+del_id!
        self.job_id.text = jobID
        mapViewX.delegate = self
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = topView
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
        tableView.register(UINib(nibName: "AcceptBidCell", bundle: nil) , forCellReuseIdentifier: "acceptBid")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        bookedPriceBool = nil
        protected = false
        jobs_completed = false
    }
    
    @IBAction func jobSummaryBtn(_ sender: Any) {
        dropDownFunc()
    }
    
    @IBAction func userInformationBtn(_ sender: Any) {
        dropDownFunc1()
    }

    func dropDownFunc() {
                if menuShowing == false {
                    if ( UI_USER_INTERFACE_IDIOM() == .pad )
                    {
                        UIView.animate(withDuration: 0.1, animations: {
                            self.jobSummaryView.isHidden = false
                            self.menuShowing = true
                            if self.userInformationView.isHidden == true {
                                self.HEADER_HEIGHT = 1165
                            } else {
                                self.HEADER_HEIGHT = 1445
                            }
                            self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                            self.tableView.tableHeaderView = self.topView
                            self.tableView.layoutIfNeeded()
                            if self.switchCheck == true {
                                self.jobSummaryArrow.image = UIImage(named: "arrowupDark")
                            }else{
                                self.jobSummaryArrow.image = UIImage(named: "upArrow")
                            }
                            self.view.layoutIfNeeded()
                        })
                    } else {
                        UIView.animate(withDuration: 0.1, animations: {
                            self.jobSummaryView.isHidden = false
                            self.menuShowing = true
                            if self.userInformationView.isHidden == true {
                                if self.no_Of_Helper == true {
                                    self.heightConstraint.constant = 492
                                    self.HEADER_HEIGHT = 1210
                                } else {
                                    self.heightConstraint.constant = 450
                                    self.HEADER_HEIGHT = 1240
                                }
                            } else {
                                if self.no_Of_Helper == true {
                                    self.heightConstraint.constant = 492
                                    self.HEADER_HEIGHT = 1420
                                } else {
                                    self.heightConstraint.constant = 536
                                    self.HEADER_HEIGHT = 1420
                                }
                            }
                            
                            
                            
                            self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                            self.tableView.tableHeaderView = self.topView
                            self.tableView.layoutIfNeeded()
                            if self.switchCheck == true {
                                self.jobSummaryArrow.image = UIImage(named: "arrowupDark")
                            }else{
                                self.jobSummaryArrow.image = UIImage(named: "upArrow")
                            }
                           
                            self.view.layoutIfNeeded()
                        })
                    }
                    if no_of_beds == "N/A" || no_of_beds == ""{
                        noOfBeds_view.isHidden = true
                        noOfBeds.isHidden = true
                        noOfBeds_height.constant = 0
                        self.heightConstraint.constant = 440
                    }else{
                        noOfBeds.isHidden = false
                        if no_of_beds == "1"{
                            self.noOfBeds.text = self.no_of_beds! + " Bed"
                        }else{
                            self.noOfBeds.text = self.no_of_beds! + " Beds"
                        }
                         noOfBeds_height.constant = 44
                        self.heightConstraint.constant = 492
                    }
                   
                    
                    if self.add_type.text == "Furniture and General Items" || self.add_type.text == "One Item" || self.add_type.text == "Two Items" || self.add_type.text == "Three or More Items" || self.add_type.text == "Piano"  || self.add_type.text == "Business & Industrial Goods" ||  self.add_type.text == "Machine and Vehicle Parts" || self.add_type.text == "Waste Removal" || self.add_type.text ==  "Office Move" || self.add_type.text == "Other"{
                       
                        noOfBeds_view.isHidden = true
                        noOfBeds.isHidden = true
                        noOfVehicle_view.isHidden = true
                        vehicleType_view.isHidden = false
                        vehicleType_height.constant = 44
                        noOfVehicle_height.constant = 0
                        noOfBeds_height.constant = 0
                        self.heightConstraint.constant = 440
                   
                        if d_item == "One Item" || self.add_type.text == "One Item" {
                         no_of_items.isHidden = false
                         no_of_item_height.constant = 44
                         no_of_Item_value.text = d_item
                         self.heightConstraint.constant = 484
                    
                        }else if d_item == "Two Items" || self.add_type.text == "Two Items" {
                         no_of_items.isHidden = false
                         no_of_item_height.constant = 44
                         no_of_Item_value.text = d_item
                         self.heightConstraint.constant = 484
                        }else{
                         no_of_items.isHidden = true
                         no_of_item_height.constant = 0
                         self.heightConstraint.constant = 440
                        }
                    }
                   
                    if self.add_type.text == "Cars & Vehicles" || self.add_type.text == "Bikes & Motorcycles"  {
                        movingTo_view.isHidden = true
                        movingFrom_view.isHidden = true
                        movingTo_height.constant = 0
                        movingFrom_height.constant = 0
                        noOfBeds.isHidden = true
                        noOfBeds_height.constant = 0
                        noOfVehicle_view.isHidden = true
                        noOfVehicle_height.constant = 0
                        self.heightConstraint.constant = 348
                        no_of_items.isHidden = true
                        no_of_item_height.constant = 0
                        
                    }
                    
                    if self.add_type.text == "Moving Home" {
                      self.noOfHelper.text = "2"+" Person"
                         noOfBeds.isHidden = false
                         noOfBeds_height.constant = 44
    //                    noOfVehicle.text = Vehicle_no
                        self.heightConstraint.constant = 536
                        if Vehicle_no == "1"{
                            self.noOfVehicle_value.text = Vehicle_no + " Vehicle"
                        }else{
                            self.noOfVehicle_value.text = Vehicle_no + " Vehicles"
                        }
                    }
                    if self.vanType == "N/A" || self.vanType == "" {
                        vehicleType_view.isHidden = true
                        vehicleType_height.constant = 0
                    }else{
                        vehicleType_view.isHidden = false
                        vehicleType_height.constant = 44
                    }
                } else if menuShowing == true {
                UIView.animate(withDuration: 0.1, animations: {
                    self.jobSummaryView.isHidden = true
                    self.menuShowing = false
                    if self.userInformationView.isHidden == true {
                        self.HEADER_HEIGHT = 820
                    } else {
                        self.HEADER_HEIGHT = 1004
                    }
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    if self.switchCheck == true {
                        self.jobSummaryArrow.image = UIImage(named: "arrowDownDark")
                    }else{
                        self.jobSummaryArrow.image = UIImage(named: "downArrow-1")
                    }
                    
                    self.view.layoutIfNeeded()
                })
            }
        }
        
        func dropDownFunc1() {
            if menuShowing1 == false {
                if ( UI_USER_INTERFACE_IDIOM() == .pad )
                {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.userInformationView.isHidden = false
                        self.menuShowing1 = true
                        if self.jobSummaryView.isHidden == false {
                            self.HEADER_HEIGHT = 1435
                        } else {
                            self.HEADER_HEIGHT = 1006
                        }
                        self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                        self.tableView.tableHeaderView = self.topView
                        self.tableView.layoutIfNeeded()
                        if self.switchCheck == true {
                            self.userInfoArrow.image = UIImage(named: "arrowupDark")
                        }else{
                            self.userInfoArrow.image = UIImage(named: "upArrow")
                        }
                                       
                        self.view.layoutIfNeeded()
                    })
                } else {
                    UIView.animate(withDuration: 0.1, animations: {
                        self.userInformationView.isHidden = false
                        self.menuShowing1 = true
                        if self.jobSummaryView.isHidden == false {
                            self.HEADER_HEIGHT = 1330
                            if self.no_Of_Helper == true {
                              self.heightConstraint.constant = 440
                              self.HEADER_HEIGHT = 1320
                            }else {
                              if self.add_type.text == "Cars & Vehicles"  || self.add_type.text == "Bikes & Motorcycles"  {
                                self.heightConstraint.constant = 348
                                self.HEADER_HEIGHT = 1300
                            }
                          }
                        } else {
                            self.HEADER_HEIGHT = 900
                        }
                        
                        if self.add_type.text == "Moving Home"{
                             self.heightConstraint.constant =  536
                        }
                        self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                        self.tableView.tableHeaderView = self.topView
                        self.tableView.layoutIfNeeded()
                        if self.switchCheck == true {
                            self.userInfoArrow.image = UIImage(named: "arrowupDark")
                        }else{
                            self.userInfoArrow.image = UIImage(named: "upArrow")
                        }
                        self.view.layoutIfNeeded()
                    })
                }
                
            } else if menuShowing1 == true {
                UIView.animate(withDuration: 0.1, animations: {
                    self.userInformationView.isHidden = true
                    self.menuShowing1 = false
                    if self.jobSummaryView.isHidden == true {
                        self.HEADER_HEIGHT = 820
                    } else {
                        if self.no_Of_Helper == true {
                            self.HEADER_HEIGHT = 1230
                            self.heightConstraint.constant = 440
                        } else {
                            if self.add_type.text == "Cars & Vehicles"  || self.add_type.text == "Bikes & Motorcycles"  {
                                self.heightConstraint.constant = 348
                                self.HEADER_HEIGHT = 1420
                        }else if self.add_type.text == "Moving Home"{
                                             
                            self.heightConstraint.constant = 536
                        }else{
                            self.heightConstraint.constant = 484
                            self.HEADER_HEIGHT = 1265
                        }
                    }
                }
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    if self.switchCheck == true {
                        self.userInfoArrow.image = UIImage(named: "arrowDownDark")
                    }else{
                    self.userInfoArrow.image = UIImage(named: "downArrow-1")
                    }
                    
                    self.view.layoutIfNeeded()
                })
            }
        }
    
    @IBAction func image1Viewer(_ sender: Any) {
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        present(browser, animated: true, completion: nil)
    }
    
    @IBAction func image2Viewer(_ sender: Any) {
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(1)
        present(browser, animated: true, completion: nil)
    }
    
    @IBAction func image3Viewer(_ sender: Any) {
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(2)
        present(browser, animated: true, completion: nil)
    }
    
    @IBAction func pickupTap(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Pickup Location", message: self.pick_up.text ?? "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dropoffTap(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Dropoff Location", message: self.drop_off.text ?? "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func movingItemTap(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Moving Item", message: self.moving_item.text ?? "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDetailOfJob() {
        SVProgressHUD.show(withStatus: "Getting job details...")
        if del_id != nil {
            let jobDetail_URL = main_URL+"api/job_detail"
            let parameters : Parameters = ["del_id" : del_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(jobDetail_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                    let jsonData : JSON = JSON(response.result.value!)
                    print("job detail jsonData is \(jsonData)")
                    //let result = jsonData[0]["result"].stringValue
                    //let message = jsonData[0]["message"].stringValue
                    let movingTo = jsonData[0]["moving_to"].stringValue
                        if movingTo == "" {
                            self.moving_to.text = "N/A"
                        } else {
                            self.moving_to.text = movingTo
                        }
                        self.d_dedicated = jsonData[0]["d_dedicated_van"].stringValue
                        self.d_item = jsonData[0]["d_items"].stringValue
                        self.Vehicle_no = jsonData[0]["no_of_vehicle"].stringValue
                        
                        self.vanType = jsonData[0]["vehicle_type"].stringValue
                        self.no_of_beds = jsonData[0]["no_of_beds"].stringValue
                        
                        let currentBid = jsonData[0]["min_bid"].stringValue
                        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
                        let doubleValue = Double(x)
                        
                        let resultInitialPrice = Double(currentBid)! * Double(doubleValue!/100)
//                        let resultInitialPrice = Double(currentBid)! * Double(0.25)
                        let roundedPrice = Double(resultInitialPrice).rounded(toPlaces: 2)
                        let jobPrice = Double(currentBid)! - roundedPrice
                        
                        self.lowest_bid.text = "£" + "\(jobPrice)"
                        
                        let no_of_helper = jsonData[0]["no_of_helper"].stringValue
                        if no_of_helper != "N/A" && no_of_helper != "" {
                            self.noOfHelper.text = no_of_helper+" Person"
                            self.no_Of_Helper = false
                        } else {
                            self.no_Of_Helper = true
                            self.noOfHelperView.isHidden = true
                        }
                    
                        let vanType1 = jsonData[0]["vehicle_type"].stringValue
                        let vrtType = jsonData[0]["vrt_type"].stringValue
                        
                        if self.d_dedicated == "1" {
                            if vanType1 == "SWB Van" {
                                self.vehicleType.text = "Small Van-Dedicated"
                            } else if vanType1 == "MWB Van" {
                                self.vehicleType.text = "Medium Van-Dedicated"
                            } else if vanType1 == "LWB Van" {
                                self.vehicleType.text = "Large Van-Dedicated"
                            } else {
                                self.vehicleType.text = vanType1+"-Dedicated"
                            }
                        }else{
                            if vanType1 == "SWB Van" {
                                self.vehicleType.text = "Small Van"
                            } else if vanType1 == "MWB Van" {
                                self.vehicleType.text = "Medium Van"
                            } else if vanType1 == "LWB Van" {
                                self.vehicleType.text = "Large Van"
                            } else if vanType1 == "Vehicle Recovery Truck" || vanType1 == "Vehicle Recovery" {
                                self.vehicleType.text = vrtType+" Ton Truck"
                            }
                            else {
                                self.vehicleType.text = vanType1
                            }
                        }
                        
                        let puStreet = jsonData[0]["pu_street"].stringValue
                        let puRoute = jsonData[0]["pu_route"].stringValue
                        let puCity = jsonData[0]["pu_city"].stringValue
                        let puPostCode = jsonData[0]["pu_post_code"].stringValue
                        let pick_up = jsonData[0]["pick_up"].stringValue
                       
                       
                        
                        let doStreet = jsonData[0]["do_street"].stringValue
                        let doRoute = jsonData[0]["do_route"].stringValue
                        let doCity = jsonData[0]["do_city"].stringValue
                        let doPostCode = jsonData[0]["do_post_code"].stringValue
                        let drop_off =  jsonData[0]["drop_off"].stringValue
                        
                        if self.searchJobDetail == true {
                            if puStreet != "" || puRoute != "" {
                            self.puStreet_Route = puStreet+" "+puRoute+","
                            self.pick_up.text = puStreet
                        }
                        if puCity != "" {
                            self.pu_City_Route = self.puStreet_Route+" "+puCity+","
                            self.pick_up.text = self.pu_City_Route
                        } else {
                            self.pu_City_Route = self.puStreet_Route
                        }
                            if puPostCode != "" {
                            let spaceCount = puPostCode.filter{$0 == " "}.count
                        if spaceCount > 0 {
                        if let first = puPostCode.components(separatedBy: " ").first {
                            self.pu_allAddress = self.pu_City_Route+" "+first
                            self.pick_up.text = self.pu_allAddress
                           }
                        } else if spaceCount == 0 {
                          self.pu_allAddress = self.pu_City_Route+" "+puPostCode
                          self.pick_up.text = self.pu_allAddress
                        }
                    }
                        }else{
                        self.pick_up.text = pick_up
                }
                        
                        if self.searchJobDetail == true {
                        if doStreet != "" || doRoute != "" {
                            self.doStreet_Route = doStreet+" "+doRoute+","
                            self.drop_off.text = doStreet
                        }
                        if doCity != "" {
                            self.do_City_Route = self.doStreet_Route+" "+doCity+","
                            self.drop_off.text = self.do_City_Route
                        } else {
                            self.do_City_Route = self.doStreet_Route
                        }
                        if doPostCode != "" {
                            let spaceCount = doPostCode.filter{$0 == " "}.count
                            if spaceCount > 0 {
                                if let first = doPostCode.components(separatedBy: " ").first {
                                    self.do_allAddress = self.do_City_Route+" "+first
                                    self.drop_off.text = self.do_allAddress
                                }
                            } else if spaceCount == 0 {
                                self.do_allAddress = self.do_City_Route+" "+doPostCode
                                self.drop_off.text = self.do_allAddress
                            }
                        }
                        }else{
                            self.drop_off.text = drop_off
                        }
                    self.timeslot.text = jsonData[0]["timeslot"].stringValue
                    let distance = jsonData[0]["distance"].stringValue
                    self.add_type.text = jsonData[0]["add_type"].stringValue
                    let movingItem = jsonData[0]["moving_item"].stringValue
                        self.moving_item.text = movingItem.capitalized
                        let jobDescription = jsonData[0]["description"].stringValue
                        
                        if jobDescription != "" {
                        self.job_description.text = jobDescription
                        } else {
                            self.job_description.text = "N/A"
                        }
                    
                        let stringJobPostedDate = jsonData[0]["job_posted_date"].stringValue
                        if stringJobPostedDate != ""{
                        let convertedJobPostedDate = self.convertDateFormatter(stringJobPostedDate)
                        self.job_posted_date.text = convertedJobPostedDate
                        }else{
                             print("\n Json response is empty..... \n")
                        }
                        let stringDate = jsonData[0]["date"].stringValue
                        if stringDate != ""{
                        let convertedDate = self.convertDateFormatter(stringDate)
                        self.date.text = convertedDate
                        }else{
                            print("\n Json response is empty.... \n")
                        }
                        let movingFrom = jsonData[0]["moving_from"].stringValue
                        if movingFrom == "" {
                            self.moving_from.text = "N/A"
                        } else {
                            self.moving_from.text = movingFrom
                        }
                    self.userId = jsonData[0]["user_id"].stringValue
                    long_dropoff = Double(jsonData[0]["long_dropoff"].stringValue)
                    long_pickup = Double(jsonData[0]["long_pickup"].stringValue)
                    lat_pickup = Double(jsonData[0]["lat_pickup"].stringValue)
                    lat_dropoff = Double(jsonData[0]["lat_dropoff"].stringValue)
                    self.showProfile()
                    self.jobDetailMap()
                    let image1 = jsonData[0]["image1"].stringValue
                    let image2 = jsonData[0]["image2"].stringValue
                    let image3 = jsonData[0]["image3"].stringValue
                        
                    if image1 != "" {
                            let urlString = main_URL+"assets/job_images/"+image1
                            if let url = URL(string: urlString) {
                                        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                            //                        print(received, expected)
                                        }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                            if let imageCell = imageReceived {
                                                       self.image1.image = imageCell
                                                let photo1 = SKPhoto.photoWithImage(imageCell)
                                                self.images.append(photo1)
                                            }
                                        }
                                    }
                                } else {
                                    let photo1 = SKPhoto.photoWithImage(self.image1.image!)
                                    self.images.append(photo1)
                                }
                                
                                if image2 != "" {
                                    let urlString = main_URL+"assets/job_images/"+image2
                                    if let url = URL(string: urlString) {
                                        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                            //                        print(received, expected)
                                        }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                            if let imageCell = imageReceived {
                                                
                                                self.image2.image = imageCell
                                                let photo2 = SKPhoto.photoWithImage(imageCell)
                                                self.images.append(photo2)
                                            }
                                        }
                                    }
                                } else {
                                    let photo2 = SKPhoto.photoWithImage(self.image2.image!)
                                    self.images.append(photo2)
                                }
                                
                                if image3 != "" {
                                    let urlString = main_URL+"assets/job_images/"+image3
                                    if let url = URL(string: urlString) {
                                        SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                            //                        print(received, expected)
                                        }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                            if let imageCell = imageReceived {
                                                
                                                self.image3.image = imageCell
                                                let photo3 = SKPhoto.photoWithImage(imageCell)
                                                self.images.append(photo3)
                                            }
                                        }
                                    }
                                } else {
                                    let photo3 = SKPhoto.photoWithImage(self.image3.image!)
                                    self.images.append(photo3)
                                }
                                                
                        if distance != "" {
                            let resultFuel = Double(distance)! / Double(6)
                            let roundedFuel = Double(resultFuel).rounded(toPlaces: 2)
                            self.fuel_cost.text = "£"+String(roundedFuel)
                            
                            if let roundedValue1 = Double(distance)?.rounded(toPlaces: 2) {
                                let distanceString = String(roundedValue1)+" miles"
                                self.distance.text = distanceString
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
                let alert = UIAlertController(title: "Error", message: "You are not connected to internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error!", message: "Error getting details, please try again later", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func jobDetailMap() {
        let sessionManager = SessionManager()
        
        if lat_pickup != nil && lat_dropoff != nil && long_pickup != nil && long_dropoff != nil {
            let start = CLLocationCoordinate2D(latitude: lat_pickup!, longitude: long_pickup!)
            
            let end = CLLocationCoordinate2D(latitude: lat_dropoff!, longitude: long_dropoff!)
            
            sessionManager.requestDirections(from: start, to: end, completionHandler: { (path, error) in
                
                if let error = error {
                    print("Something went wrong, abort drawing!\nError: \(error)")
                } else {
                    // Create a GMSPolyline object from the GMSPath
                    let polyline = GMSPolyline(path: path!)
                    
                    // Add the GMSPolyline object to the mapView
                   
                    polyline.map = self.mapViewX 
                    
                    // Move the camera to the polyline
                    let bounds = GMSCoordinateBounds(path: path!)
                    let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 15, bottom: 10, right: 15))
                    self.mapViewX.animate(with: cameraUpdate)
                    
                    let position = CLLocationCoordinate2D(latitude: lat_pickup!, longitude: long_pickup!)
                    let marker = GMSMarker(position: position)
                    marker.title = "Pickup Location"
                    marker.map = self.mapViewX
                    
                    let position2 = CLLocationCoordinate2D(latitude: lat_dropoff!, longitude: long_dropoff!)
                    let marker2 = GMSMarker(position: position2)
                    marker2.title = "Drop off Location"
                    marker2.map = self.mapViewX
                }
            })
        } else {
            print("Location is not available")
        }
    }

    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            
            UIApplication.shared.open(NSURL(string:"comgooglemaps://?saddr=&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
        }
        else {
            
            let alert = UIAlertController(title: "Google Maps not found", message: "Please install Google Maps in your device.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            
            UIApplication.shared.open(NSURL(string:"comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving")! as URL, options: [:], completionHandler: nil)
        }
        else {
            
            let alert = UIAlertController(title: "Google Maps not found", message: "Please install Google Maps in your device.", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func showProfile() {
//        SVProgressHUD.show(withStatus: "Getting details...")
        if userId != "" {
            let editProfileData_URL = main_URL+"api/userProfileDetail"
            let parameters : Parameters = ["user_id" : userId]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(editProfileData_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("show Profile jsonData is \(jsonData)")
                        //let result = jsonData[0]["result"].stringValue
                        //let message = jsonData[0]["message"].stringValue
                        let full_name = jsonData[0]["user_name"].stringValue
                        self.fullName.text = full_name.capitalized
                       
//                        if self.searchJobDetail == true{
//                        self.phone.text = "[phone protected]"
//                        }else{
                        self.phone.text = jsonData[0]["user_phone"].stringValue
//                        }
                        if protected == true {
                        self.email_address.text = jsonData[0]["user_email"].stringValue
                      
                        self.address.text = jsonData[0]["user_address"].stringValue
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
            
        }
    }
    
    func viewAllBids() {
        if del_id != nil {
            let viewAllBids_URL = main_URL+"api/userViewAllBidsOnJob"
            let parameters : Parameters = ["del_id" : del_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(viewAllBids_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("view all bids jsonData is \(jsonData)")
                        if bookedPriceBool != true {
                        let currentBid = jsonData[0]["current_bid"].stringValue
                        if currentBid != "" {
                            self.lowest_bid.text = "£"+currentBid
                        }
                        
                        let result = jsonData[0]["result"].stringValue
                        if result == "0" {
                            self.noQuotes.isHidden = false
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.viewAllBidsModel = try JSONDecoder().decode([ViewAllBidsModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    print(self.viewAllBidsModel)
                                    
                                    DispatchQueue.main.async {
                                        self.noQuotes.isHidden = true
                                        self.tableView.reloadData()
                                        let counter = String(self.viewAllBidsModel.count)
                                        self.transportPartnerBids.setTitle("Transport Partner Bid's ("+counter+")", for: .normal)
                                    }
                                    
                                } catch {
                                    print(error)
                                    let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
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
            let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewAllBidsModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "acceptBid") as! AcceptBidCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        cell.innerView.layer.shadowColor = UIColor.gray.cgColor
        cell.innerView.layer.shadowOffset = .zero
        cell.innerView.layer.shadowOpacity = 1
        
        let image_cell1 = viewAllBidsModel[indexPath.row].transporter_img
        let image_cell2 = viewAllBidsModel[indexPath.row].driver_license
        
        if image_cell1 != "" {
            let urlString = main_URL+"assets/user_profile_image/"+image_cell1
            if let url = URL(string: urlString) {
                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                    //                        print(received, expected)
                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                    if let imageCell = imageReceived {
                        cell.transporter_img.image = imageCell
                        cell.transporter_img.layer.cornerRadius = 5
                        cell.transporter_img.layer.shadowOpacity = 1
                    }
                }
            }
        }
        
        if image_cell1 != "" && image_cell2 != "" {
            cell.tickImage.isHidden = false
        } else {
            cell.tickImage.isHidden = true
        }
        let transporterName = viewAllBidsModel[indexPath.row].transporter_name
        cell.transporter_name.text = transporterName.capitalized
        cell.current_bid.text = "£"+viewAllBidsModel[indexPath.row].current_bid
        let feedbackStars = viewAllBidsModel[indexPath.row].avg_feedback
        cell.cosmosView.isUserInteractionEnabled = false
        if transporterName == "LOADX LTD" {
            cell.nullView.isHidden = false
            cell.feedback_stars.isHidden = false
            cell.cosmosView.isHidden = false
            cell.ratingNotAvailable.isHidden = true
        
            cell.feedback_stars.text = "5.0"
            cell.cosmosView.rating = 5.0
            
        } else {
        if feedbackStars == "null" || feedbackStars == "0" {
            cell.nullView.isHidden = true
            cell.feedback_stars.isHidden = true
            cell.cosmosView.isHidden = true
            cell.ratingNotAvailable.isHidden = false
        } else {
            cell.nullView.isHidden = false
            cell.feedback_stars.isHidden = false
            cell.cosmosView.isHidden = false
            cell.ratingNotAvailable.isHidden = true

            if let roundedValue1 = Double(feedbackStars)?.rounded(toPlaces: 1) {
                let distanceString = String(roundedValue1)
                cell.feedback_stars.text = distanceString
                cell.cosmosView.rating = Double(feedbackStars)!
            }
        }
        }
        cell.transporterProfileRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            let transporter_name = self.viewAllBidsModel[indexPath.row].transporter_name
            if transporter_name != "LOADX LTD" {
            transporter_id = self.viewAllBidsModel[indexPath.row].transporter_id
            self.performSegue(withIdentifier: "profile", sender: self)
            }
        }
        
        return cell
    }
    
    func convertDateFormatter(_ date: String?) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date!)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

