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

enum ShowProfileData {
    case AboutMe
    case Statistics
    case Reviews
}

class TransporterPublicProfileViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var transporterName: UILabel!
    @IBOutlet weak var transporterRating: CosmosView!
    @IBOutlet weak var transporterRatingLabel: UILabel!
    
    @IBOutlet weak var aboutMeView: UIView!
    @IBOutlet weak var aboutMeBtn: UIButton!
    @IBOutlet weak var statisticsView: UIView!
    @IBOutlet weak var statisticsBtn: UIButton!
    @IBOutlet weak var reviewsView: UIView!
    @IBOutlet weak var reviewsBtn: UIButton!
    @IBOutlet weak var noReviewsFound: UIStackView!
    
    var profileMO : TransporterProfileModel?
    var showAboutMe: Bool = true
    var showStatistics: Bool = false
    var showReviews: Bool = false
    
    var aboutMeData = [RouteSummaryDetails]()
    var statisticsData = [RouteSummaryDetails]()
    var showProfileData : ShowProfileData = .AboutMe
    
    var transporterID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
//        let id = transporterID ?? user_id
        if let id = transporterID{
            getProfileData(id: id)
        }
        else if let id = user_id{
            getProfileData(id: id)
        }
        
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
        tableView.register(cellType: ReviewsCell.self)
    }
    
    func getProfileData(id: String) {
       
        SVProgressHUD.showInfo(withStatus: "Getting details...")
        APIManager.apiPost(serviceName: "api/transporterPublicProfile", parameters: ["user_id" : id]) { (data, json, error) in
            SVProgressHUD.dismiss()
            guard error == nil, let data = data else {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self); return }
            
            do {
                if let profileData = try JSONDecoder().decode([TransporterProfileModel].self, from: data).first {
                    var aboutMeInfo = [MenuItemStruct]()
                    var statisticsInfo = [MenuItemStruct]()
                    
                    self.profileMO = profileData
                    
                    self.profileImage.sd_setImage(with: URL(string: profileData.userImageURL), placeholderImage: R.image.more_personImg(), options: .continueInBackground, completed: nil)
                    self.transporterName.text = profileData.userName.capitalized
                    self.transporterRating.rating = Double(profileData.avgfdbck)
                    self.transporterRatingLabel.text = "    \(profileData.avgfdbck)/5"
                    
                    //aboutMe Data
                    if profileData.aboutMe != "" {
                        self.aboutMeData.append(RouteSummaryDetails.init(title: "", detail: [MenuItemStruct.init(title: profileData.aboutMe, value: "")]))
                    }
                    
                    aboutMeInfo.append(MenuItemStruct.init(title: "Vehicle Type", value: profileData.vanType))
                    aboutMeInfo.append(MenuItemStruct.init(title: "Vehicle Reg. Number", value: profileData.truckRegistration))
                    
                    aboutMeInfo.append(MenuItemStruct.init(title: "Member Since", value: convertDateFormatter(profileData.joinDate)))
                    aboutMeInfo.append(MenuItemStruct.init(title: "Payment Option", value: profileData.paymentOption))
                    
                    self.aboutMeData.append(RouteSummaryDetails.init(title: "Additional Information:", detail: aboutMeInfo))
                    
                    //statistics Data
                    statisticsInfo.append(MenuItemStruct.init(title: "Jobs Done", value: "\(profileData.jobsDone)"))
                    statisticsInfo.append(MenuItemStruct.init(title: "On Time", value: "\(profileData.totalCountOnTimeYes)%"))
                    statisticsInfo.append(MenuItemStruct.init(title: "On Budget", value: "\(profileData.totalCountOnBudgetYes)%"))
                    self.statisticsData.append(RouteSummaryDetails.init(title: "", detail: statisticsInfo))
                    
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
    
    @IBAction func aboutMeAct(_ sender: Any) {
        noReviewsFound.isHidden = true
        showTappedView(showAboutMe: true, showStatistics: false, showReviews: false)
        
    }
    
    @IBAction func statisticsAct(_ sender: Any) {
        noReviewsFound.isHidden = true
        showTappedView(showAboutMe: false, showStatistics: true, showReviews: false)
    }
    
    @IBAction func reviewsAct(_ sender: Any) {
        noReviewsFound.isHidden = ((profileMO?.driverFeedback.count ?? 0) > 0)
        showTappedView(showAboutMe: false, showStatistics: false, showReviews: true)
    }
    
    func showTappedView(showAboutMe: Bool, showStatistics: Bool, showReviews: Bool) {
        aboutMeView.isHidden = !showAboutMe
        statisticsView.isHidden = !showStatistics
        reviewsView.isHidden = !showReviews
        showProfileData = (showAboutMe == true) ? .AboutMe : (showStatistics == true ? .Statistics : .Reviews)
        tableView.reloadData()
    }
    
}

extension TransporterPublicProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 50))
        headerView.title.text = self.aboutMeData[section].title
        return showProfileData == .AboutMe ? headerView : nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return showProfileData == .AboutMe ? (section == 0 ? 0 : 50) : 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        showProfileData == .AboutMe ? aboutMeData.count : (showProfileData == .Statistics ? statisticsData.count : 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showProfileData == .AboutMe ? aboutMeData[section].detail.count : (showProfileData == .Statistics ? statisticsData[section].detail.count : (profileMO?.driverFeedback.count ?? 0))
  }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch showProfileData {
        case .AboutMe:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: JobSummaryCell.self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundView = nil
            cell.backgroundColor = nil
            if aboutMeData[indexPath.section].detail[indexPath.row].value == "" {
                cell.title.text = aboutMeData[indexPath.section].detail[indexPath.row].title
                cell.title.font = UIFont(name: "Montserrat-Light", size: 13)
                cell.detail.isHidden = true
                cell.bottomView.isHidden = true
            } else {
                cell.title.text = aboutMeData[indexPath.section].detail[indexPath.row].title
                cell.detail.text = aboutMeData[indexPath.section].detail[indexPath.row].value
                cell.detail.isHidden = false
                cell.bottomView.isHidden = false
            }
            return cell

        case .Statistics:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: JobSummaryCell.self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundView = nil
            cell.backgroundColor = nil
            cell.title.text = statisticsData[indexPath.section].detail[indexPath.row].title
            cell.detail.text = statisticsData[indexPath.section].detail[indexPath.row].value
            cell.detail.isHidden = false
            cell.bottomView.isHidden = false
            return cell

        case .Reviews:
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ReviewsCell.self)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundView = nil
            cell.backgroundColor = nil
            
            let allReviews = profileMO?.driverFeedback[indexPath.row]
            
            cell.userName.text = allReviews?.senderName.capitalized
            cell.ratingDescription.text = allReviews?.driverFeedbackDescription
            cell.rating.rating = Double(allReviews?.feedBackStar ?? "") ?? 0.0
            cell.date.text = "on " + convertDateFormatter(allReviews?.feedDate ?? "")
            
            return cell
        }
    }
    
}
