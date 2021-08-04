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

class PaymentHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource,TableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentTotal: UILabel!
    @IBOutlet weak var invoiceBgView: UIView!
    @IBOutlet weak var pendingPaymentBgView: UIView!
    @IBOutlet weak var submitPaymentView: UIView!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var totalEarning: UILabel!
    @IBOutlet weak var headViewHeight: NSLayoutConstraint!
    
    lazy var paymentHistoryModel = [PaymentHistoryModel]()
    var filteredPaymentHistory = [PaymentHistoryModel]()
    var pendingPaymentsDataSource = [PayToLoadXItme]()
    var paymentsToPay = [PayToLoadXItme]()

    var totalPayableToLoadX = ""
    let year = Calendar.current.component(.year, from: Date())
    var refresher: UIRefreshControl!
    var paymentHistory: String?
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    var showInvoiceData = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("year is \(year)")
//        self.title = "Payment History"
        headView.bottomShadow(color: .black)
        headView.layer.cornerRadius = 5
        getPaymentHistory()
//        w.backgroundView = UIImageView(image: UIImage(named: "background.png"))
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PaymentHistoryCell", bundle: nil) , forCellReuseIdentifier: "paymentHistory")
        tableView.register(cellType: EarningTableViewCell.self)
        
       // paymentTotal.text = driverEarning
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(PaymentHistoryController.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        if let totalEarning = UserDefaults.standard.string(forKey: "total_earning") {
            paymentTotal.text = AppUtility.shared.country == .Pakistan ? "("+AppUtility.shared.currencySymbol+(Int(Double(totalEarning) ?? 0.0).withCommas())+")" : "£ (" + totalEarning + ")"
        }
        if !(AppUtility.shared.country == .Pakistan) {
            headViewHeight.constant = 0
        }
        self.submitPaymentView.isHidden = true
    }
 
    @objc func populate() {
        DispatchQueue.main.async {
        self.getPaymentHistory()
        self.refresher.endRefreshing()
        }
    }
    
    @IBAction func didTapInvoice(sender: UIButton){
        showInvoiceData = true
        invoiceBgView.isHidden = false
        pendingPaymentBgView.isHidden = true
        submitPaymentView.isHidden = true
        getPaymentHistory()
    }
    
    @IBAction func didTapPendingPayments(sender: UIButton){
        showInvoiceData = false
        invoiceBgView.isHidden = true
        pendingPaymentBgView.isHidden = false
        submitPaymentView.isHidden = false
        getPendingPayments()
    }
    
    func getPendingPayments() {
       
        guard let id = user_id else {
            return
        }
        let params = ["user_id":id]
        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/payToLoadxList", parameters: params) { [weak self]data, json, error in
            guard let self = self else {return}
            if error == nil{
                if let json = json{
                    let payToLoadX = PayToLoadX(json: json)
                    self.totalPayableToLoadX = payToLoadX.totalPendingPayToLoadx.withCommas()
                    self.pendingPaymentsDataSource = payToLoadX.jobLists
                    let totolPayabale = "PAY TOTAL AMOUNT "+AppUtility.shared.currencySymbol+self.totalPayableToLoadX
                    self.totalEarning.text = "Pending Loadx Share"
                    self.paymentTotal.text = "("+AppUtility.shared.currencySymbol+self.totalPayableToLoadX+")"
                    self.paymentButton.setTitle(totolPayabale, for: .normal)
                    self.tableView.reloadData()
                }
            }
            SVProgressHUD.dismiss()
        }
    }
    func getPaymentHistory() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if let totalEarning = UserDefaults.standard.string(forKey: "total_earning") {
            paymentTotal.text = AppUtility.shared.country == .Pakistan ? "("+AppUtility.shared.currencySymbol+(Int(Double(totalEarning) ?? 0.0).withCommas())+")" : "£ (" + totalEarning + ")"
        }
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
                        self.filteredPaymentHistory.removeAll()
                        if result == "0" {
                            self.tableView.isHidden = true
                        } else {
                            let error = response.error
                            let data = response.data
                            if error == nil {
                                do {
                                    self.paymentHistoryModel = try JSONDecoder().decode([PaymentHistoryModel].self, from: data!)
                                    self.filteredPaymentHistory = self.paymentHistoryModel
//                                        .filter{$0.route_id == nil}
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
            let alert = UIAlertController(title: "Error", message: "Internet connection is missing", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showInvoiceData{
            return filteredPaymentHistory.count
        }
        else{
            return pendingPaymentsDataSource.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 167
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showInvoiceData{
            return self.createInvoicesCell(tableView, cellForRowAt: indexPath)
        }
        else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EarningTableViewCell.self)
            let data = pendingPaymentsDataSource[indexPath.row]
            cell.cellDelegate = self
            cell.populateData(data: data)
            return cell
        }
        
    }
    
    
    func createInvoicesCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentHistory") as! PaymentHistoryCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil

        cell.cell_view.layer.cornerRadius = 10
        cell.viewInvocie_btn.clipsToBounds = true
        cell.viewInvocie_btn.layer.cornerRadius = 10
        cell.viewInvocie_btn.layer.maskedCorners = [ .layerMaxXMaxYCorner]



        let paymentHistoryRow = filteredPaymentHistory[indexPath.row]

        if paymentHistoryRow.moving_item != nil {
            cell.moving_item.text = paymentHistoryRow.moving_item?.capitalized
        } else {
            cell.moving_item.text = "LR00\(paymentHistoryRow.route_id ?? "")"
        }

        let stringDate = paymentHistoryRow.pay_date

        if (stringDate?.contains("am")) != nil || ((stringDate?.contains("pm")) != nil) {
            cell.job_posted_date.text = self.convertDateFormatter(String(stringDate?.dropLast(2) ?? ""))
        } else {
        cell.job_posted_date.text = self.convertDateFormatter(stringDate)
        }

        let jobID = paymentHistoryRow.payment_id ?? ""
        let job_id = "LOADX"+String(self.year)+"JI"+jobID
//        let job_id = "LX00"+jobID
        cell.invoiceNo.text = job_id
        let payment_type = paymentHistoryRow.payment_type
        if payment_type == "full" {
            cell.paid.text = "Received"
        }
        cell.viewInvoiceRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            let booked_id = self.filteredPaymentHistory[indexPath.row].is_booked_job
            payment_id = self.filteredPaymentHistory[indexPath.row].payment_id

            if paymentHistoryRow.moving_item != nil {
            if booked_id == "1" {
//            self.performSegue(withIdentifier: "showBooked", sender: self)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowInvoiceBookedJob") as? ShowInvoiceBookedJob
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
//            self.performSegue(withIdentifier: "invoice", sender: self)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowInvoice") as? ShowInvoice
            self.navigationController?.pushViewController(vc!, animated: true)

            }
            } else {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowRouteInvoiceViewController") as? ShowRouteInvoiceViewController {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = UploadReceiptViewController.instantiate()
//        vc.paymentsToPay = paymentsToPay
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didTapButton(cell: UITableViewCell, selected: Bool?) {
        guard let path = tableView.indexPath(for: cell), let selection = selected else {return}
        if selection {
        paymentsToPay.append(pendingPaymentsDataSource[path.row])
        } else {
            let pendingPaymentDS = pendingPaymentsDataSource[path.row]
            paymentsToPay.removeAll(where: { (item) -> Bool in
                item.loadxShare == pendingPaymentDS.loadxShare
            })
        }
        let payableAmount = paymentsToPay.reduce(0) { (result, item) -> Int in
            return result + (Int(item.loadxShare) ?? 0)
        }
        let totalAmount = payableAmount == 0 ? totalPayableToLoadX : payableAmount.withCommas()
        paymentButton.setTitle("PAY TOTAL AMOUNT "+AppUtility.shared.currencySymbol+totalAmount, for: .normal)
    }
    func convertDateFormatter(_ date: String?) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date ?? "")
      
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        return  dateFormatter.string(from: date ?? Date())
        
    }
    
    @IBAction func didTapAmount(sender: Any){
        let vc = UploadReceiptViewController.instantiate()
        vc.paymentsToPay = paymentsToPay
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
