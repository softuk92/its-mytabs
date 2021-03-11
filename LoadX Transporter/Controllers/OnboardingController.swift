//
//  ViewController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 1/22/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
//import paper_onboarding
import YouTubePlayer
import Alamofire
import QuickLook
import SVProgressHUD
import QuickLook
import SwiftyJSON

class OnboardingController: UIViewController {
    
//    @IBOutlet weak var onboardingView: PaperOnboarding!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var watchVideo: UIButton!
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet var updateView: UIView!
    @IBOutlet weak var viewLine: UIView!
    let url = URL(string: "https://www.youtube.com/watch?v=ZRe1Q1fa4DU")
    var boolValue : Bool?
    let url2 = URL(string: main_URL+"public/assets/user-manuals/transport-partner-manual.pdf")
   
    var initial_deposite: String?
    
    let sb = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popOverView.layer.cornerRadius = 10
//        onboardingView.dataSource = self
//        onboardingView.delegate = self
//        charges_api()
        
        if url != nil {
            videoPlayer.loadVideoURL(url!)
        }
        
    }
//
//    func charges_api(){
//         let charges_url = main_URL+"api/getLoadXCharges"
//        if Connectivity.isConnectedToInternet() {
//            Alamofire.request(charges_url, method : .get, parameters : nil).responseJSON {
//                response in
//            if response.result.isSuccess {
//                let jsonData : JSON = JSON(response.result.value!)
//                print("initial deposit value is: \n \(jsonData)")
//                self.initial_deposite = jsonData[0]["loadxCharges"].stringValue
//                print("initial charges value is:  \(self.initial_deposite)")
//                UserDefaults.standard.set(self.initial_deposite, forKey: "initial_deposite_value")
//            }else {
//                print("this is the error of charges api \n \(response.result.error)") }
//            }
//       }else {
//           let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
//           alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
//           self.present(alert, animated: true, completion: nil)
//       }
//    }
    
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

    /*
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
//        let backgroundColorOne = UIColor(red: 35/255, green: 35/255, blue: 35/255, alpha: 1)
        let backgroundColorOne = UIColor.init(hexString: "EAEAEA")
        //        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        //        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        
        let titleFont = UIFont(name: "Montserrat-Bold", size: 22)
        let descriptionFont = UIFont(name: "Montserrat-Light", size: 16)
        
        return [
            OnboardingItemInfo(informationImage: UIImage(named: "register")!,
                               title: "Registration",
                               description: "Submit your details along with your documents.",
                               pageIcon: UIImage(named: "pageIconSelected")!,
                               color: backgroundColorOne,
                               titleColor: UIColor.black,
                               descriptionColor: UIColor.lightGray,
                               titleFont: titleFont!,
                               descriptionFont: descriptionFont!),
            OnboardingItemInfo(informationImage: UIImage(named: "searchDeliveries")!,
                                                                                      title: "Search Deliveries",
                                                                                      description: "Search for deliveries in your area or across the country.",
                                                                                      pageIcon: UIImage(named: "pageIconSelected")!,
                                                                                      color: backgroundColorOne,
                                                                                      titleColor: UIColor.black,
                                                                                      descriptionColor: UIColor.lightGray,
                                                                                      titleFont: titleFont!,
                                                                                      descriptionFont: descriptionFont!),
            OnboardingItemInfo(informationImage: UIImage(named: "phoneicon")!,
                                                                                                                                             title: "Get Job",
                                                                                                                                             description: "Get jobs according to your vehicle type and load capacity.",
                                                                                                                                             pageIcon: UIImage(named: "pageIconSelected")!,
                                                                                                                                             color: backgroundColorOne,
                                                                                                                                             titleColor: UIColor.black,
                                                                                                                                             descriptionColor: UIColor.lightGray,
                                                                                                                                             titleFont: titleFont!,
                                                                                                                                             descriptionFont: descriptionFont!),
            OnboardingItemInfo(informationImage: UIImage(named: "jobCompletion")!,
                                                                                                                                                                                                    title: "Job Completion",
                                                                                                                                                                                                    description: "Complete the job and get paid on the same day.",
                                                                                                                                                                                                    pageIcon: UIImage(named: "pageIconSelected")!,
                                                                                                                                                                                                    color: backgroundColorOne,
                                                                                                                                                                                                    titleColor: UIColor.black,
                                                                                                                                                                                                    descriptionColor: UIColor.lightGray,
                                                                                                                                                                                                    titleFont: titleFont!,
                                                                                                                                                                                                    descriptionFont: descriptionFont!)
            ][index]
        
    }
    
    func onboardingConfigurationItem(_: OnboardingContentViewItem, index _: Int) {
    
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 2 {
            
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                    self.watchVideo.alpha = 0
                })
            }
            
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3 {
            UIView.animate(withDuration: 0.4, animations: {
//                self.getStartedButton.alpha = 1
//                self.watchVideo.alpha = 1
            })
        }
        
        if index == self.onboardingItemsCount() - 1 {
            nextBtn.setTitle("GOT IT!", for: .normal)
        } else {
            nextBtn.setTitle("NEXT", for: .normal)
        }
        skipBtn.isHidden = (index == self.onboardingItemsCount() - 1) ? true : false
        boolValue = (index == self.onboardingItemsCount() - 1) ? true : false
    }
    
    @IBAction func gotStarted(_ sender: Any) {
        
        //        let userDefaults = UserDefaults.standard
        //
        //        userDefaults.set(true, forKey: "onboardingComplete")
        //
        //        userDefaults.synchronize()
    }
//
//    @IBAction func userManualBtn(_ sender: Any) {
//
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            documentsURL.appendPathComponent("file.pdf")
//            return (documentsURL, [.removePreviousFile])
//        }
//
//        Alamofire.download(url2!, to: destination)
//            .downloadProgress(closure: { (progress) in
//                SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Downloading file...")
//            })
//            .responseData { response in
//            if let destinationUrl = response.destinationURL {
//
//                print("destinationUrl \(destinationUrl.absoluteURL)")
//                SVProgressHUD.dismiss()
//                self.openQlPreview()
//            }
//
//        }
//    }*/
    
    func openQlPreview() {
        let previoew = QLPreviewController.init()
        previoew.dataSource = self
        previoew.delegate = self
        self.present(previoew, animated: true, completion: nil)
    }
    
    
    @IBOutlet var popOverView: UIView!
    @IBAction func watchVideoBtn(_ sender: Any) {
        
        self.view.addSubview(popOverView)
        popOverView.center = self.view.center
        
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        
        self.popOverView.removeFromSuperview()
    }
    
    @IBAction func skipBtnAction(_ sender: Any) {
//       let showVC = sb.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
//        self.navigationController?.pushViewController(showVC!, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
//    
//    @IBAction func nextBtnAction(_ sender: Any) {
//        self.onboardingView.currentIndex(self.onboardingView.currentIndex + 1, animated: true)
//        
//        if boolValue == true {
////           let showVC = sb.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
////            self.navigationController?.pushViewController(showVC!, animated: true)
//             self.navigationController?.popViewController(animated: true)
//        }
//    }
    
}

extension OnboardingController : QLPreviewControllerDelegate , QLPreviewControllerDataSource{
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let documentsURL = try! FileManager().url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true)
        
        let path = documentsURL.appendingPathComponent("file.pdf")
        return path as QLPreviewItem
    }
    
    func previewController(_ controller: QLPreviewController, shouldOpen url: URL, for item: QLPreviewItem) -> Bool {
        return true
    }
    
    
}
