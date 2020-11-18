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
    var route : RouteStopDetail!
    var stopId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeSearchTabView()
        bindFields()
        customizeView()
        configureTableView()
        getStopDetails()
    }
    
    func customizeSearchTabView() {
        detailTabView.layer.masksToBounds = false
        detailTabView.layer.shadowOpacity = 0.5
        detailTabView.layer.shadowColor = UIColor.black.cgColor
        detailTabView.layer.shadowOffset = CGSize(width: 0 , height:0.5)
    }
    
    func customizeView() {
        stopView.roundCorners(corners: [.topLeft, .topRight], radius: 5)
        backView.roundCorners(corners: [.bottomLeft, .bottomRight, .topRight], radius: 5)
    }
    
    func bindFields() {
        stops.text = "Stop "+String(route.stop_no)
        pickup.text = getAddress(street: route.street, route: route.route, city: route.city, postcode: route.post_code)
        routeId.text = "LS2020J"+route.lrh_job_id
        addressLabel.text = (route.lrh_type == "Pickup Shipment") ? "Pickup" : "Dropoff"
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
    
    func configureTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(cellType: RouteDetailsCell.self)
    }
    
    func getStopDetails() {
        SVProgressHUD.show(withStatus: "Geting details...")
        APIManager.apiPost(serviceName: "api/getSpecificStopAdditionalInfo", parameters: ["lrh_id" : stopId ?? ""]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                SVProgressHUD.dismiss()
            }
            do {
//                self.routeStopDetail = try JSONDecoder().decode([RouteStopDetail].self, from: data!)
//                print("Route json is \(String(describing: json))")
//                SVProgressHUD.dismiss()
//                self.tableView.reloadData()
            } catch {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
     }
    
}

extension StopDetailsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 220
//    }
}

//extension StopDetailsViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        routeStopDetail.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RouteDetailsCell.self)
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        cell.backgroundView = nil
//        cell.backgroundColor = nil
//        cell.layer.shadowRadius = 10
//        cell.dataSource = routeStopDetail[indexPath.row]
//        return cell
//    }
//
//}
