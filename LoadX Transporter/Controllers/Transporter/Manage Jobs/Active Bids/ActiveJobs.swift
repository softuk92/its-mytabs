//
//  ActiveJobs.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IBAnimatable

class ActiveJobs: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var searchNewJobBtn: UIButton!
    lazy var activeJobsModel = [ActiveJobsModel]()
    private var rowID : Int?
    var bid_price : String?
    var puStreet_Route = ""
    var pu_City_Route = ""
    var pu_allAddress = ""
    var doStreet_Route = ""
    var do_City_Route = ""
    var do_allAddress = ""
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Active Bids"+" ("+userActiveJobs+")"
        getActiveJobs()
        tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = footerView
        tableView.register(UINib(nibName: "ActiveJobsCell", bundle: nil) , forCellReuseIdentifier: "activeJobs")
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(ActiveJobs.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        
    }
    
    @objc func populate() {
        DispatchQueue.main.async {
        self.getActiveJobs()
        self.refresher.endRefreshing()
        }
    }
    
    func getActiveJobs() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let activeJobs_URL = main_URL+"api/transporterLiveJobs"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(activeJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("active Jobs jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
//                        let message = jsonData[0]["message"].stringValue
                        self.activeJobsModel.removeAll()
                        if result == "0" {
                            self.tableView.isHidden = true
                        } else {
                        let error = response.error
                        let data = response.data
                        if error == nil {
                            do {
                                self.activeJobsModel = try JSONDecoder().decode([ActiveJobsModel].self, from: data!)
                                SVProgressHUD.dismiss()
                                print(self.activeJobsModel)
                                
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
        return activeJobsModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 355
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activeJobs") as! ActiveJobsCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        let activeJobsRow = activeJobsModel[indexPath.row]
        
        let movingItem = activeJobsRow.moving_item
        cell.moving_item.text = movingItem.capitalized
        let puStreet = activeJobsRow.pu_street
        let puRoute = activeJobsRow.pu_route
        let puCity = activeJobsRow.pu_city
        let puPostCode = activeJobsRow.pu_post_code
        
        if puStreet != "" || puRoute != "" {
            puStreet_Route = puStreet+" "+puRoute+","
            cell.pick_up.text = puStreet
        }
        if puCity != "" {
            pu_City_Route = puStreet_Route+" "+puCity+","
            cell.pick_up.text = pu_City_Route
        }
        if puPostCode != "" {
            let spaceCount = puPostCode.filter{$0 == " "}.count
            if spaceCount > 0 {
                if let first = puPostCode.components(separatedBy: " ").first {
                    pu_allAddress = pu_City_Route+" "+first
                    cell.pick_up.text = pu_allAddress
                }
            } else if spaceCount == 0 {
                pu_allAddress = pu_City_Route+" "+puPostCode
                cell.pick_up.text = pu_allAddress
            }
        }
        
        let doStreet = activeJobsRow.do_street
        let doRoute = activeJobsRow.do_route
        let doCity = activeJobsRow.do_city
        let doPostCode = activeJobsRow.do_post_code
        
        if doStreet != "" || doRoute != "" {
            doStreet_Route = doStreet+" "+doRoute+","
            cell.drop_off.text = doStreet
        }
        if doCity != "" {
            do_City_Route = doStreet_Route+" "+doCity+","
            cell.drop_off.text = do_City_Route
        }
        if doPostCode != "" {
            let spaceCount = doPostCode.filter{$0 == " "}.count
            if spaceCount > 0 {
                if let first = doPostCode.components(separatedBy: " ").first {
                    do_allAddress = do_City_Route+" "+first
                    cell.drop_off.text = do_allAddress
                }
            } else if spaceCount == 0 {
                do_allAddress = do_City_Route+" "+doPostCode
                cell.drop_off.text = do_allAddress
            }
        }
        let stringDate = activeJobsRow.date
        let convertedDate = self.convertDateFormatter(stringDate)
        cell.date.text = convertedDate
        cell.totalBidLabel.text = activeJobsRow.totalbid
        cell.min_bid.text = "£"+activeJobsRow.min_bid
        cell.max_bid.text = "£"+activeJobsRow.current_bid
        
        cell.deleteRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            let refreshAlert = UIAlertController(title: "Delete!", message: "Do You Want to Delete this Job?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                jb_id = self.activeJobsModel[indexPath.row].jb_id
                self.rowID = indexPath.row
                self.deleteJob()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
        }
        
        cell.detailJobRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            del_id = self.activeJobsModel[indexPath.row].del_id
            self.performSegue(withIdentifier: "detail", sender: self)
        }
        
        cell.updatePriceRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            del_id = self.activeJobsModel[indexPath.row].del_id
            jb_id = self.activeJobsModel[indexPath.row].jb_id
            self.current_bid_label.text = "£"+self.activeJobsModel[indexPath.row].current_bid
            UIView.animate(withDuration: 0.3, animations: {
                self.searchNewJobBtn.isHidden = true
                self.popupView.layer.borderColor = UIColor.gray.cgColor
                self.popupView.layer.borderWidth = 1
                self.popupView.layer.cornerRadius = 5
                self.tableView.alpha = 0.2
                self.view.addSubview(self.popupView)
                self.popupView.center = self.view.center
            })
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.alpha = 1
        self.searchNewJobBtn.isHidden = false
        self.popupView.removeFromSuperview()
    }
    
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var bid_price_field: AnimatableTextField!
    @IBOutlet weak var current_bid_label: UILabel!
    
    @IBAction func updatePrice(_ sender: Any) {
        updateBidPrice()
    }
    
    func updateBidPrice() {
        SVProgressHUD.show(withStatus: "Updating Price...")
        if del_id != nil && jb_id != nil && self.bid_price_field.text != "" && user_id != nil {
            let updateBid_URL = main_URL+"api/transporterUpdateBidPrice"
            let parameters : Parameters = ["jb_id" : jb_id!, "bid_price" : self.bid_price_field.text!, "del_id" : del_id!, "user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(updateBid_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("update Bid Price jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        if result == "1" {
                            self.performSegue(withIdentifier: "priceUpdated", sender: nil)
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
            let alert = UIAlertController(title: "Error!", message: "Please enter your email address", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    func deleteJob() {
        SVProgressHUD.show(withStatus: "Deleting Job...")
        if jb_id != "" {
            let deleteJob_URL = main_URL+"api/transporterDeleteBidData"
            let parameters : Parameters = ["jb_id" : jb_id!, "user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(deleteJob_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("delete job jsonData is \(jsonData)")
//                        let result = jsonData[0]["result"].stringValue
//                        let message = jsonData[0]["message"].stringValue
                        self.activeJobsModel.remove(at: self.rowID!)
                        if let userActiveJobsInt = Int(userActiveJobs) {
                            userActiveJobs = String(userActiveJobsInt - 1)
                            self.title = "Active Bids"+" ("+userActiveJobs+")"
                        }
                        if userActiveJobs == "0" {
                            self.tableView.isHidden = true
                            self.tableView.reloadData()
                        } else {
                            self.tableView.reloadData()
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
            let alert = UIAlertController(title: "Error!", message: "Please enter your email address", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
