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
    
    var route : RouteStopDetail!
    var routeSummaryDetails = [RouteSummaryDetails]()
    private var items: [MenuItemStruct] = []
    var stopId: String!
    var fullStopId: String!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeSearchTabView()
        customizeView()
        configureTableViews()
        bindFields()
        bindButtons()
        getStopDetails()
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
        pickup.text = getAddress(street: route.street, route: route.route, city: route.city, postcode: route.post_code)
        routeId.text = fullStopId
        addressLabel.text = (route.lrh_type == "Pickup Shipment") ? "Pickup:" : "Dropoff:"
        price.text = "£"+String(format: "%.2f", Double(route.price) ?? 0.0)
        if route.pickup_lrh_stop_no != "N/A" && route.pickup_lrh_stop_no != "" {
            dropoffStopNumber.isHidden = false
            dropoffStopNumber.text = "Drop Off of Stop \(route.pickup_lrh_stop_no)"
        } else {
            dropoffStopNumber.isHidden = true
        }
        name.text = "Customer Name:"
        phone.text = route.customer_name
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
        SVProgressHUD.show(withStatus: "Geting details...")
        APIManager.apiPost(serviceName: "api/getSpecificStopAdditionalInfo", parameters: ["lrh_id" : stopId ?? ""]) { [weak self] (data, json, error) in
            guard let self = self else { return }
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
            
            let NoOfHelper = (helper == "1") ? "No helper needed" : (helper ?? "")
            info.append(MenuItemStruct.init(title: "No of Helpers", value: NoOfHelper))
            info.append(MenuItemStruct.init(title: "Distance", value: "\(distance ?? "") Miles"))
            
            self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Summary", detail: info))
            
            //inventory table view setup
            let customData = json?[1].dictionary ?? [:]
            self.items = customData.map({ (key, value) -> MenuItemStruct in
                return MenuItemStruct.init(title: key.replacingOccurrences(of: "_", with: " "), value: value.stringValue)
            })
            self.tableView.reloadData()
            self.additionalInfoTableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        return cell
    }

}
