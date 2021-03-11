//
//  BidJobDetailController.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/25/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import GoogleMaps
import GooglePlaces
import SDWebImage
import IBAnimatable
import SKPhotoBrowser

class BidJobDetailController: UIViewController, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var pick_up: UILabel!
    @IBOutlet weak var drop_off: UILabel!
    @IBOutlet weak var job_description: UITextView!
    @IBOutlet weak var job_id: CopyableLabel!
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
    @IBOutlet weak var mapViewX: GMSMapView!
    @IBOutlet weak var noQuotes: UILabel!
    @IBOutlet weak var lowest_bid: UILabel!
    @IBOutlet weak var jobSummaryView: UIView!
    @IBOutlet weak var userInformationView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var bid_price_field: AnimatableTextField!
    @IBOutlet weak var jobSummaryArrow: UIImageView!
    @IBOutlet weak var alreadyBidLabel: UILabel!
    @IBOutlet weak var searchNewJobBtn: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var transportPartnerBids: UIButton!
    //@IBOutlet weak var placeBidHeight: NSLayoutConstraint!
//  @IBOutlet weak var placeBidOutlet: AnimatableButton!
    @IBOutlet weak var userInfoArrow: UIImageView!
    let year = Calendar.current.component(.year, from: Date())
    lazy var viewAllBidsModel = [ViewAllBidsModel]()
    var userId = ""
    var images = [SKPhoto]()
    var menuShowing = false
    var menuShowing1 = false
    var HEADER_HEIGHT = 970
    var puStreet_Route = ""
    var pu_City_Route = ""
    var pu_allAddress = ""
    var doStreet_Route = ""
    var do_City_Route = ""
    var do_allAddress = ""
    @IBOutlet weak var vehicleType: UILabel!
    @IBOutlet weak var noOfHelper: UILabel!
    @IBOutlet weak var noOfHelperView: UIView!
    @IBOutlet weak var noOfBed_view: UIView!
    @IBOutlet weak var noOfBed_lble: UILabel!
    
    var no_Of_Helper : Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Job Details"
        
        getDetailOfJob()
        viewAllBids()
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
    
    @IBAction func searchJobsBtn(_ sender: Any) {
        if ic_status == "pending" || dl_status == "pending" {
        self.performSegue(withIdentifier: "dashboard", sender: self)
        } else if ic_status == "Reject" || dl_status == "Reject" || ic_status == "" || dl_status == "" {
        self.performSegue(withIdentifier: "edit", sender: self)
        } else {
        self.performSegue(withIdentifier: "searchJobs", sender: self)
        }
    }
    
    @IBAction func jobDescriptionBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Job Description", message: self.job_description.text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        protected = false
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
                        self.HEADER_HEIGHT = 1310
                    } else {
                        self.HEADER_HEIGHT = 1520
                    }
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    self.jobSummaryArrow.image = UIImage(named: "upArrow")
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.jobSummaryView.isHidden = false
                    self.menuShowing = true
                    if self.userInformationView.isHidden == true {
                        if self.no_Of_Helper == true {
                            self.heightConstraint.constant = 410
                            self.HEADER_HEIGHT = 1380
                        } else {
                            self.heightConstraint.constant = 440
                            self.HEADER_HEIGHT = 1430
                        }
                    } else {
                        if self.no_Of_Helper == true {
                            self.heightConstraint.constant = 410
                            self.HEADER_HEIGHT = 1560
                        } else {
                            self.heightConstraint.constant = 440
                            self.HEADER_HEIGHT = 1590
                        }
                    }
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    self.jobSummaryArrow.image = UIImage(named: "upArrow")
                    self.view.layoutIfNeeded()
                })
            }
            
        } else if menuShowing == true {
            UIView.animate(withDuration: 0.1, animations: {
                self.jobSummaryView.isHidden = true
                self.menuShowing = false
                if self.userInformationView.isHidden == true {
                    self.HEADER_HEIGHT = 970
                } else {
                    self.HEADER_HEIGHT = 1160
                }
                self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                self.tableView.tableHeaderView = self.topView
                self.tableView.layoutIfNeeded()
                self.jobSummaryArrow.image = UIImage(named: "downArrow-1")
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
                        self.HEADER_HEIGHT = 1520
                    } else {
                        self.HEADER_HEIGHT = 1165
                    }
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    self.userInfoArrow.image = UIImage(named: "upArrow")
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.userInformationView.isHidden = false
                    self.menuShowing1 = true
                    if self.jobSummaryView.isHidden == false {
                        if self.no_Of_Helper == true {
                            self.heightConstraint.constant = 410
                            self.HEADER_HEIGHT = 1560
                        } else {
                            self.heightConstraint.constant = 440
                            self.HEADER_HEIGHT = 1590
                        }
                    } else {
                        self.HEADER_HEIGHT = 1160
                    }
                    self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                    self.tableView.tableHeaderView = self.topView
                    self.tableView.layoutIfNeeded()
                    self.userInfoArrow.image = UIImage(named: "upArrow")
                    self.view.layoutIfNeeded()
                })
            }
            
        } else if menuShowing1 == true {
            UIView.animate(withDuration: 0.1, animations: {
                self.userInformationView.isHidden = true
                self.menuShowing1 = false
                if self.jobSummaryView.isHidden == true {
                    self.HEADER_HEIGHT = 970
                } else {
                    if self.no_Of_Helper == true {
                        self.heightConstraint.constant = 410
                        self.HEADER_HEIGHT = 1360
                    } else {
                        self.heightConstraint.constant = 440
                        self.HEADER_HEIGHT = 1400
                    }
                }
                self.topView.frame.size = CGSize(width: self.tableView.frame.width, height: CGFloat(self.HEADER_HEIGHT))
                self.tableView.tableHeaderView = self.topView
                self.tableView.layoutIfNeeded()
                self.userInfoArrow.image = UIImage(named: "downArrow-1")
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
    
    @IBAction func place_bid_btn(_ sender: Any) {
        placeBidFunc()
    }
    
    func getDetailOfJob() {
        SVProgressHUD.show(withStatus: "Getting job details...")
        if del_id != nil && user_id != nil {
            let jobDetail_URL = main_URL+"api/job_detail"
            let parameters : Parameters = ["del_id" : del_id!, "user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(jobDetail_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("job detail jsonData is \(jsonData)")
                        //let result = jsonData[0]["result"].stringValue
                        //let message = jsonData[0]["message"].stringValue
                        let alreadyBid = jsonData[1]["alreadybid"].intValue
                        if ic_status == "pending" || dl_status == "pending" {
                            self.bottomConstraint.constant = 0
                            self.searchNewJobBtn.isHidden = false
                            self.alreadyBidLabel.isHidden = false
                            self.alreadyBidLabel.text = "Please wait for documents approval."
                            self.searchNewJobBtn.setTitle("Dashboard", for: .normal)
                        } else if ic_status == "Reject" || dl_status == "Reject" || ic_status == "" || dl_status == "" {
                            self.bottomConstraint.constant = 0
                            self.searchNewJobBtn.isHidden = false
                            self.alreadyBidLabel.isHidden = false
                            self.alreadyBidLabel.text = "Please upload your documents."
                            self.searchNewJobBtn.setTitle("Upload Documents", for: .normal)
                        } else {
                        if alreadyBid == 1 {
                            self.bottomConstraint.constant = 0
                            self.searchNewJobBtn.isHidden = false
                            self.alreadyBidLabel.isHidden = false
                            self.alreadyBidLabel.text = "You have already offered price."
                            self.searchNewJobBtn.setTitle("Search New Jobs", for: .normal)
                        } else {
                            self.bottomConstraint.constant = 111
                            self.searchNewJobBtn.isHidden = true
                            self.alreadyBidLabel.isHidden = true
                        }
                        }
                        let movingTo = jsonData[0]["moving_to"].stringValue
                        if movingTo == "" {
                            self.moving_to.text = "N/A"
                        } else {
                            self.moving_to.text = movingTo
                        }
                        
                        let no_of_helper = jsonData[0]["no_of_helper"].stringValue
                        if no_of_helper != "N/A" && no_of_helper != "" {
                            self.noOfHelper.text = no_of_helper+" Person"
                            self.no_Of_Helper = false
                        } else {
                            self.no_Of_Helper = true
                            self.noOfHelperView.isHidden = true
                        }
                        
                        let vanType = jsonData[0]["vehicle_type"].stringValue
                        
                        if vanType == "SWB Van" {
                            self.vehicleType.text = "Small Van"
                        } else if vanType == "MWB Van" {
                            self.vehicleType.text = "Medium Van"
                        } else if vanType == "LWB Van" {
                            self.vehicleType.text = "Large Van"
                        } else {
                            self.vehicleType.text = vanType
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
                        
                        let puStreet = jsonData[0]["pu_street"].stringValue
                        let puRoute = jsonData[0]["pu_route"].stringValue
                        let puCity = jsonData[0]["pu_city"].stringValue
                        let puPostCode = jsonData[0]["pu_post_code"].stringValue
                       
                       
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
                        
                        let doStreet = jsonData[0]["do_street"].stringValue
                        let doRoute = jsonData[0]["do_route"].stringValue
                        let doCity = jsonData[0]["do_city"].stringValue
                        let doPostCode = jsonData[0]["do_post_code"].stringValue
                        
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
                        
                        let stringJobPostedDate = jsonData[0]["job_posted_date"].stringValue
                        let convertedJobPostedDate = self.convertDateFormatter(stringJobPostedDate)
                        self.job_posted_date.text = convertedJobPostedDate
                        
                        let stringDate = jsonData[0]["date"].stringValue
                        let convertedDate = self.convertDateFormatter(stringDate)
                        self.date.text = convertedDate
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
                                    let urlString = main_URL+"public/assets/job_images/"+image1
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
                                    let urlString = main_URL+"public/assets/job_images/"+image2
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
                                    let urlString = main_URL+"public/assets/job_images/"+image3
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
//                        let result = jsonData[0]["result"].stringValue
                        //let message = jsonData[0]["message"].stringValue
                        let full_name = jsonData[0]["user_name"].stringValue
                        self.fullName.text = full_name.capitalized
                        if protected == true {
                        self.email_address.text = jsonData[0]["user_email"].stringValue
                        self.phone.text = jsonData[0]["user_phone"].stringValue
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
            let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func viewAllBids() {
        if del_id != "" {
            let viewAllBids_URL = main_URL+"api/userViewAllBidsOnJob"
            let parameters : Parameters = ["del_id" : del_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(viewAllBids_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                    let jsonData : JSON = JSON(response.result.value!)
                    print("view all bids jsonData is \(jsonData)")
                    let currentBid = jsonData[0]["current_bid"].stringValue
                        if currentBid != "" {
                            self.lowest_bid.text = "£"+currentBid
                        } else {
                            self.lowest_bid.text = "No bid Yet"
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
    
    func placeBidFunc() {
        SVProgressHUD.show(withStatus: "Placing a bid...")
        if user_id != nil && user_email != nil && del_id != nil && self.bid_price_field.text != "" {
            let editProfileData_URL = main_URL+"api/transporterBidOnJob"
            let parameters : Parameters = ["userid" : user_id!, "user_email" : user_email!, "jobid" : del_id!, "bid_price" : self.bid_price_field.text!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(editProfileData_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("place bid jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        if result == "0" {
                            SVProgressHUD.showError(withStatus: "You have already bid on this job.")
                            self.bid_price_field.text = ""
                            
                        } else {
                            self.performSegue(withIdentifier: "success", sender: self)
                            self.pushNotification()
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
    
    func pushNotification() {
        if user_id != nil {
            //    SVProgressHUD.show(withStatus: "Updating payment status...")
            let deleteJob_URL = main_URL+"api/userNotificationAcceptBidForIOS"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(deleteJob_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("notification job jsonData is \(jsonData)")
//                        let result = jsonData[0]["result"].stringValue
                        //    if result == "1" {
                        //    self.performSegue(withIdentifier: "updated", sender: self)
                        //    }
                        //    } else {
                        //    SVProgressHUD.dismiss()
                        //    let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                        //    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        //    self.present(alert, animated: true, completion: nil)
                        //    print("Error \(response.result.error!)")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewAllBidsModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "acceptBid") as! AcceptBidCell
        cell.layer.shadowRadius = 5
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        cell.innerView.layer.shadowColor = UIColor.gray.cgColor
        cell.innerView.layer.shadowOffset = .zero
        cell.innerView.layer.shadowOpacity = 1
        
        let image_cell1 = viewAllBidsModel[indexPath.row].transporter_img
        let image_cell2 = viewAllBidsModel[indexPath.row].driver_license
        
        if image_cell1 != "" {
            let urlString = main_URL+"public/assets/user_profile_image/"+image_cell1
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
        if transporterName == "CTS MOVE LTD" {
            cell.nullView.isHidden = false
            cell.feedback_stars.isHidden = false
            cell.cosmosView.isHidden = false
            cell.ratingNotAvailable.isHidden = true
            
            cell.feedback_stars.text = "5.0"
            cell.cosmosView.rating = 5.0
            
        } else {
        if feedbackStars == "null" || feedbackStars == "0" {
            cell.feedback_stars.isHidden = true
            cell.cosmosView.isHidden = true
            cell.nullView.isHidden = true
            cell.ratingNotAvailable.isHidden = false
        } else {
            cell.feedback_stars.isHidden = false
            cell.cosmosView.isHidden = false
            cell.nullView.isHidden = false
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
            if transporter_name != "CTS MOVE LTD" {
            transporter_id = self.viewAllBidsModel[indexPath.row].transporter_id
            self.performSegue(withIdentifier: "profile", sender: self)
            }
        }
        
        return cell
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
