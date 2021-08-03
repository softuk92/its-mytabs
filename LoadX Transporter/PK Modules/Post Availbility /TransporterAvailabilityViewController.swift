//
//  TransporterAvailabilityViewController.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 29/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import Reusable
import SVProgressHUD
class TransporterAvailabilityViewController: UIViewController, StoryboardSceneBased{
    static let sceneStoryboard = R.storyboard.transporterAvailability()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var dataSource = [TransporterAvailability]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: TransportAvailabilityCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        let view = UIView()
        view.backgroundColor = R.color.background_color()
        tableView.backgroundView = view
        tableView.rowHeight = 250
        fetchData()
    }
    func fetchData()  {
        guard let userId = user_id else { return }
        let params : Parameters = ["transporter_id": userId]
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/transporterPostedAvailabilityList", parameters: params) {[weak self] data,json,error in
            guard let self = self, let data = data else {return}
            let decodedModel = try? JSONDecoder().decode([TransporterAvailability].self, from: data)
            self.dataSource = decodedModel ?? []
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func backButtonTap(sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonTapped(sender: Any){
        let showVC = PostAvailabilityFormViewController.instantiate()
        showVC.dataPosted = { [weak self] in
            self?.fetchData()
        }
       self.navigationController?.pushViewController(showVC, animated: true)
    }

}
extension TransporterAvailabilityViewController:UITableViewDelegate,UITableViewDataSource,TableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell:TransportAvailabilityCell = tableView.dequeueReusableCell(for: indexPath)
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TransportAvailabilityCell.self)
        let data = dataSource [indexPath.row]
        cell.setData(data: data)
        cell.cellDelegate = self
        return cell
    }
    
    func didTapButton(cell: UITableViewCell, selected: Bool?) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {return}
        let model = dataSource[indexPath.row]
       let id = model.paID
        let param = ["pa_id":id]
        APIManager.apiPost(serviceName: "api/postAvailabilityDelete", parameters: param) { [weak self]data, json, error in
            if error == nil{
                self?.fetchData()
            }
        }
    }
}

