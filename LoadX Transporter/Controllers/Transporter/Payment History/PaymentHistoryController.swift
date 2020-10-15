//
//  PaymentHistoryController.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/12/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class PaymentHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentTotal: UILabel!
    lazy var paymentHistoryModel = [PaymentHistoryModel]()
    let year = Calendar.current.component(.year, from: Date())
    var refresher: UIRefreshControl!
    var paymentHistory: String?
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("year is \(year)")
//        self.title = "Payment History"
       
        getPaymentHistory()
//        w.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PaymentHistoryCell", bundle: nil) , forCellReuseIdentifier: "paymentHistory")
        
       // paymentTotal.text = driverEarning
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(PaymentHistoryController.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
    }
    override func viewWillAppear(_ animated: Bool) {
         guard let totalEarning = UserDefaults.standard.string(forKey: "total_earning") else { return }
               paymentTotal.text =  "£ (" + totalEarning + ")"
    }
    @objc func populate() {
        DispatchQueue.main.async {
        self.getPaymentHistory()
        self.refresher.endRefreshing()
        }
    }
    
    func getPaymentHistory() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let paymentHistory_URL = main_URL+"api/transporterPaymentHistoryList"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(paymentHistory_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("payment History jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
                        self.paymentHistoryModel.removeAll()
                        if result == "0" {
                            self.tableView.isHidden = true
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.paymentHistoryModel = try JSONDecoder().decode([PaymentHistoryModel].self, from: data!)
                                    SVProgressHUD.dismiss()
                                    print(self.paymentHistoryModel)

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
            let alert = UIAlertController(title: "Error", message: "Internet connection is missing", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentHistoryModel.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentHistory") as! PaymentHistoryCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        
        cell.cell_view.layer.cornerRadius = 10
        cell.viewInvocie_btn.clipsToBounds = true
        cell.viewInvocie_btn.layer.cornerRadius = 10
        cell.viewInvocie_btn.layer.maskedCorners = [ .layerMaxXMaxYCorner]
        
      
        
        let paymentHistoryRow = paymentHistoryModel[indexPath.row]
        
        let movingItem = paymentHistoryRow.moving_item
        cell.moving_item.text = movingItem?.capitalized
        
        let stringDate = paymentHistoryRow.pay_date
        
        if (stringDate?.contains("am")) != nil || ((stringDate?.contains("pm")) != nil) {
            cell.job_posted_date.text = self.convertDateFormatter(String(stringDate?.dropLast(2) ?? ""))
        } else {
        cell.job_posted_date.text = self.convertDateFormatter(stringDate)
        }
        
        let jobID = paymentHistoryRow.payment_id ?? ""
        let job_id = "LOADX"+String(self.year)+"JI"+jobID
        cell.invoiceNo.text = job_id
        let payment_type = paymentHistoryRow.payment_type
        if payment_type == "full" {
            cell.paid.text = "Received"
        }
        cell.viewInvoiceRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            let booked_id = self.paymentHistoryModel[indexPath.row].is_booked_job
            payment_id = self.paymentHistoryModel[indexPath.row].payment_id

            if booked_id == "1" {
//            self.performSegue(withIdentifier: "showBooked", sender: self)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowInvoiceBookedJob") as? ShowInvoiceBookedJob
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
//            self.performSegue(withIdentifier: "invoice", sender: self)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowInvoice") as? ShowInvoice
            self.navigationController?.pushViewController(vc!, animated: true)
                
            }
        }
        
        return cell
        
    }
    
    func convertDateFormatter(_ date: String?) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date ?? "")
      
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        return  dateFormatter.string(from: date ?? Date())
        
    }
    
}
