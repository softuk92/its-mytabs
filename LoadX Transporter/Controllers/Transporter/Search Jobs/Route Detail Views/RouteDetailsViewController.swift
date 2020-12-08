//
//  RouteDetailsViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 18/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire

class RouteDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var routeStopDetail = [RouteStopDetail]()
    var routeId : String!
    var isBooked: Bool = false
    var isRouteStarted = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        getRouteDetails()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: RouteDetailsCell.self)
        tableView.tableFooterView = UIView()
    }
    
    func getRouteDetails() {
        SVProgressHUD.show(withStatus: "Getting details...")
        APIManager.apiPost(serviceName: "api/getSpecificRouteDetail", parameters: ["route_id" : routeId ?? ""]) { [weak self] (data, json, error) in
            guard let self = self, data != nil else { return }
            if error != nil {
                SVProgressHUD.dismiss()
            }
            do {
                self.routeStopDetail = try JSONDecoder().decode([RouteStopDetail].self, from: data ?? Data())
                print("Route json is \(String(describing: json))")
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            } catch {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
     }
    
}

extension RouteDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 255
    }
}

extension RouteDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        routeStopDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: RouteDetailsCell.self)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        cell.layer.shadowRadius = 10
        cell.bindLabels(route: routeStopDetail[indexPath.row], isBooked: isBooked, allRoutes: routeStopDetail, isRouteStarted: isRouteStarted, index: indexPath.row, routeID: routeId)
        cell.isBooked = isBooked
        cell.parentViewController = self
//        cell.seeStopDetails = {[weak self] (selectedCell) in
//            guard let self = self else { return }
//            let selectedIndex = self.tableView.indexPath(for: selectedCell)
//            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
//            if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StopDetailsViewController") as? StopDetailsViewController {
//                vc.route = self.routeStopDetail[indexPath.row]
//                vc.fullStopId = fullstopId
//                vc.isBooked = self.isBooked
//                self.parentViewController.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
        return cell
    }
    
}
