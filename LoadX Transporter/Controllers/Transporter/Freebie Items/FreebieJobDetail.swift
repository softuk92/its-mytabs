//
//  File.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 4/5/19.
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

class FreebieJobDetail: UIViewController, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var pick_up: UILabel!
    @IBOutlet weak var job_description: UITextView!
    @IBOutlet weak var job_id: CopyableLabel!
    @IBOutlet weak var add_type: UILabel!
    @IBOutlet weak var moving_from: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var timeslot: UILabel!
    @IBOutlet weak var job_posted_date: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email_address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mapViewX: GMSMapView!
    @IBOutlet weak var lowest_bid: UILabel!
    @IBOutlet weak var jobSummaryView: UIView!
    @IBOutlet weak var userInformationView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var lowestBidLabel: UILabel!
    @IBOutlet weak var jobSummaryArrow: UIImageView!
    @IBOutlet weak var userInfoArrow: UIImageView!
    
    let year = Calendar.current.component(.year, from: Date())
    lazy var viewAllBidsModel = [ViewAllBidsModel]()
    var images = [SKPhoto]()
    var userId = ""
    var menuShowing = false
    var menuShowing1 = false
    var HEADER_HEIGHT = 815
    var puStreet_Route = ""
    var pu_City_Route = ""
    var pu_allAddress = ""
    
    override func viewWillAppear(_ animated: Bool) {
        getDetailOfJob()
        
        jobSummaryView.isHidden = true
        userInformationView.isHidden = true
        let jobID = "LOADX"+String(year)+"F"+frbi_id!
        self.job_id.text = jobID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Job Details"
        
        mapViewX.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = topView
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
        tableView.register(UINib(nibName: "AcceptBidCell", bundle: nil) , forCellReuseIdentifier: "acceptBid")
    }
    
    @IBAction func jobDescription(_ sender: Any) {
        let alert = UIAlertController(title: "Job Description", message: self.job_description.text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func movingTitle(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Job Title", message: self.job_description.text, preferredStyle: UIAlertController.Style.alert)
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
                        self.HEADER_HEIGHT = 1010
                    } else {
                        self.HEADER_HEIGHT = 1192
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
                        self.HEADER_HEIGHT = 1010
                    } else {
                        self.HEADER_HEIGHT = 1192
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
                    self.HEADER_HEIGHT = 718
                } else {
                    self.HEADER_HEIGHT = 901
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
                        self.HEADER_HEIGHT = 1192
                    } else {
                        self.HEADER_HEIGHT = 901
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
                        self.HEADER_HEIGHT = 1192
                    } else {
                        self.HEADER_HEIGHT = 901
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
                    self.HEADER_HEIGHT = 720
                } else {
                    self.HEADER_HEIGHT = 1010
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
        SVProgressHUD.showInfo(withStatus: self.pick_up.text)
    }
    
    func getDetailOfJob() {
        SVProgressHUD.show(withStatus: "Getting job details...")
        if del_id != "" {
            let jobDetail_URL = main_URL+"api/freeBieDetail"
            let parameters : Parameters = ["frbi_id" : frbi_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(jobDetail_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("job detail jsonData is \(jsonData)")
                        
                        self.lowest_bid.text = jsonData[0]["frbi_item_status"].stringValue
                        
                        let movingItem = jsonData[0]["moving_item"].stringValue
                        self.moving_item.text = movingItem.capitalized
                        
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
                        
                        let jobDescription = jsonData[0]["description"].stringValue
                        
                        if jobDescription != "" {
                            self.job_description.text = jobDescription
                        } else {
                            self.job_description.text = "N/A"
                        }
                        
                        
                        self.timeslot.text = jsonData[0]["timeslot"].stringValue
                        
                        self.add_type.text = jsonData[0]["add_type"].stringValue
                        
                        
                        
                        
                        let stringJobPostedDate = jsonData[0]["job_posted_date"].stringValue
                        let convertedJobPostedDate = self.convertDateFormatter(stringJobPostedDate)
                        self.job_posted_date.text = convertedJobPostedDate
                        
                        let stringDate = jsonData[0]["date"].stringValue
                        let convertedDate = self.convertDateFormatter(stringDate)
                        self.date.text = convertedDate
                        self.moving_from.text = jsonData[0]["moving_from"].stringValue
                        
                        let full_nameUser = jsonData[0]["user_name"].stringValue
                        self.fullName.text = full_nameUser.capitalized
                        
                        lat_pickup = Double(jsonData[0]["lat_pickup"].stringValue)
                        long_pickup = Double(jsonData[0]["long_pickup"].stringValue)
                        
                        
                        self.jobDetailMap()
                        let image1 = jsonData[0]["image1"].stringValue
                        let image2 = jsonData[0]["image2"].stringValue
                        let image3 = jsonData[0]["image3"].stringValue
                        
                        if image1 != "" {
                            let urlString = main_URL+"public/assets/job_images/"+image1
                            if let url = URL(string: urlString) {
                                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                    if let imageCell = imageReceived {
                                        
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
        if lat_pickup != nil && long_pickup != nil {
            let position = CLLocationCoordinate2D(latitude: lat_pickup!, longitude: long_pickup!)
            let marker = GMSMarker(position: position)
            marker.title = "Pickup Location"
            marker.map = self.mapViewX
            let sydney = GMSCameraPosition.camera(withLatitude: lat_pickup!,
                                                  longitude: long_pickup!,
                                                  zoom: 1000)
            mapViewX.camera = sydney
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
                            
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.viewAllBidsModel = try JSONDecoder().decode([ViewAllBidsModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    print(self.viewAllBidsModel)
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewAllBidsModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "acceptBid") as! AcceptBidCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        cell.transporter_name.text = viewAllBidsModel[indexPath.row].transporter_name
        cell.current_bid.text = "£"+viewAllBidsModel[indexPath.row].current_bid
        let feedbackStars = viewAllBidsModel[indexPath.row].avg_feedback
        cell.cosmosView.isUserInteractionEnabled = false
        if feedbackStars == "null" || feedbackStars == "0" {
            cell.nullView.isHidden = true
            cell.cosmosView.isHidden = true
            cell.ratingNotAvailable.isHidden = false
        } else {
            cell.nullView.isHidden = false
            cell.cosmosView.isHidden = false
            cell.ratingNotAvailable.isHidden = true
            
            if let roundedValue1 = Double(feedbackStars)?.rounded(toPlaces: 1) {
                let distanceString = String(roundedValue1)
                cell.feedback_stars.text = distanceString
                cell.cosmosView.rating = Double(feedbackStars)!
            }
            
        }
        
        cell.transporterProfileRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            transporter_id = self.viewAllBidsModel[indexPath.row].transporter_id
            self.performSegue(withIdentifier: "profile", sender: self)
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
