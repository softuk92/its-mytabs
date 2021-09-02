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
            vc.parentVC = self
            vc.runningLateSuccess = {[weak self] (isSuccess) in
                self?.input.jobStatus.p_running_late = "1"
                self?.setJobStatus()
            }
//            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.present(vc, animated: true, completion: nil)
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
                self.setTimer()
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
    
    func sendPaymentLink() {
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/sendPendingPaymentLinkToUser", parameters: ["del_id": input.delId]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            guard let jsonData = json else { return }
            
            let msg = jsonData[0]["msg"].stringValue
            let result = jsonData[0]["result"].stringValue
            
            if result == "1" {
                self.input.jobStatus.d_cash_received = "1"
                self.setJobStatus()
                self.timer.invalidate()
                UserDefaults.standard.removeObject(forKey: self.input.delId)
            } else {
                showAlert(title: "Alert", message: msg, viewController: self)
            }
        }
    }
    
    func CashReceivedOfJob() {
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/bjDcashReceived", parameters: ["del_id": input.delId]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            guard let jsonData = json else { return }
            
            let msg = jsonData[0]["msg"].stringValue
            let result = jsonData[0]["result"].stringValue
            
            if result == "1" {
                self.input.jobStatus.d_cash_received = "1"
                self.setJobStatus()
                self.timer.invalidate()
                UserDefaults.standard.removeObject(forKey: self.input.delId)
                showSuccessAlert(question: "Cash collected successfully.", closeButtonColor: R.color.newBlueColor() ?? .blue, viewController: self)
            } else {
                showAlert(title: "Alert", message: msg, viewController: self)
            }
        }
    }
    
    func viewJobSummary() {
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/getSummeryAfterJobComplete", parameters: ["del_id": input.delId]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            guard let _ = json, let data = data else { return }
            
            do {
                if let jobSummaryMO = try JSONDecoder().decode([JobSummaryModel].self, from: data).first {
                    self.jobSummaryMO = jobSummaryMO
                    self.viewJobSummaryAlert(summaryMO: jobSummaryMO)
                }
            } catch {
                showAlert(title: "Error", message: error.localizedDescription, viewController: self)
            }
        }
    }
    
    func goToUploadDamageScene() {
        if let vc = UIStoryboard.init(name: "JobDetail", bundle: Bundle.main).instantiateViewController(withIdentifier: "UploadImagesViewController") as? UploadImagesViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.delId = input.delId
            vc.customerName = input.customerName.capitalized
            vc.parentVC = self
            vc.imageUploadedCallBack = {[weak self] (_) in
                self?.input.jobStatus.is_img_uploaded = "1"
                self?.setJobStatus()
            }
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func goToJobCompletedScene() {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookJobController") as? BookJobController {
            vc.contact_no = input.customerNumber
            vc.ref_no = "LX00"+input.delId
            vc.contactName = input.customerName.capitalized
            vc.jobId = input.jbId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showCashReceivedAlert() {
        let aView = AlertIfCashReceived(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        
        aView.sendPaymentLinkCall = { [weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
            self.sendPaymentLink()
        }
        
        aView.cashReceivedCall = { [weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
            self.CashReceivedOfJob()
        }
        
        aView.closeCall = { (_) in
            aView.removeFromSuperview()
        }
        
        self.view.addSubview(aView)
    }
    
}
