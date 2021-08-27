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
    lazy var allReviewsModel = [AllReviewsModel]()
    var refresher: UIRefreshControl!
    
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Reviews"
        getAllReviews()
        tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 180.0
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.register(UINib(nibName: "ManageReviewsCell", bundle: nil) , forCellReuseIdentifier: "manageReviews")
        tableView.register(cellType: ReviewsCell.self)
        
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
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.allReviewsModel = try JSONDecoder().decode([AllReviewsModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.isHidden = false
                                        self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageReviews") as! ManageReviewsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        
        if switchCheck == true {
            tableView.backgroundColor = UIColor.black
            cell.innerView.backgroundColor = UIColor.darkGray
            cell.feed_date.textColor = UIColor.white
            
            cell.job_description.textColor = UIColor.white
            cell.job_title.textColor = UIColor.white
            cell.transporter_name.textColor = UIColor.white
            cell.feed_date_icon.image = UIImage(named: "deliveryDateDark")
            cell.feedback_stars.textColor = UIColor.black
        }else{
            
        }
        
        
        let allReviews = allReviewsModel[indexPath.row]

        let transporterName = allReviews.user_name
        cell.transporter_name.text = transporterName.capitalized
        cell.job_title.text = allReviews.job_title
//        = allReviews.description
        let string2 = allReviews.description.replacingOccurrences(of: "'", with: "")
         cell.job_description.text = string2
        let stringDate = allReviews.feed_date
        let convertedDate = self.convertDateFormatter(stringDate)
        cell.feed_date.text = "Date: " + convertedDate
        
        let feedbackStars = allReviews.feed_back_star
        
        if feedbackStars == "null" {
            cell.feedback_stars.text = "null"
            cell.cosmosView.rating = 0.0
        } else {
            cell.feedback_stars.text = allReviews.feed_back_star/*+".0"*/
            cell.cosmosView.rating = Double(feedbackStars)!
        }
        
        return cell
    }
    
    func convertDateFormatter(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
}
