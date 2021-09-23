//
//  AssignDriverViewController.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 20/09/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD

class AssignDriverViewController: UIViewController {

    @IBOutlet weak var driversListView: UIView!
    @IBOutlet weak var innerDriversListView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var transporterName: UITextField!
    
    var list : [DriversListMO] = [] {
        
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedDriver: DriversListMO?
    var jobID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.clear
        
        innerDriversListView.layer.cornerRadius = 10
        getDriversList()
    }
    
    func getDriversList() {
        guard let tID = user_id else { return }
        APIManager.apiPost(serviceName: "api/approvedDriversList", parameters: ["transportation_id" : tID]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            
            guard let data = data else { return }

            do {
                self.list = try JSONDecoder().decode([DriversListMO].self, from: data)
            } catch {
                showAlert(title: "Error", message: error.localizedDescription, viewController: self)
            }
        }
    }
    
    @IBAction private func btnCross_Pressed(_ sender : UIButton) {
        driversListView.isHidden = true
    }
    
    @IBAction private func btnShowPop(_ sender : UIButton) {
        driversListView.isHidden = false
    }
        
    @IBAction func back_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func assignDriver(_ sender: Any) {
        assignDriverFunc()
    }
    
    func assignDriverFunc() {
        guard let driverID = selectedDriver?.userID, let jobID = jobID else { return }
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/assignTransporter", parameters: ["driver_id" : driverID, "job_id" : jobID]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            } else {
                self.navigationController?.popViewController(animated: true)
            }

            
        }
    }
    
}

//MARK: UITableViewDelegate
extension AssignDriverViewController: UITableViewDataSource , UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobNatureCell", for: indexPath) as? JobNatureCell
        cell?.layer.cornerRadius = 10
        cell?.backgroundColor = UIColor.clear
        cell?.backgroundView = nil
        cell?.lblJobNature.text = self.list[indexPath.row].userName.capitalized
        if indexPath.row == 11 {
            cell?.bottomLineView.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedValue = list[indexPath.row].userName.capitalized
        transporterName.text = selectedValue
        selectedDriver = list[indexPath.row]
        driversListView.isHidden = true
    }
    
}
