//
//  JobPickupDropoffViewControllerExtension.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 25/05/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension JobPickupDropoffViewController {
    //all statuses functions
    func goToRunningLateScene() {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RunningLateViewController") as? RunningLateViewController {
            vc.delId = input.delId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func pickupArrived() {
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/pickUpArrived", parameters: ["del_id": input.delId]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            guard let jsonData = json else { return }
            
            let msg = jsonData[0]["msg"].stringValue
            let result = jsonData[0]["result"].stringValue
            
            if result == "1" {
                self.input.jobStatus.arrival_at_pickup = "1"
                self.setJobStatus()
            } else {
                showAlert(title: "Alert", message: msg, viewController: self)
            }
        }
    }
    
    func dropoffArrived() {
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/dArrived", parameters: ["del_id": input.delId]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            guard let jsonData = json else { return }
            
            let msg = jsonData[0]["msg"].stringValue
            let result = jsonData[0]["result"].stringValue
            
            if result == "1" {
                self.input.jobStatus.d_arrived = "1"
                self.setJobStatus()
            } else {
                showAlert(title: "Alert", message: msg, viewController: self)
            }
        }
    }
    
    func leavingForDropoff() {
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/pLeavingForDropOff", parameters: ["del_id": input.delId]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            guard let jsonData = json else { return }
            
            let msg = jsonData[0]["msg"].stringValue
            let result = jsonData[0]["result"].stringValue
            
            if result == "1" {
                self.input.jobStatus.p_leaving_f_dropoff = "1"
                self.setJobStatus()
            } else {
                showAlert(title: "Alert", message: msg, viewController: self)
            }
        }
    }
    
}
