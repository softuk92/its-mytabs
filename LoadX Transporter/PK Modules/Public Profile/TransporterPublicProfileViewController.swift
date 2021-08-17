//
//  TransporterPublicProfileViewController.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 17/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Cosmos
import SVProgressHUD

class TransporterPublicProfileViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var transporterName: UILabel!
    @IBOutlet weak var transporterRating: CosmosView!
    @IBOutlet weak var transporterRatingLabel: UILabel!
        
    var profileMO : TransporterProfileModel?
    var showAboutMe: Bool = true
    var showStatistics: Bool = false
    var showReviews: Bool = false
    
    var routeSummaryDetails = [RouteSummaryDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        getProfileData()
    }
    
    func configureView() {
        topView.bottomShadow(color: .black)
        bottomView.bottomShadow(color: .black)
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: JobSummaryCell.self)
    }
    
    func getProfileData() {
        guard let userId = user_id else { return }
        SVProgressHUD.showInfo(withStatus: "Getting details...")
        APIManager.apiPost(serviceName: "api/transporterPublicProfile", parameters: ["user_id" : userId]) { (data, json, error) in
            SVProgressHUD.dismiss()
            guard error == nil, let data = data else {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self); return }
            
            do {
                if let profileData = try JSONDecoder().decode([TransporterProfileModel].self, from: data).first {
                    var info = [MenuItemStruct]()
                    
                    self.profileMO = profileData
                    
                    self.profileImage.sd_setImage(with: URL(string: profileData.userImageURL), placeholderImage: R.image.more_personImg(), options: .continueInBackground, completed: nil)
                    self.transporterName.text = profileData.userName.capitalized
                    self.transporterRating.rating = Double(profileData.avgfdbck)
                    self.transporterRatingLabel.text = "    \(profileData.avgfdbck)/5"
                    
                    if profileData.aboutMe != "" {
                        self.routeSummaryDetails.append(RouteSummaryDetails.init(title: "Description", detail: [MenuItemStruct.init(title: profileData.aboutMe, value: "")]))
                    }
                    
                    self.tableView.reloadData()
                }
                
            } catch {
            showAlert(title: "Error", message: error.localizedDescription, viewController: self)
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TransporterPublicProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?   {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 50))
        headerView.title.text = self.routeSummaryDetails[section].title
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        self.routeSummaryDetails.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeSummaryDetails[section].detail.count
  }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
}
