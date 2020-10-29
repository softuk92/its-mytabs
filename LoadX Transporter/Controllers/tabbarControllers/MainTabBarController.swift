//
//  MainTabBarController.swift
//  Loadx
//
//  Created by CTS Move on 21/01/2020.
//  Copyright © 2020 Soft_PVT_LTD. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SDWebImage
import SVProgressHUD
import CoreLocation


class MainTabBarController: UITabBarController  , UITabBarControllerDelegate {

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
    
    @IBOutlet var updateView: UIView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
 
    let date = Date()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
//          appDelegate.searchBtn_bool = true
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        self.selectedIndex = 2
        getCounter()
        let components = calendar.dateComponents([.year, .month, .day], from: date)
            
            let year =  components.year
            let month = components.month
            let day = components.day
            
        if(month == 12 && day == 9 && year == 2019) || (month == 12 && day == 10 && year == 2019) || (month == 12 && day == 11 && year == 2019)  {
            
            } else {
                DispatchQueue.global().async {
                do {
                    let update = try self.isUpdateAvailable()
                        DispatchQueue.main.async {
                    if update == true {
//                        self.updateView.layer.shadowColor = UIColor.darkGray.cgColor
//                        self.updateView.layer.shadowOffset = .zero
//                        self.updateView.layer.shadowOpacity = 2
//                        self.view.addSubview(self.updateView)
//
//                        self.updateView.center = self.view.center
                        }
                    }
                } catch {
                    print(error)
                    }
                }
            }
    }
    
    @IBAction func updateApp(_ sender: Any) {
        rateApp { (sucess) in
            print(sucess)
        }
    }
    
    func rateApp(completion: @escaping ((_ success: Bool)->())) {
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/id1458875857?mt=8") else {
                completion(false)
                return
            }
            guard #available(iOS 10, *) else {
                completion(UIApplication.shared.openURL(url))
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }

    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexOfTab = tabBar.items?.index(of: item)
        if indexOfTab == 2 {
            appDelegate.searchBtn_bool = true
            NotificationCenter.default.post(name: Notification.Name("SearchBarSelect"), object: nil)

        }
    }
     //MARK: - Version Update Func
     /***************************************************************/
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
                 print("previous version is \(version) && current version is \(currentVersion)")
                 let  DeviceCurrentVersion = Float(currentVersion)!
                 let  appStoreVersion = Float(version)!
     
                 return DeviceCurrentVersion > appStoreVersion
     //            return version != currentVersion
             }
             throw VersionError.invalidResponse
         }

        func getCounter() {
            SVProgressHUD.show(withStatus: "Getting details...")
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
                            self.userActiveJobs = jsonData[0]["User_Active_Jobs"].stringValue
                           
                            
                            self.userInprogressJobs = jsonData[0]["User_Inprogress_Jobs"].stringValue
                            UserDefaults.standard.set(self.userInprogressJobs, forKey: "Book_job")
                            
                            self.User_Inprogress_Jobs_Business = jsonData[0]["User_Inprogress_Jobs_Business"].stringValue
                           
                            let totalInProgress = jsonData[0]["User_Inprogress_Jobs"].intValue
                           
                            let totalInProgressJobs = totalInProgress
                            print("total in progress jobs is \(totalInProgressJobs)")
                           
                            self.userCompletedJobs = jsonData[0]["User_Completed_Jobs"].stringValue
                            UserDefaults.standard.set(jsonData[0]["User_Completed_Jobs_sidebar"].stringValue, forKey: "complete_jobs")
//                                jsonData[0]["User_Completed_Jobs_sidebar"].stringValue
                            UserDefaults.standard.set(self.userCompletedJobs, forKey: "complete_job")
                            
                            self.User_Completed_Jobs_Business = jsonData[0]["User_Completed_Jobs_Business"].stringValue
                            
                            let totalComplete = jsonData[0]["User_Completed_Jobs"].intValue
                           
                            
                            let totalCompletedJobs = totalComplete
                            print("total in completed jobs is \(totalCompletedJobs)")
                         
                            self.driver_earning = jsonData[0]["Driver_earning"].stringValue
                            
                            if let roundedPrice = Double(self.driver_earning)?.rounded(toPlaces: 2) {
                         
                                self.driverEarning = String(format: "%.2f", roundedPrice)
//                                "£ \(roundedPrice)"
                                UserDefaults.standard.set(self.driverEarning, forKey: "total_earning")
                                                          
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
    
}
