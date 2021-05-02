//
//  UserDashboard.swift
//  CTS Move
//
//  Created by Fahad Baigh on 1/29/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SideMenu
import SDWebImage
import ZDCChat
import CoreLocation

var currentCoordinate : CLLocationCoordinate2D!
var userActiveJobs = "0"
var userInprogressJobs = "0"
var User_Inprogress_Jobs_Business = "0"
var userCompletedJobs = "0"
var User_Completed_Jobs_Business = "0"
var driver_earning = "0"
var driverEarning = ""
var ic_status = "Pending"
var dl_status = "Pending"

class TransporterDashboard: UIViewController {

    @IBOutlet weak var User_Active_Jobs: UIButton!
    @IBOutlet weak var User_Inprogress_Jobs: UIButton!
    @IBOutlet weak var User_Completed_Jobs: UIButton!
    @IBOutlet weak var Driver_earning: UIButton!
    @IBOutlet var updateView: UIView!
    @IBOutlet weak var sideBtn: UIBarButtonItem!
    @IBOutlet weak var liveChatOutlet: UIBarButtonItem!
    @IBOutlet weak var searchBtnOutlet: UIButton!
    @IBOutlet weak var activeBidView: UIView!
    @IBOutlet weak var bookedJobView: UIView!
    @IBOutlet weak var completedJobView: UIView!
    @IBOutlet weak var totalEarningView: UIView!
    @IBOutlet weak var logoStack: UIStackView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var actionStacks: UIStackView!
    
    
    @IBOutlet weak var bookJob_image: UIImageView!
    @IBOutlet weak var bookJob_icon: UIImageView!
    @IBOutlet weak var bookedJob_count_img: UIImageView!
    @IBOutlet weak var completed_job_img: UIImageView!
    @IBOutlet weak var completedJob_icon: UIImageView!
    @IBOutlet weak var completed_count_Img: UIImageView!
    @IBOutlet weak var total_earning_img: UIImageView!
    @IBOutlet weak var totalEarning_icon: UIImageView!
    
    
    
    let locationManager = CLLocationManager()
    let date = Date()
    let calendar = Calendar.current
    var initial_deposite: String?
    
    override func viewWillAppear(_ animated: Bool) {
        profileDetail()
        getCounter()
//         dashboard_darkMood()
    }
//
//    func dashboard_darkMood() {
//        let SwitchValue = UserDefaults.standard.bool(forKey: "mySwitch")
//        if SwitchValue == true {
//        self.backView.backgroundColor = UIColor(hexString: "191D20")
//        self.topView.backgroundColor = UIColor(hexString: "212528")
//        searchBtnOutlet.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
//        bookJob_image.image = UIImage(named: "darkMod_dashbord_completejobIcon-1")
//        completed_job_img.image = UIImage(named: "darkMod_dashbord_completejobIcon-1")
//        total_earning_img.image = UIImage(named: "darkMod_dashbord_completejobIcon-1")
//        bookJob_icon.image = UIImage(named: "darkMOd_dashbord_BookjobIcon")
//        completedJob_icon.image = UIImage(named: "darkMod_dashbord_completejobIcon")
//        totalEarning_icon.image = UIImage(named: "darkMod_dashbord_totalIcon")
//
//        bookedJob_count_img.image = UIImage(named: "darkmod_dashbord_countCircle")
//        completed_count_Img.image = UIImage(named: "darkmod_dashbord_countCircle")
//
//        searchBtnOutlet.setTitleColor(.white, for: .normal)
//        User_Inprogress_Jobs.setTitleColor(.white, for: .normal)
//        User_Completed_Jobs.setTitleColor(.white, for: .normal)
//        }
//        else{
//        self.backView.backgroundColor = UIColor.white
//        self.topView.backgroundColor = UIColor(hexString: "212528")
//        searchBtnOutlet.setBackgroundImage(UIImage(named: "login_btn"), for: .normal)
//        bookJob_image.image = UIImage(named: "post_job_btn")
//        completed_job_img.image = UIImage(named: "post_job_btn")
//        total_earning_img.image = UIImage(named: "post_job_btn")
//        bookJob_icon.image = UIImage(named: "bookJob")
//        completedJob_icon.image = UIImage(named: "completeJob")
//        totalEarning_icon.image = UIImage(named: "totalEarning")
//
//        bookedJob_count_img.image = UIImage(named: "circle")
//        completed_count_Img.image = UIImage(named: "circle")
//
//        searchBtnOutlet.setTitleColor(.black, for: .normal)
//        User_Inprogress_Jobs.setTitleColor(.black, for: .normal)
//        User_Completed_Jobs.setTitleColor(.black, for: .normal)
//        }
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title = "Dashboard"
        charges_api()
        checkLocationServices()
        checkStatus()
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuAnimationFadeStrength = 0.5
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        if (month == 4 && day! <= 30) || (month == 5 && day! < 30)  { //after sep 21 2019 app will active
            //do nothing
        } else {
        DispatchQueue.main.async {
            print("got it here")
            do {
                let update = try self.isUpdateAvailable()
                DispatchQueue.main.async {
                    if update == true {
                        self.updateView.layer.shadowColor = UIColor.darkGray.cgColor
                        self.updateView.layer.shadowOffset = .zero
                        self.updateView.layer.shadowOpacity = 2
                        self.view.addSubview(self.updateView)
                        self.updateView.center = self.view.center
                        self.sideBtn.isEnabled = false
                        self.liveChatOutlet.isEnabled = false
                        self.searchBtnOutlet.isUserInteractionEnabled = false
                        self.searchBtnOutlet.alpha = 0.3
                        self.topView.alpha = 0.3
                        self.activeBidView.alpha = 0.3
                        self.activeBidView.isUserInteractionEnabled = false
                        self.bookedJobView.alpha = 0.3
                        self.bookedJobView.isUserInteractionEnabled = false
                        self.completedJobView.alpha = 0.3
                        self.completedJobView.isUserInteractionEnabled = false
                        self.totalEarningView.alpha = 0.3
                        self.totalEarningView.isUserInteractionEnabled = false
                        self.backView.alpha = 0.3
                    }
                }
            } catch {
                print(error)
            }
        }
        }
    }
    
    func charges_api(){
         let charges_url = main_URL+"api/getLoadXCharges"
        if Connectivity.isConnectedToInternet() {
            Alamofire.request(charges_url, method : .get, parameters : nil).responseJSON {
                response in
            if response.result.isSuccess {
                let jsonData : JSON = JSON(response.result.value!)
                print("initial deposit value is: \n \(jsonData)")
                self.initial_deposite = jsonData[0]["loadxCharges"].stringValue
                print("initial charges value is:  \(self.initial_deposite ?? "")")
                UserDefaults.standard.set(self.initial_deposite, forKey: "initial_deposite_value")
            }else {
                print("this is the error of charges api \n \(response.result.error)") }
            }
       }else {
           let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    }
    
    @IBAction func search_btn(_ sender: Any) {
        self.performSegue(withIdentifier: "bookedJobs", sender: self)
           
    }
    func checkStatus() {
    if user_id != nil {
    let checkStatus_URL = main_URL+"api/userStatus"
    let parameters : Parameters = ["user_id" : user_id!]
    if Connectivity.isConnectedToInternet() {
    Alamofire.request(checkStatus_URL, method : .post, parameters : parameters).responseJSON {
    response in
    if response.result.isSuccess {
    SVProgressHUD.dismiss()
    
    let jsonData : JSON = JSON(response.result.value!)
    print("login jsonData is \(jsonData)")
    let result = jsonData[0]["result"].stringValue
    let message = jsonData[0]["message"].stringValue
    if result == "1" {
    
    } else {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "home") as! HomeViewController
            self.navigationController?.pushViewController(homeView, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    } else {
    SVProgressHUD.dismiss()
//    let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
//    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//    self.present(alert, animated: true, completion: nil)
    print("Error \(response.result.error!)")
    }
    }
    } else {
    SVProgressHUD.dismiss()
    
    }
    } else {
    SVProgressHUD.dismiss()
    
    }
    }
    
    func profileDetail() {
        if user_id != nil {
            let bookedJobs_URL = main_URL+"api/getTransporterProfileDetail"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(bookedJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("transporter Profile jsonData is \(jsonData)")
//                      let result = jsonData[0]["result"].stringValue
                        
                        ic_status = jsonData[0]["ic_status"].stringValue
                        dl_status = jsonData[0]["dl_status"].stringValue
                       if ic_status == "pending" || dl_status == "pending" {
                        let alert = UIAlertController(title: "Alert!", message: "Please wait for documents approval", preferredStyle: UIAlertController.Style.alert)
                        
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
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
                
            }
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        rateApp(appId: "id1458875857?mt=8") { (success) in
            print("Rateapp \(success)")
        }
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    func isUpdateAvailable() throws -> Bool {
        
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
           
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            
            let appStoreVersion  = Float(version)!
            let deviceVersion  = Float(currentVersion)!
            
            print("previous version is \(version) && current version is \(currentVersion)")
            
            return appStoreVersion > deviceVersion
//            return version != currentVersion
        }
        throw VersionError.invalidResponse
    }
   
//    override func viewDidAppear(_ animated: Bool) {
//        self.User_Active_Jobs.setTitle(userActiveJobs, for: .normal)
//        self.User_Inprogress_Jobs.setTitle(userInprogressJobs, for: .normal)
//        self.User_Completed_Jobs.setTitle(userCompletedJobs, for: .normal)
//        self.Driver_earning.setTitle("( £"+driver_earning+" )", for: .normal)
//        driverEarning = "( £"+driver_earning+" )"
//    }
    
    @IBAction func helpZendesk(_ sender: Any) {
        ZDCChat.start(in: self.navigationController, withConfig: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        if let vc = segue.destination as? PaymentHistoryController {
            vc.paymentHistory = self.Driver_earning.currentTitle
        }
    }
    
    func getCounter() {
//        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let counter_URL = main_URL+"api/transporterDashboardCounter"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(counter_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("counter jsonData is \(jsonData)")
                        userActiveJobs = jsonData[0]["User_Active_Jobs"].stringValue
                        self.User_Active_Jobs.setTitle(userActiveJobs, for: .normal)
                        
                        userInprogressJobs = jsonData[0]["User_Inprogress_Jobs"].stringValue
                        User_Inprogress_Jobs_Business = jsonData[0]["User_Inprogress_Jobs_Business"].stringValue
                       
                        let totalInProgress = jsonData[0]["User_Inprogress_Jobs"].intValue
//                        let totalInProgressBusiness = jsonData[0]["User_Inprogress_Jobs_Business"].intValue
                        
                        let totalInProgressJobs = totalInProgress
                        print("total in progress jobs is \(totalInProgressJobs)")
                        self.User_Inprogress_Jobs.setTitle(String(totalInProgressJobs), for: .normal)
                        
                        userCompletedJobs = jsonData[0]["User_Completed_Jobs"].stringValue
                        User_Completed_Jobs_Business = jsonData[0]["User_Completed_Jobs_Business"].stringValue
                        
                        let totalComplete = jsonData[0]["User_Completed_Jobs"].intValue
//                        let totalCompleteBusiness = jsonData[0]["User_Completed_Jobs_Business"].intValue
                        
                        let totalCompletedJobs = totalComplete
                        print("total in completed jobs is \(totalCompletedJobs)")
                        self.User_Completed_Jobs.setTitle(String(totalCompletedJobs), for: .normal)
                        
                        driver_earning = jsonData[0]["Driver_earning"].stringValue
                        if let roundedPrice = Double(driver_earning)?.rounded(toPlaces: 2) {
                        self.Driver_earning.setTitle("( £ \(roundedPrice) )", for: .normal)
                        driverEarning = "( £ \(roundedPrice) )"
                        }
                       self.view.layoutIfNeeded()
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
            }
        } else {
            SVProgressHUD.dismiss()
            
        }
    }
    
    @IBAction func activeJobs(_ sender: Any) {
        self.performSegue(withIdentifier: "activeJobs", sender: self)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //setup our location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //show alert letting the user know they have to turn this on
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            //show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //show an alert letting them know whats up
            break
        case.authorizedAlways:
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    @IBAction func totalEarning(_ sender: Any) {
        self.performSegue(withIdentifier: "payment", sender: self)
    }
    
    

}

extension TransporterDashboard: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
//      self.perform(#selector(performAction), with: nil, afterDelay: 5.0)
        
    }
    
//    @objc func performAction() {
//        self.locationManager.stopUpdatingLocation()
//    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
