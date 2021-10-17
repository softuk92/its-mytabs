//
//  JobDetial_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 30/01/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import SKPhotoBrowser

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEGHT = UIScreen.main.bounds.height

class JobDetial_ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
   
//    var jobDetial : JobDetial_ViewController?
    
    
    @IBOutlet weak var movingItem_lbl: UILabel!
    @IBOutlet weak var price_lbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var email_popview: UIView!
    @IBOutlet var call_popView: UIView!
    
    var previousVC: UIViewController?
    var showingIndex: Int = 0
    var pageVC: UIPageViewController?
    var images = [SKPhoto]()
    var userId = ""
    var showHouseNumber = false
    
    @IBOutlet var viewOfTop: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var Location_btn: UIButton!
    @IBOutlet weak var jobSummary_btn: UIButton!
    @IBOutlet weak var Contact_btn: UIButton!
    @IBOutlet var viewOfLocation: UIView!
    @IBOutlet var viewOfJobSummary: UIView!
    @IBOutlet var viewOfContact: UIView!
    @IBOutlet weak var loaderView: UIView!
    
    var phoneNumber: String?
    
    var bookedJobPrice : String?
    var long_dropoff : String?
    var long_pickup : String?
    var lat_pickup : String?
    var lat_dropoff : String?

    var pickupAdd: String?
    var dropoffAdd: String?
    var distance: String?
    var fuelCost: String?
    var jsonDataPArse : JSON = []
    var jsonPrfileData : JSON = []
    
    var location: Bool?
    var jobSummary: Bool?
    var contact: Bool?
    
    var selectSearchJob: Bool?
    var receiverName: String?
    var receiverPhone: String?
    
    override func viewDidLoad() {
        // change selected bar color
        
        innerView.layer.shadowColor = UIColor.darkGray.cgColor
        innerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        innerView.layer.shadowOpacity = 0.4
        innerView.layer.shadowRadius = 3.0
        
        super.viewDidLoad()
//        self.automaticallyAdjustsScrollViewInsets = false
        get_contact_no()
       
        getDetailOfJob()
        location = false
        jobSummary = true
        contact = true
        viewOfLocation.isHidden = false
        viewOfJobSummary.isHidden = true
        viewOfContact.isHidden = true
        // Do any additional setup after loading the view.
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setDefaultStyle(.dark)
    }
   
    func getDetailOfJob() {
           SVProgressHUD.show(withStatus: "Getting job details...")
        loaderView.isHidden = false
           if del_id != nil {
               let jobDetail_URL = main_URL+"api/job_detail"
               let parameters : Parameters = ["del_id" : del_id!]
               if Connectivity.isConnectedToInternet() {
                   Alamofire.request(jobDetail_URL, method : .post, parameters : parameters).responseJSON { [weak self]
                       response in
                    guard let self = self else { return }
                       if response.result.isSuccess {
                           SVProgressHUD.dismiss()
                        self.loaderView.isHidden = true
                    self.jsonDataPArse = JSON(response.result.value!)
//                        print("this is the job detial api result: \(self.jsonDataPArse)")
                        
//                        print("this is the job detial api inventory list result:-- \(self.jsonDataPArse[1])")
                        
                        self.movingItem_lbl.text = self.jsonDataPArse[0]["moving_item"].stringValue
                        self.price_lbl.text = AppUtility.shared.currencySymbol+(Int(self.jsonDataPArse[0]["Price"].stringValue)?.withCommas() ?? "0.0")
                        
                        self.userId = self.jsonDataPArse[0]["user_id"].stringValue
                        self.receiverName = self.jsonDataPArse[0]["receiver_name"].stringValue
                        self.receiverPhone = self.jsonDataPArse[0]["receiver_phone"].stringValue
                        self.showProfile()
                    self.setPager()
                    self.view.bringSubviewToFront(self.viewOfTop)
                               
                       }else{

                    }
                    
                }}else{
                
                
                    
            }}else{
            
        }
        
    }
   
    
    @IBAction func back_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func phoneBtn_action(_ sender: Any) {
      if selectSearchJob == true {
      let alert = UIAlertController(title: "Warning", message: "This Job is not booked yet, Phone number is protected", preferredStyle: UIAlertController.Style.alert)
                        
                 alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
      }else{
       
        UIView.animate(withDuration: 0.3, animations: {
//            self.call_popView.layer.borderColor = UIColor.gray.cgColor
          //  self.call_popView.layer.borderWidth = 1
            self.call_popView.layer.cornerRadius = 18
             //            self.tableView.alpha = 0.5
            self.view.addSubview(self.call_popView)
            self.call_popView.center = self.view.center
              })
        }
    }
    
    @IBAction func phone_popview_Yesbtn(_ sender: Any) {
//         let url = URL(string: "tel://\(self.phoneNumber)")
            
        makePhoneCall(phoneNumber: (self.phoneNumber!) )
//            UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
        }
    
    func makePhoneCall(phoneNumber: String) {

        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {

            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func phone_popview_noBtn(_ sender: Any) {
        self.call_popView.removeFromSuperview()
    }
    
        
    
    @IBAction func emailBtn_action(_ sender: Any) {
        if selectSearchJob == true {
            let alert = UIAlertController(title: "Warning", message: "Job is not Booked Yet, Email is Protected", preferredStyle: UIAlertController.Style.alert)
      
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
       
        }else{
 
                UIView.animate(withDuration: 0.3, animations: {
                    self.email_popview.layer.borderColor = UIColor.gray.cgColor
                    self.email_popview.layer.borderWidth = 1
                    self.email_popview.layer.cornerRadius = 18
                   //            self.tableView.alpha = 0.5
                    self.view.addSubview(self.email_popview)
                    self.email_popview.center = self.view.center
                })
        
        }
        
          
        
    }
    @IBAction func emailPopUp_yesBtn(_ sender: Any) {
        let email = "info@loadx.co.uk"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
    }
    @IBAction func emailPopUp_noBtn(_ sender: Any) {
        self.email_popview.removeFromSuperview()
    }
    
    @IBAction func image1Viewer(_ sender: Any) {
           let browser = SKPhotoBrowser(photos: images)
           browser.initializePageIndex(0)
           present(browser, animated: true, completion: nil)
       }

    func showProfile() {
       //        SVProgressHUD.show(withStatus: "Getting details...")
        if self.userId != "" {
                   let editProfileData_URL = main_URL+"api/userProfileDetail"
                   let parameters : Parameters = ["user_id" : userId]
                   if Connectivity.isConnectedToInternet() {
                       Alamofire.request(editProfileData_URL, method : .post, parameters : parameters).responseJSON { [weak self]
                           response in
                        guard let self = self else { return }
                           if response.result.isSuccess {
                               SVProgressHUD.dismiss()
                            self.loaderView.isHidden = true
                               
                             self.jsonPrfileData = JSON(response.result.value!)
                            print("show Profile Data is \(self.jsonPrfileData)")
                         
                           } else {
                               SVProgressHUD.dismiss()
                            self.loaderView.isHidden = true
                            let alert = UIAlertController(title: "Alert", message: response.error?.localizedDescription ?? "", preferredStyle: UIAlertController.Style.alert)
                               alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                               self.present(alert, animated: true, completion: nil)
                               print("Error \(response.result.error!)")
                           }
                       }
                   } else {
                       SVProgressHUD.dismiss()
                    self.loaderView.isHidden = true
                       let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                       alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                       self.present(alert, animated: true, completion: nil)
                   }
               } else {
                   SVProgressHUD.dismiss()
                self.loaderView.isHidden = true
                   
               }
           }
    
    func get_contact_no(){
        SVProgressHUD.show(withStatus: "Please wait...")
        loaderView.isHidden = false
        let url = main_URL+"api/get_phone_no"
        
        if Connectivity.isConnectedToInternet() {
            Alamofire.request(url, method : .get, parameters : nil).responseJSON { [weak self]
                response in
                guard let self = self else { return }
                if  response.result.isSuccess {
                    SVProgressHUD.dismiss()
                    self.loaderView.isHidden = true
                    let jsonData : JSON = JSON(response.result.value!)
                    print("Contact Number is :.......\(jsonData)")
                    
                    let show_phone_num = jsonData[0]["phone_no"].string
                    print(show_phone_num!)
//                    self.phone_btn.setTitle("Phone: \(show_phone_num!) (9am to 9pm)", for: .normal)
                  
                    self.phoneNumber = jsonData[0]["phone_w_code"].string
                    UserDefaults.standard.set(self.phoneNumber!, forKey: "phoneNumber")
                    print(self.phoneNumber!)
                    
                }else{
                    SVProgressHUD.dismiss()
                    self.loaderView.isHidden = true
                    let alert = UIAlertController(title: "Error", message: response.result.error?.localizedDescription ?? "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            SVProgressHUD.dismiss()
            self.loaderView.isHidden = true
            let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil) 
        }
    }
 
    
    @IBAction func location_btn(_ sender: Any) {
        if location == true {
        let startVC = viewControllerAtIndex(tempIndex: 0)
                       _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            location = false
            jobSummary = true
            contact = true
            viewOfLocation.isHidden = false
            viewOfJobSummary.isHidden = true
            viewOfContact.isHidden = true
    }
    }
    @IBAction func jobSummary_action(_ sender: Any) {
        if jobSummary == true {
        let startVC = viewControllerAtIndex(tempIndex: 1)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
        location = true
        jobSummary = false
        contact = true
        viewOfLocation.isHidden = true
        viewOfJobSummary.isHidden = false
        viewOfContact.isHidden = true
        }
    }
                                                                
    @IBAction func contact_action(_ sender: Any) {
        if contact == true {
        let startVC = viewControllerAtIndex(tempIndex: 2)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        location = true
        jobSummary = true
        contact = false
        viewOfLocation.isHidden = true
        viewOfJobSummary.isHidden = true
        viewOfContact.isHidden = false
        }
    }
func setPager() {
        pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewControllerMain") as! UIPageViewController?
        pageVC?.dataSource = self
        pageVC?.delegate = self
        let startVC = viewControllerAtIndex(tempIndex: 0)
        _ = startVC.view
        
        pageVC?.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        pageVC?.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEGHT)
        self.addChild(pageVC!)
        self.view.addSubview((pageVC?.view)!)
        self.pageVC?.didMove(toParent: self)
        
    }
    
     func viewControllerAtIndex(tempIndex: Int) -> UIViewController {
         
            if tempIndex == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "location_ViewController") as! location_ViewController
                vc.jsonData = self.jsonDataPArse
                vc.showHouseNumber = self.showHouseNumber
                vc.pickupAddress = self.pickupAdd
                vc.dropOffAddress = self.dropoffAdd
                return vc
            }
            else if tempIndex == 1 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Job_Summary_ViewController" ) as! Job_Summary_ViewController
//                vc.index = 1
                vc.isJobNotBooked = selectSearchJob
                vc.jsonData = self.jsonDataPArse
                vc.jsonData_inventory = self.jsonDataPArse[1]
                
                return vc
            } else  {
                 let vc = self.storyboard?.instantiateViewController(withIdentifier: "Contact_ViewController") as! Contact_ViewController
//                 vc?.index = 2
                vc.selectJob = selectSearchJob
                vc.jsonData = self.jsonPrfileData
                vc.receiverN = self.receiverName
                vc.receiverP = self.receiverPhone
                 return vc
                
             }
         }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }


}
