//
//  NotificationsListViewController.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 15/09/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable

class NotificationsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var noRecordFound: UIView!
    
    var notificationsList : [NotificationsModel] = [] {
        didSet {
            tableView.reloadData()
            screenTitle.text = "Notifications (\(notificationsList.count))"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        apiCall()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: NotificationsListCell.self)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func apiCall() {
        guard let userId = user_id else { return }
        APIManager.apiPost(serviceName: "api/getAllLatesNotificatonList", parameters: ["user_id" : userId]) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            
            guard let data = data else { return }

            do {
                self.notificationsList = try JSONDecoder().decode([NotificationsModel].self, from: data)
                self.noRecordFound.isHidden = self.notificationsList.count > 0
            } catch {
                showAlert(title: "Error", message: error.localizedDescription, viewController: self)
            }
            
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension NotificationsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notificationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: NotificationsListCell.self)
        cell.setData(model: notificationsList[indexPath.row])
        return cell
    }
    
    
}
