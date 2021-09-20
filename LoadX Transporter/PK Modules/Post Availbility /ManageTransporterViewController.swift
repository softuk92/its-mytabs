//
//  ManageTransporterViewController.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 19/09/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Reusable
class ManageTransporterViewController: UIViewController,StoryboardSceneBased {
    @IBOutlet weak var tableView: UITableView!
    static var sceneStoryboard: UIStoryboard = UIStoryboard(name: "ManageTransporter", bundle: nil)
    
    var dataSource = [ManageDriver]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        configureUI()
    }
    func configureUI()  {
        tableView.separatorColor = UIColor.clear
        tableView.register(cellType: ManageTransporterViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    func fetchData()  {
        let id = user_id ?? "-1"
        let params : Parameters = ["trans_comp_id": id]
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/mangeDriversList", parameters: params) {[weak self] data,json,error in
            guard let self = self, let data = data else {return}
            let decodedModel = try? JSONDecoder().decode([ManageDriver].self, from: data)
            self.dataSource = decodedModel ?? []
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func backTap(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addNewDriver(sender: UIButton) {
        let vc = AddEditDriverViewController.instantiate()
        vc.refreshData = {[weak self] in
            self?.fetchData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ManageTransporterViewController:UITableViewDelegate,UITableViewDataSource,TableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0{
            tableView.setEmptyMessage("No Data Found")
        }
        else{
            tableView.restore()
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell:TransportAvailabilityCell = tableView.dequeueReusableCell(for: indexPath)
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ManageTransporterViewCell.self)
        let data = dataSource [indexPath.row]
        cell.setData(data: data)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "TransporterPublicProfile", bundle: nil)
        let showVC = sb.instantiateViewController(withIdentifier: "TransporterPublicProfileViewController") as?
            TransporterPublicProfileViewController
        let data = dataSource[indexPath.row]
        showVC?.transporterID = data.userID
       self.navigationController?.pushViewController(showVC!, animated: true)
    }

    
    func editButtonTapped(cell: UITableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {return}
        let model =  dataSource[indexPath.row]
        let vc = AddEditDriverViewController.instantiate()
        vc.driver = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteButtonTapped(cell: UITableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {return}
        let model =  dataSource[indexPath.row]
        showAlertView(question: "Are you sure you want to delete this record?", ensure: "", model: model)
    }
    
    func showAlertView(question: String, ensure: String, model: ManageDriver) {
        let aView = AlertView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        aView.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        aView.imageView.image = UIImage(named: "popup_icon")
        aView.imageView.tintColor = R.color.mehroonColor()
        aView.question.text = question
        aView.ensure.text = ensure
        aView.sendPaymentLinkHeight.constant = 0

        aView.yesCall = {[weak self] (_) in
            guard let self = self else { return }
            aView.removeFromSuperview()
            self.deleteDriver(model: model)
        }

        aView.noCall = { (_) in
            aView.removeFromSuperview()
        }

        self.view.addSubview(aView)
    }
    
    func deleteDriver(model: ManageDriver){
        SVProgressHUD.show()
        let id = model.userID
        let param = ["driver_id":id]
        APIManager.apiPost(serviceName: "api/deleteCompanytransporterData", parameters: param) { [weak self]data, json, error in
            if error == nil{
                self?.fetchData()
            }
        }
    }
}

