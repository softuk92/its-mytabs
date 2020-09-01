//
//  ActivityLogList.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/12/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewAllQueries: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    lazy var viewAllQueriesModel = [ViewAllQueriesModel]()
    
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "All Queries"
        showAllQueries()
        tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ViewAllQueriesCell", bundle: nil) , forCellReuseIdentifier: "allQueries")
    }
    
    func showAllQueries() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let activityLog_URL = main_URL+"api/transporterViewAllQueries"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(activityLog_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("all queries jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        
                        if result == "0" {
                            self.tableView.isHidden = true
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.viewAllQueriesModel = try JSONDecoder().decode([ViewAllQueriesModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    print(self.viewAllQueriesModel)

                                    DispatchQueue.main.async {
                                        self.tableView.isHidden = false
                                        self.tableView.reloadData()
                                    }

                                } catch {
                                    print(error)
                                    let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                        
                    } else {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
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
            let alert = UIAlertController(title: "Error", message: "Internet connection is missing", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewAllQueriesModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allQueries") as! ViewAllQueriesCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        
        if switchCheck == true {
            tableView.backgroundColor = UIColor.black
            cell.cell_view.backgroundColor = UIColor.darkGray
            cell.created_at.textColor = UIColor.white
            cell.pcategory.textColor = UIColor.white
            cell.pdescription.textColor = UIColor.white
            cell.pstatus.textColor = UIColor.white
            cell.date_lbl.textColor = UIColor.white
        }else{
            
        }
        
        let viewAllQueriesRow = viewAllQueriesModel[indexPath.row]
        
        cell.pcategory.text = viewAllQueriesRow.pcategory
        cell.pdescription.text = viewAllQueriesRow.pdescription
        
        let date = viewAllQueriesRow.created_at
        let stringDate = String(date.prefix(10))
        let convertedDate = self.convertDateFormater(stringDate)
        cell.created_at.text = convertedDate
        let queryStatus = viewAllQueriesRow.pstatus
        
        if queryStatus == "Pending" {
        cell.pstatus.text = queryStatus
        cell.pstatus.backgroundColor = UIColor(red: 218/255, green: 51/255, blue: 62/255, alpha: 1)
        cell.pstatus.layer.cornerRadius = 5
        } else if queryStatus == "Inprogress" {
            cell.pstatus.text = queryStatus
            cell.pstatus.backgroundColor = UIColor(red: 243/255, green: 144/255, blue: 42/255, alpha: 1)
            cell.pstatus.layer.cornerRadius = 5
        } else {
        cell.pstatus.text = queryStatus
        cell.pstatus.backgroundColor = UIColor(red: 69/255, green: 181/255, blue: 99/255, alpha: 1)
        cell.pstatus.layer.cornerRadius = 5
        }
        return cell
        
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
}
