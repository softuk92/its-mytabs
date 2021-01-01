//
//  StopDetailsViewControllerExtension.swift
//  LoadX Transporter
//
//  Created by CTS Move on 19/12/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import Foundation
import UIKit

extension StopDetailsViewController {
    func showCompleteAlertView() {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.question.text = "Have this stop been completed?"
        aView.ensure.text = "Before continuing ensure you submit the following: \n\n- Name & Signature of Recipient \n- Delivery Image Proof     "
        aView.sendPaymentLinkHeight.constant = 0
        aView.sendPaymentLink.isHidden = true
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
        
        aView.yes.rx.tap.subscribe(onNext: { [weak self] (_) in
            aView.removeFromSuperview()
            self?.goToStopCompleteProofScene()
        }).disposed(by: disposeBag)

        aView.no.rx.tap.subscribe(onNext: { (_) in
            aView.removeFromSuperview()
        }).disposed(by: disposeBag)
        
        self.view.addSubview(aView)
    }
    
    func showPickupRouteCompleteAlert() {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.ensure.text = ""
        aView.sendPaymentLink.isHidden = true
        aView.sendPaymentLinkHeight.constant = 0
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
        aView.question.text = "Have this stop been completed?"
        aView.yes.rx.tap.subscribe(onNext: { [weak self] (_) in
            aView.removeFromSuperview()
            self?.pickupRouteCompleted()
        }).disposed(by: disposeBag)

        aView.no.rx.tap.subscribe(onNext: { (_) in
            aView.removeFromSuperview()
        }).disposed(by: disposeBag)
        
        self.view.addSubview(aView)
    }
    
    func showArrivedAlertView() {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.ensure.text = ""
        aView.sendPaymentLink.isHidden = true
        aView.sendPaymentLinkHeight.constant = 0
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
        aView.question.text = "Have you arrived at stop?"
        aView.yes.rx.tap.subscribe(onNext: { [weak self] (_) in
            aView.removeFromSuperview()
            self?.driverArrived()
        }).disposed(by: disposeBag)

        aView.no.rx.tap.subscribe(onNext: { (_) in
            aView.removeFromSuperview()
        }).disposed(by: disposeBag)
        
        self.view.addSubview(aView)
    }
    
    func showRunningLateAlertView() {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.ensure.text = ""
        aView.sendPaymentLinkHeight.constant = 0
        aView.sendPaymentLink.isHidden = true
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
        aView.question.text = "Are you running late?"
        aView.yes.rx.tap.subscribe(onNext: { [weak self] (_) in
            aView.removeFromSuperview()
            self?.goToRunningLateScene()
        }).disposed(by: disposeBag)

        aView.no.rx.tap.subscribe(onNext: { (_) in
            aView.removeFromSuperview()
        }).disposed(by: disposeBag)
        
        self.view.addSubview(aView)
    }
    
    func showDamageReportAlertView() {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.ensure.text = "Please ensure you have informed the customer and upload images of the damage report before completing stop."
        aView.sendPaymentLinkHeight.constant = 0
        aView.sendPaymentLink.isHidden = true
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
    
        aView.yes.rx.tap.subscribe(onNext: { [weak self] (_) in
            aView.removeFromSuperview()
            self?.goToConfirmDamageScene()
        }).disposed(by: disposeBag)

        aView.no.rx.tap.subscribe(onNext: { (_) in
            aView.removeFromSuperview()
        }).disposed(by: disposeBag)
        
        self.view.addSubview(aView)
    }
    
    func showCashCollectedAlertView() {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.ensure.text = "Please note: The customer may pay on drop off, you can always send a payment link if the customer wants to pay via card."
        aView.sendPaymentLinkHeight.constant = 35
        aView.sendPaymentLink.isHidden = false
        aView.question.text = "Have you collected cash on this stop?"
//        aView.sendPaymentLink.layer.cornerRadius = 25
//        aView.sendPaymentLink.layer.masksToBounds = false
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
    
        aView.yes.rx.tap.subscribe(onNext: { [weak self] (_) in
            aView.removeFromSuperview()
            self?.cashCollected(send: "1")
        }).disposed(by: disposeBag)

        aView.no.rx.tap.subscribe(onNext: { [weak self] (_) in
            aView.removeFromSuperview()
            self?.cashCollected(send: "2")
        }).disposed(by: disposeBag)
        
        aView.sendPaymentLink.rx.tap.subscribe(onNext: { [weak self] (_) in
            aView.removeFromSuperview()
            self?.cashCollected(send: "3")
        }).disposed(by: disposeBag)
        
        if self.route.lrh_type == "Pickup Shipment" {
            aView.no.isHidden = false
        } else {
            aView.no.isHidden = true
        }
        
        self.view.addSubview(aView)
    }
    
    func pickupRouteCompleted() {
        APIManager.apiPost(serviceName: "api/markRouteStopCompleted", parameters: ["lrh_id" : route.lrh_id]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                
            }
            print("transporter pickup completed json \(String(describing: json))")
            
            let result = json?[0]["result"].stringValue
            let msg = json?[0]["msg"].stringValue
            if result == "1" {
                self.complete.isHidden = true
                self.reportDamage.isHidden = true
            } else {
            self.present(showAlert(title: "", message: msg ?? ""), animated: true, completion: nil)
            }
        }
    }
    
    //cash collected
    func cashCollected(send: String) {
        APIManager.apiPost(serviceName: "api/transporterCashCollect", parameters: ["lrh_id": route.lrh_id, "cash_received" : send]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                
            }
            print("transporter cash collected json \(String(describing: json))")
            
            let result = json?[0]["result"].stringValue
            let msg = json?[0]["msg"].stringValue
            if result == "1" {
                self.cashCollected.isHidden = true
                self.complete.isHidden = false
            } else {
            self.present(showAlert(title: "", message: msg ?? ""), animated: true, completion: nil)
            }
        }
    }
    
    //arrived and running late actions and API Calls
    func driverArrived() {
        APIManager.apiPost(serviceName: "api/transporterArrive", parameters: ["lrh_id": route.lrh_id]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                
            }
            print("transporter arrived json \(String(describing: json))")
            
            let result = json?[0]["result"].stringValue
            let msg = json?[0]["msg"].stringValue
            if result == "1" {
            self.hideShowButtonViews(upperView: false, bottomView: false)
            if self.route.lrh_type == "Pickup Shipment" {
                if self.route.payment_type == "account" {
                    self.hideShowButtons(arrived: true, cashCollected: true, complete: false, runningLate: true, reportDamage: true, viewNextStop1: false, viewNextStop2: true)
            } else {
                self.hideShowButtons(arrived: true, cashCollected: false, complete: true, runningLate: true, reportDamage: true, viewNextStop1: false, viewNextStop2: true)
            }
            self.reportDamage.isHidden = !(self.route.is_damage == "0")
            }
            else
            {
                if self.route.payment_type == "account" {
                    self.hideShowButtons(arrived: true, cashCollected: true, complete: false, runningLate: true, reportDamage: true, viewNextStop1: false, viewNextStop2: true)
            } else {
                if self.route.cash_received_at_pickup.lowercased() == "yes" {
                    self.hideShowButtons(arrived: true, cashCollected: true, complete: false, runningLate: true, reportDamage: true, viewNextStop1: false, viewNextStop2: true)
                } else {
                    self.hideShowButtons(arrived: true, cashCollected: false, complete: true, runningLate: true, reportDamage: true, viewNextStop1: false, viewNextStop2: true)
                }
            }
            self.reportDamage.isHidden = true
            }
            } else {
            self.present(showAlert(title: "", message: msg ?? ""), animated: true, completion: nil)
            }
        }
    }
    
    func goToRunningLateScene() {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RunningLateViewController") as? RunningLateViewController {
            vc.lrh_id = route.lrh_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToStopCompleteProofScene() {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookJobController") as? BookJobController {
            vc.lrhJobId = route.lrh_job_id
            vc.lrID = self.routeID ?? ""
            vc.lrhId = route.lrh_id
            vc.isRoute = true
            vc.ref_no = fullStopId
            vc.contactName = route.customer_name
            vc.contact_no = route.phone_number
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToConfirmDamageScene() {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ConfirmDamageViewController") as? ConfirmDamageViewController {
            vc.lrhJobID = route.lrh_job_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
