//
//  StopDetailsViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 19/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import RxSwift

public struct RouteSummaryDetails {
    let title: String
    let detail: [MenuItemStruct]
}

class StopDetailsViewController: UIViewController {

    @IBOutlet weak var routeId: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pickup: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var dropoffStopNumber: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var stops: UILabel!
    @IBOutlet weak var stopView: UIView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var detailTabView: UIView!
    @IBOutlet weak var leadingInventory: NSLayoutConstraint!
    @IBOutlet weak var trailingInventory: NSLayoutConstraint!
    @IBOutlet weak var leadingAdditionalDetails: NSLayoutConstraint!
    @IBOutlet weak var trailingAdditionalDetails: NSLayoutConstraint!
    @IBOutlet weak var inventoryListBtn: UIButton!
    @IBOutlet weak var additionalDetailsBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var additionalInfoTableView: UITableView!
    @IBOutlet weak var viewNextStop2: UIButton!
    @IBOutlet weak var arrivedOrCashCollected: UIButton!
    @IBOutlet weak var runningLate: UIButton!
    @IBOutlet weak var twoButtonsStackView: UIStackView!
    @IBOutlet weak var viewNextStop: UIButton!
    @IBOutlet weak var reportDamage: UIButton!
    @IBOutlet weak var bottomButtonView: UIView!
    @IBOutlet weak var upperButtonView: UIView!
    
    var routeID: String?
    var route : RouteStopDetail!
    var allRoutes: [RouteStopDetail] = []
    var isRouteStarted = ""
    var routeIndex = 0
    var routeSummaryDetails = [RouteSummaryDetails]()
    private var items: [MenuItemStruct] = []
    var fullStopId: String!
    private var disposeBag = DisposeBag()
    var isBooked: Bool = false
    var isItem: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewNextStop2.setTitle("VIEW NEXT STOP", for: .normal)
        customizeSearchTabView()
        customizeView()
        configureTableViews()
        bindFields()
        bindButtons()
        getStopDetails()
        setupTwoButtons()
        customizeUI()
    }
    
    func customizeUI() {
        viewNextStop2.layer.cornerRadius = 15
        arrivedOrCashCollected.layer.cornerRadius = 15
        runningLate.layer.cornerRadius = 15
        viewNextStop.layer.cornerRadius = 15
        reportDamage.layer.cornerRadius = 15
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func setConstraints(leadingSearch: Bool, trailingSearch: Bool, leadingRoute: Bool, trailingRoute: Bool) {
        UIView.animate(withDuration: 3.0) { [weak self] in
            self?.leadingInventory.isActive = leadingSearch
            self?.trailingInventory.isActive = trailingSearch
            self?.leadingAdditionalDetails.isActive = leadingRoute
            self?.trailingAdditionalDetails.isActive = trailingRoute
        }
    }
    
    func bindButtons() {
        inventoryListBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.setConstraints(leadingSearch: true, trailingSearch: true, leadingRoute: false, trailingRoute: false)
            self?.additionalInfoTableView.isHidden = true
            self?.tableView.isHidden = false
        }).disposed(by: disposeBag)
        
        additionalDetailsBtn.rx.tap.subscribe(onNext: {[weak self] (_) in
            self?.tableView.isHidden = true
            self?.setConstraints(leadingSearch: false, trailingSearch: false, leadingRoute: true, trailingRoute: true)
//            if (self?.additionalInfo.count ?? 0) > 0 {
                self?.additionalInfoTableView.isHidden = false
//            } else {
//                self?.additionalInfoTableView.isHidden = true
//            }
        }).disposed(by: disposeBag)
        
    }
    
    func customizeSearchTabView() {
        detailTabView.layer.masksToBounds = false
        detailTabView.layer.shadowOpacity = 0.5
        detailTabView.layer.shadowColor = UIColor.black.cgColor
        detailTabView.layer.shadowOffset = CGSize(width: 0 , height:0.5)
    }
    
    func customizeView() {
        stopView.roundCorners(corners: [.topLeft, .topRight], radius: 5)
//        backView.roundCorners(corners: [.bottomLeft, .bottomRight, .topRight], radius: 5)
    }
    
    func bindFields() {
        guard route != nil else { return }
        stops.text = "Stop "+String(route.stop_no)
//        pickup.text = getAddress(street: route.street, route: route.route, city: route.city, postcode: route.post_code)
        routeId.text = fullStopId
        addressLabel.text = (route.lrh_type == "Pickup Shipment") ? "Pickup:" : "Dropoff:"
        price.text = "£"+String(format: "%.2f", Double(route.price) ?? 0.0)
        if route.pickup_lrh_stop_no != "N/A" && route.pickup_lrh_stop_no != "" {
            dropoffStopNumber.isHidden = false
            dropoffStopNumber.text = "Drop Off of Stop \(route.pickup_lrh_stop_no)"
        } else {
            dropoffStopNumber.isHidden = true
        }
        if !isBooked {
        name.text = "Customer Name:"
            phone.text = route.customer_name.capitalized
        pickup.text = getAddress(street: route.street, route: route.route, city: route.city, postcode: route.post_code)
        } else {
        name.text = route.customer_name
        phone.text = route.phone_number
        pickup.text = route.lrh_postcode
        }
        time.text = route.lrh_arrival_time
    }
    
    func configureTableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: RouteInventoryCell.self)
        tableView.tableFooterView = UIView()
        
        additionalInfoTableView.delegate = self
        additionalInfoTableView.dataSource = self
        additionalInfoTableView.register(cellType: JobSummaryCell.self)
        additionalInfoTableView.rowHeight = UITableView.automaticDimension
        additionalInfoTableView.tableFooterView = UIView()
    }
    
    func getStopDetails() {
        SVProgressHUD.show(withStatus: "Getting details...")
        APIManager.apiPost(serviceName: "api/getSpecificStopAdditionalInfo", parameters: ["lrh_id" : route?.lrh_id ?? ""]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            self.routeSummaryDetails = []
            if error != nil {
                SVProgressHUD.dismiss()
            }
            var info = [MenuItemStruct]()
            let shipmentType = json?[0]["lrh_type"].stringValue
            let movingTo = json?[0]["moving_to"].stringValue
            let desc = json?[0]["description"].stringValue
            let movingFrom = json?[0]["moving_from"].stringValue
            let distance = json?[0]["lrh_distance"].stringValue
            let helper = json?[0]["helper"].stringValue
            
            if desc != "", let summaryDesc = desc {
                self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Description", detail: [MenuItemStruct.init(title: summaryDesc, value: "")]))
            }
            
            if shipmentType == "Pickup Shipment" {
                info.append(MenuItemStruct.init(title: "Moving From", value: movingFrom ?? ""))
            } else {
                info.append(MenuItemStruct.init(title: "Moving To", value: movingTo ?? ""))
            }
            var noOfHelper = ""
            if helper == "0" {
                noOfHelper = "No helpers needed"
            } else if helper == "1" {
                noOfHelper = "Driver Only"
            } else {
                noOfHelper = "Driver + \(helper ?? "") Helper"
            }
            
            info.append(MenuItemStruct.init(title: "No of Helpers", value: noOfHelper))
            info.append(MenuItemStruct.init(title: "Distance", value: "\(distance ?? "") Miles"))
            
            self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Summary", detail: info))

            let items = json?[0]["items"].stringValue
            let vanRequired = json?[0]["van_required"].stringValue
            
            //inventory table view setup
            let customData = json?[1].dictionary ?? [:]
            self.items = customData.map({ (key, value) -> MenuItemStruct in
                return MenuItemStruct.init(title: key.replacingOccurrences(of: "_", with: " "), value: value.stringValue)
            })
            
            if self.items.count == 0 {
                if items != "0" {
                self.items.append(MenuItemStruct.init(title: "No. of Items", value: items ?? "0"))
                }
                self.items.append(MenuItemStruct.init(title: "Van Space Required", value: "Approx. \(vanRequired ?? "")"))
                self.isItem = true
            }

            self.tableView.reloadData()
            self.additionalInfoTableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
     }
    
    func setupTwoButtons() {
        if isRouteStarted == "0" {
            self.arrivedOrCashCollected.isHidden = true
            self.reportDamage.isHidden = true
            self.bottomButtonView.isHidden = true
        } else if route.is_completed == "1" {
            self.arrivedOrCashCollected.isHidden = true
            if route.is_damage == "1" {
                self.reportDamage.isHidden = true
                self.upperButtonView.isHidden = true
            } else {
                self.reportDamage.isHidden = false
                self.upperButtonView.isHidden = false
            }
            self.bottomButtonView.isHidden = false
            self.runningLate.isHidden = true
            self.viewNextStop.isHidden = false
            self.viewNextStop2.isHidden = true
        } else {
        if route.is_t_arrive == "0" {
            self.arrivedOrCashCollected.isHidden = false
            self.arrivedOrCashCollected.setTitle("ARRIVED ?", for: .normal)
            if route.inform_running_late == "0" {
                self.runningLate.isHidden = false
                self.runningLate.setTitle("RUNNING LATE ?", for: .normal)
            } else {
                self.runningLate.isHidden = true
            }
        } else {
            self.setArrivalButtons()
        }
        }
        viewNextStop2.rx.tap.subscribe(onNext: {[weak self] (_) in
            guard let self = self else { return }
            self.setupRouteStartingBehaviour()
        }).disposed(by: disposeBag)

        arrivedOrCashCollected.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            if self.arrivedOrCashCollected.titleLabel?.text == "CASH COLLECTED?" {
            self.showCashCollectedAlertView()
            } else if self.arrivedOrCashCollected.titleLabel?.text == "COMPLETE" {
                self.showCompleteAlertView()
            } else {
            self.showArrivedAlertView()
            }
        }).disposed(by: disposeBag)
        
        runningLate.rx.tap.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            self.showRunningLateAlertView()
        }).disposed(by: disposeBag)
        
        viewNextStop.rx.tap.subscribe(onNext: {[weak self] (_) in
            guard let self = self else { return }
            self.setupRouteStartingBehaviour()
        }).disposed(by: disposeBag)
        
        reportDamage.rx.tap.subscribe(onNext: {[weak self] (_) in
            guard let self = self else { return }
            self.showDamageReportAlertView()
        }).disposed(by: disposeBag)
        
        
    }
    
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
        
        self.view.addSubview(aView)
    }
        
    //view next stop
    func setupRouteStartingBehaviour() {
        if self.routeIndex < self.allRoutes.count {
            self.route = self.allRoutes[self.routeIndex+1]
            self.routeIndex = self.routeIndex + 1
            self.bindFields()
            self.getStopDetails()
            self.setupTwoButtons()
            if isRouteStarted == "1" {
            self.setArrivalButtons()
            }
        } else if self.routeIndex == self.allRoutes.count {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //arrived and running late actions and API Calls
    private func driverArrived() {
        APIManager.apiPost(serviceName: "api/transporterArrive", parameters: ["lrh_id": route.lrh_id]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                
            }
            print("transporter arrived json \(String(describing: json))")
            
            let result = json?[0]["result"].stringValue
            let msg = json?[0]["message"].stringValue
            if result == "1" {
            self.setArrivalButtons()
            } else {
            self.present(showAlert(title: "", message: msg ?? ""), animated: true, completion: nil)
            }
        }
    }
    
    //cash collected
    private func cashCollected(send: String) {
        APIManager.apiPost(serviceName: "api/transporterCashCollect", parameters: ["lrh_id": route.lrh_id, "cash_received" : send]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                
            }
            print("transporter cash collected json \(String(describing: json))")
            
            let result = json?[0]["result"].stringValue
            let msg = json?[0]["msg"].stringValue
            if result == "1" {
//          self.setArrivalButtons()
            self.navigationController?.popViewController(animated: true)
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
    
    func setArrivalButtons() {
        if route.is_damage == "1" {
            self.reportDamage.isHidden = true
        } else {
            self.reportDamage.isHidden = false
        }
        if route.lrh_type == "Pickup Shipment" {
        self.runningLate.isHidden = true
        self.viewNextStop2.isHidden = true
        self.viewNextStop.isHidden = false
        if route.cash_received == "1" {
        self.arrivedOrCashCollected.isHidden = true
        self.reportDamage.isHidden = false
        } else {
        self.arrivedOrCashCollected.isHidden = false
        self.arrivedOrCashCollected.setTitle("CASH COLLECTED?", for: .normal)
        }
            
        } else {
            
            if route.cash_received_at_pickup == "Yes" {
                self.bottomButtonView.isHidden = true
                self.reportDamage.isHidden = true
                self.arrivedOrCashCollected.setTitle("COMPLETE", for: .normal)
            } else {
                self.bottomButtonView.isHidden = false
                self.runningLate.isHidden = true
                self.viewNextStop2.isHidden = true
                self.viewNextStop.isHidden = false
                if route.cash_received == "1" {
                self.arrivedOrCashCollected.isHidden = true
                self.reportDamage.isHidden = false
                } else {
                self.arrivedOrCashCollected.isHidden = false
                self.arrivedOrCashCollected.setTitle("CASH COLLECTED?", for: .normal)
                }
            }
        }
    }
    
}

extension StopDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == additionalInfoTableView {
        return UITableView.automaticDimension
        }
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == additionalInfoTableView {
        return routeSummaryDetails.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == additionalInfoTableView {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == additionalInfoTableView {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.additionalInfoTableView.bounds.width, height: 50))
        headerView.title.text = self.routeSummaryDetails[section].title
        return headerView
        } else {
            return nil
        }
    }
}

extension StopDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == additionalInfoTableView {
            return self.routeSummaryDetails[section].detail.count
        }
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == additionalInfoTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: JobSummaryCell.self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundView = nil
            cell.backgroundColor = nil
            if self.routeSummaryDetails[indexPath.section].detail[indexPath.row].value == "" {
                cell.title.text = self.routeSummaryDetails[indexPath.section].detail[indexPath.row].title
                cell.title.font = UIFont(name: "Montserrat-Light", size: 13)
                cell.detail.isHidden = true
            } else {
                cell.title.text = self.routeSummaryDetails[indexPath.section].detail[indexPath.row].title
                cell.detail.text = self.routeSummaryDetails[indexPath.section].detail[indexPath.row].value
                cell.detail.isHidden = false
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RouteInventoryCell.self)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        cell.title.text = items[indexPath.row].title
        cell.number.text = items[indexPath.row].value
        if isItem {
            cell.numberView.backgroundColor = .clear
            cell.number.textColor = UIColor.init(named: "TextfieldTextColor")
        }
        return cell
    }

}
