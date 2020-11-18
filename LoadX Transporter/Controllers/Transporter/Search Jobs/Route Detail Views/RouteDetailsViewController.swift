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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        getRouteDetails()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: RouteDetailsCell.self)
    }
    
    func getRouteDetails() {
        SVProgressHUD.show(withStatus: "Geting details...")
        APIManager.apiPost(serviceName: "api/getSpecificRouteDetail", parameters: ["route_id" : routeId ?? ""]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                SVProgressHUD.dismiss()
            }
            do {
                self.routeStopDetail = try JSONDecoder().decode([RouteStopDetail].self, from: data!)
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
        return 220
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
        cell.dataSource = routeStopDetail[indexPath.row]
        cell.parentViewController = self
        return cell
    }
    
}
