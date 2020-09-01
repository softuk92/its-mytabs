//
//  HomeViewController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 1/25/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
//import paper_onboarding
import CoreLocation
import SideMenu
import AVFoundation
import ZDCChat
import SVProgressHUD

class HomeViewController: UIViewController {
 
    @IBOutlet var background_view: UIView!
    @IBOutlet weak var logo_view: UIView!
    @IBOutlet weak var button_view: UIView!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var signUp_btn: UIButton!
    @IBOutlet weak var searchNew_btn: UIButton!
    
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "LoadX"
//      SideMenuManager.default.menuFadeStatusBar = false
//      SideMenuManager.default.menuAnimationFadeStrength = 0.5
//      SideMenuManager.default.menuPresentMode = .menuSlideIn
        checkLocationServices()
        
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            print("already authorized")
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    print("access allowed")
                    //access allowed
                } else {
                    print("already authorized")
                    //access denied
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        home_darkMood()
    }
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func home_darkMood() {
        if switchCheck == true{
        self.background_view.backgroundColor = UIColor(hexString: "191D20")
        self.logo_view.backgroundColor = UIColor(hexString: "2D2E2D")
        signUp_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
        login_btn.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
        signUp_btn.setTitleColor(.white, for: .normal)
        login_btn.setTitleColor(.white, for: .normal)
        searchNew_btn.setTitleColor(.white, for: .normal)
        }else{
            self.background_view.backgroundColor = UIColor.white
            self.logo_view.backgroundColor = UIColor(hexString: "2D2E2D")
            signUp_btn.setBackgroundImage(UIImage(named: "login_btn"), for: .normal)
            login_btn.setBackgroundImage(UIImage(named: "login_btn"), for: .normal)
            signUp_btn.setTitleColor(.black, for: .normal)
            login_btn.setTitleColor(.black, for: .normal)
            searchNew_btn.setTitleColor(.black, for: .normal)
        }
    }
    @IBAction func rate_us_btn(_ sender: Any) {
        rateApp(appId: "id1388340701?mt=8") { (success) in
            print("Rateapp \(success)")
        }
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        let refreshAlert = UIAlertController(title: "Rate LoadX", message: "Please rate our app at App Store?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Rate", style: .default, handler: { (action: UIAlertAction!) in
            guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
                completion(false)
                return
            }
            guard #available(iOS 10, *) else {
                completion(UIApplication.shared.openURL(url))
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    
    @IBAction func helpZendesk(_ sender: Any) {
        ZDCChat.start(in: self.navigationController, withConfig: nil)
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
    
    @IBAction func searchJb(_ sender: Any) {
    self.performSegue(withIdentifier: "bookedJobs", sender: self)
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        //        self.perform(#selector(performAction), with: nil, afterDelay: 5.0)
        
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
