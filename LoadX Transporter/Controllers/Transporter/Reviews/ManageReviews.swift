//
//  ManageReviews.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/4/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ManageReviews: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    @IBOutlet weak var noReview_lbl: UILabel!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var errorView: UIStackView!
    
    lazy var allReviewsModel = [AllReviewsModel]()
    var refresher: UIRefreshControl!
    
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Reviews"
        getAllReviews()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 180.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: ReviewsCell.self)
        tableView.bottomShadow(color: .black)
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(ManageReviews.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
      
    }
   
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
     }
    
    @objc func populate() {
        DispatchQueue.main.async {
        self.getAllReviews()
        self.refresher.endRefreshing()
        }
    }

    func getAllReviews() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let activeJobs_URL = main_URL+"api/transporterReviews"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(activeJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("all reviews jsonData is \(jsonData)")
//                        let result = jsonData[0]["result"].stringValue
                        let result = jsonData[0]["result"].stringValue
                        self.allReviewsModel.removeAll()
                        if result == "0" {
                            self.tableView.isHidden = true
                            self.errorView.isHidden = false
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.allReviewsModel = try JSONDecoder().decode([AllReviewsModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    
                                    DispatchQueue.main.async {
                                        self.tableViewHeight.constant = CGFloat(self.allReviewsModel.count * 125)
                                        self.errorView.isHidden = true
                                        self.tableView.isHidden = false
                                        self.tableView.reloadData()
                                        self.view.layoutIfNeeded()
                                    }
                                    
                                } catch {
                                    print(error)
                                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    } else {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: response.result.error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("Error \(response.result.error!)")
                    }
                }
            } else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error", message: "Try again later", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReviewsModel.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 166
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ReviewsCell.self)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        
        let allReviews = allReviewsModel[indexPath.row]
        
        cell.userName.text = allReviews.user_name.capitalized
        cell.ratingDescription.text = allReviews.description
        cell.rating.rating = Double(allReviews.feed_back_star) ?? 0.0
        cell.date.text = "on " + convertDateFormatter(allReviews.feed_date)
        
        return cell
        
    }

}
