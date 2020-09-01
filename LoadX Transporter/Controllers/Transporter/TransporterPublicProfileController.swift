//
//  TransporterPublicProfileController.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/26/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON
import IBAnimatable
import SVProgressHUD
import SDWebImage
import SKPhotoBrowser

class TransporterPublicProfileController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var parent_view: UIView!
    @IBOutlet weak var transporterImage: UIImageView!
    @IBOutlet weak var transporter_van_image: UIImageView!
    @IBOutlet weak var transporter_name: UILabel!
    @IBOutlet weak var transporterPartner: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var about_me: UITextView!
    @IBOutlet weak var uk_lbl: UILabel!
    @IBOutlet weak var van_type: UILabel!
    @IBOutlet weak var vehicle_reg_no: UILabel!
    @IBOutlet weak var jobs_done: UILabel!
    @IBOutlet weak var total_bids: UILabel!
    @IBOutlet weak var member_since: UILabel!
    @IBOutlet weak var accepted_bid: UILabel!
    @IBOutlet weak var on_time: UILabel!
    @IBOutlet weak var on_budget: UILabel!
    @IBOutlet weak var payment_option: UILabel!
    @IBOutlet weak var noQuotes: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var verifiedView: UIView!
    @IBOutlet weak var notAvailable: UILabel!
    @IBOutlet weak var nullView: UIView!
    @IBOutlet weak var nullValue: UILabel!
    
    @IBOutlet weak var AcceptedBid_lbl: UILabel!
    @IBOutlet weak var totalBids_lbl: UILabel!
    @IBOutlet weak var jobDone_lbl: UILabel!
    @IBOutlet weak var about_lbl: UILabel!
    @IBOutlet weak var additional_info_lbl: UILabel!
    @IBOutlet weak var vanType_lbl: UILabel!
    @IBOutlet weak var vehicleRegNo_lbl: UILabel!
    @IBOutlet weak var Member_lbl: UILabel!
    @IBOutlet weak var onTime_lbl: UILabel!
    @IBOutlet weak var onBudget: UILabel!
    @IBOutlet weak var paymentOption_lbl: UILabel!
    
    @IBOutlet weak var customerFeedBack: AnimatableTextField!
    
    @IBOutlet weak var image_view: UIView!
    @IBOutlet weak var aboutMe_view: UIView!
    @IBOutlet weak var price_view: UIView!
    @IBOutlet weak var info_view: UIView!
    @IBOutlet weak var additional_info_view: UIView!
    
    
    let switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    
    lazy var transporterProfileFeedbackModel = [TransporterProfileFeedbackModel]()
    var images = [SKPhoto]()
    
    override func viewWillAppear(_ animated: Bool) {
        showProfile()
        getAllReviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Transporter Profile"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = topView
        tableView.estimatedRowHeight = 168.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "ManageReviewsCell", bundle: nil) , forCellReuseIdentifier: "manageReviews")
        about_me.flashScrollIndicators()
        DarkMode()
    }
   
    func DarkMode(){
        if switchCheck == true {
            self.parent_view.backgroundColor = UIColor.black
            self.image_view.backgroundColor = UIColor.darkGray
            self.price_view.backgroundColor = UIColor.darkGray
            self.info_view.backgroundColor = UIColor.darkGray
            self.aboutMe_view.backgroundColor = UIColor.darkGray
            self.additional_info_view.backgroundColor = UIColor.darkGray
            self.additional_info_lbl.textColor = UIColor.white
            
            self.transporter_name.textColor = UIColor.white
            self.transporterPartner.textColor = UIColor.white
            self.uk_lbl.textColor = UIColor.white
            self.about_lbl.textColor = UIColor.white
            self.about_me.textColor = UIColor.white
            self.jobs_done.textColor = UIColor.white
            
            self.jobDone_lbl.textColor = UIColor.white
            self.total_bids.textColor = UIColor.white
            self.totalBids_lbl.textColor = UIColor.white
            self.accepted_bid.textColor = UIColor.white
            self.AcceptedBid_lbl.textColor = UIColor.white
           
            self.vanType_lbl.textColor = UIColor.white
            self.van_type.textColor = UIColor.white
            self.vehicle_reg_no.textColor = UIColor.white
            self.vehicleRegNo_lbl.textColor = UIColor.white
            self.Member_lbl.textColor = UIColor.white
            self.member_since.textColor = UIColor.white
            self.on_time.textColor = UIColor.white
            self.onTime_lbl.textColor = UIColor.white
            self.onBudget.textColor = UIColor.white
            self.on_budget.textColor = UIColor.white
            self.payment_option.textColor = UIColor.white
            self.paymentOption_lbl.textColor = UIColor.white
            
            customerFeedBack.background = UIImage(named: "darkMood_yellowBtn")
            customerFeedBack.textColor = UIColor.white
            
            noQuotes.textColor = UIColor.white
            
        }else{
            
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

    @IBAction func aboutMe(_ sender: Any) {
        let alert = UIAlertController(title: "About Me", message: self.about_me.text, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showProfile() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if transporter_id != nil {
            let editProfileData_URL = main_URL+"api/transporterPublicProfile"
            let parameters : Parameters = ["user_id" : transporter_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(editProfileData_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("show Transporter Profile jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        
                        if result != "0" {
                        let userName = jsonData[0]["user_name"].stringValue
                        self.transporter_name.text = userName.capitalized
                        let feedbackStars = jsonData[0]["avgfdbck"].stringValue
                        if feedbackStars == "null" || feedbackStars == "0" {
                            self.cosmosView.isHidden = true
                            self.nullView.isHidden = true
                            self.nullValue.isHidden = true
                            self.notAvailable.isHidden = false
                            } else {
                            self.cosmosView.isHidden = false
                            self.nullValue.isHidden = false
                            self.nullView.isHidden = false
                            self.notAvailable.isHidden = true
                                
                        if let roundedValue1 = Double(feedbackStars)?.rounded(toPlaces: 1) {
                                    self.cosmosView.rating = roundedValue1
                                    let distanceString = String(roundedValue1)
                                    self.nullValue.text = distanceString
                                }
                            }
                        let aboutMe = jsonData[0]["about_me"].stringValue
                        if aboutMe != "" {
                            self.about_me.text = aboutMe
                        } else {
                            self.about_me.text = "No info..."
                        }
                        let vanType = jsonData[0]["van_type"].stringValue
                            
                        if vanType != "" {
                            if vanType == "SWB Van" {
                            self.van_type.text = "Small Van"
                            } else if vanType == "MWB Van" {
                            self.van_type.text = "Medium Van"
                            } else if vanType == "LWB Van" {
                            self.van_type.text = "Large Van"
                            } else {
                            self.van_type.text = vanType
                            }
                        } else {
                            self.van_type.text = "N/A"
                        }
                        let vehicleRegN = jsonData[0]["truck_registration"].stringValue
                        if vehicleRegN != "" {
                            self.vehicle_reg_no.text = vehicleRegN.uppercased()
                        } else {
                            self.vehicle_reg_no.text = "N/A"
                        }
                        self.jobs_done.text = jsonData[0]["jobs_done"].stringValue
                        self.total_bids.text = jsonData[0]["offer_bid"].stringValue
                        
                        let stringDate = jsonData[0]["join_date"].stringValue
                        let convertedDate = self.convertDateFormatter(stringDate)
                        self.member_since.text = convertedDate
                        
                        self.accepted_bid.text = jsonData[0]["accepted_bid"].stringValue
                        self.on_time.text = jsonData[0]["total_count_on_time_yes"].stringValue+"%"
                        self.on_budget.text = jsonData[0]["total_count_on_budget_yes"].stringValue+"%"
                        self.payment_option.text = "Cash/Bank Transfer"
                        
                        let image1 = jsonData[0]["user_image_url"].stringValue
                        let image2 = jsonData[0]["van_img"].stringValue
                        let image3 = jsonData[0]["copy_driving_license"].stringValue
                        if image1 != "" {
                            let urlString = main_URL+"assets/user_profile_image/"+image1
                            if let url = URL(string: urlString) {
                                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                    if let imageCell = imageReceived {
                                        let photo1 = SKPhoto.photoWithImage(imageCell)
                                        self.transporterImage.image = imageCell
                                        self.images.append(photo1)
                                        
                                    }
                                }
                            }
                            
                        } else {
                            let photo1 = SKPhoto.photoWithImage(self.transporterImage.image!)
                            self.images.append(photo1)
                        }
                        
                        if image2 != "" {
                            let urlString = main_URL+"assets/user_profile_image/"+image2
                            if let url = URL(string: urlString) {
                                SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: { (received, expected, nil) in
                                }) { (imageReceived, imageData, error, SDImageCache, true, imageURLString) in
                                    if let imageCell = imageReceived {
                                        let photo2 = SKPhoto.photoWithImage(imageCell)
                                        self.transporter_van_image.image = imageCell
                                        self.images.append(photo2)
                                    }
                                }
                            }
                        } else {
                            let photo2 = SKPhoto.photoWithImage(self.transporter_van_image.image!)
                            self.images.append(photo2)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                            if image3 != "" && self.transporterImage.image != UIImage(named: "transporterImage-1")
                            {
                                self.verifiedView.isHidden = false
                            } else {
                                self.verifiedView.isHidden = true
                            }
                        })
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
    
    func getAllReviews() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if transporter_id != "" {
            let activeJobs_URL = main_URL+"api/transporter_profile_feedback"
            let parameters : Parameters = ["user_id" : transporter_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(activeJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("all reviews jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        
                        if result == "0" {
                            self.noQuotes.isHidden = false
                            
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.transporterProfileFeedbackModel = try JSONDecoder().decode([TransporterProfileFeedbackModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    print(self.transporterProfileFeedbackModel)
                                    
                                    DispatchQueue.main.async {
                            
                                        self.noQuotes.isHidden = true
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
            let alert = UIAlertController(title: "Error", message: "Internet connection is missing", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transporterProfileFeedbackModel.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 160
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageReviews") as! ManageReviewsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        
        cell.innerView.layer.shadowColor = UIColor.gray.cgColor
        cell.innerView.layer.shadowOffset = .zero
        cell.innerView.layer.shadowOpacity = 1
        
        if switchCheck == true {
                 tableView.backgroundColor = UIColor.black
                 cell.innerView.backgroundColor = UIColor.darkGray
                 cell.feed_date.textColor = UIColor.white
                 cell.feedback_stars.textColor = UIColor.black
                 cell.job_description.textColor = UIColor.white
                 cell.job_title.textColor = UIColor.white
                 cell.transporter_name.textColor = UIColor.white
                 cell.feed_date_icon.image = UIImage(named: "deliveryDateDark")
            
        }
        
        let allReviews = transporterProfileFeedbackModel[indexPath.row]
        
        let transporterName = allReviews.user_name
        cell.transporter_name.text = transporterName.capitalized
        cell.job_title.text = allReviews.job_title
        cell.job_description.text = allReviews.description
        let stringDate = allReviews.feed_date
        let convertedDate = self.convertDateFormatter(stringDate)
        cell.feed_date.text = convertedDate
        
        cell.cosmosView.isUserInteractionEnabled = false
        let feedbackStars = allReviews.feed_back_star
        
        if feedbackStars == "null" {
            cell.feedback_stars.text = "null"
            cell.cosmosView.rating = 0.0
        } else {
            cell.feedback_stars.text = allReviews.feed_back_star+".0"
            cell.cosmosView.rating = Double(feedbackStars)!
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
