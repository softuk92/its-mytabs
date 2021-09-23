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

extension UIView {

	/*
	func dropShadow(color: UIColor = UIColor(named: "shadowColor")!) {
	   layer.masksToBounds = false
	   layer.shadowColor = color.cgColor
	   layer.shadowOpacity = 0.5
	   layer.shadowOffset = CGSize(width: -1, height: 1)
	   layer.shadowRadius = 1
	   layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
	   layer.shouldRasterize = true
	   layer.rasterizationScale = UIScreen.main.scale
   }*/
}

class PendingPaymentHeaderView: UIView {
	let title = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)

		title.frame = CGRect(x: 24, y: 0, width: frame.size.width-48, height: frame.size.height)
		title.textAlignment = .center
		title.font = UIFont(name: "Montserrat-Light", size: 13)
		title.numberOfLines = 2
		self.addSubview(title)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class PaymentHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource,TableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableShadowView: UIView!
    @IBOutlet weak var paymentTotal: UILabel!
    @IBOutlet weak var invoiceBgView: UIView!
    @IBOutlet weak var pendingPaymentBgView: UIView!
    @IBOutlet weak var submitPaymentView: UIView!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var totalEarning: UILabel!
    @IBOutlet weak var headViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pendingLoadXShare: UILabel!
    @IBOutlet weak var pendingTransporterShare: UILabel!
    @IBOutlet weak var balance: UILabel!
    
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
	var pendingPaymentHeaderView: PendingPaymentHeaderView!
    var requestToLoadx : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("year is \(year)")
//        self.title = "Payment History"
        headView.bottomShadow(color: .black)
        headView.layer.cornerRadius = 5
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
        
        if !(AppUtility.shared.country == .Pakistan) {
            headViewHeight.constant = 0
        }
        self.submitPaymentView.isHidden = true

		//add shadow
		tableShadowView.backgroundColor = R.color.backgroundColor1()
		tableShadowView.layer.cornerRadius = 6
		tableShadowView.layer.shadowOpacity = 0.8
		tableShadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
		tableShadowView.layer.shadowRadius = 4
		tableShadowView.layer.shadowColor = R.color.shadowColor()?.cgColor

		pendingPaymentHeaderView = PendingPaymentHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 64))
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshData(notification:)), name: Notification.Name("refresh"), object: nil)
        getCounter()
        getPaymentHistory()
    }
    
    func getCounter() {
        if user_type == TransportationCompany {
            APIManager.apiPost(serviceName: "api/TransCompCounter", parameters: ["user_id": user_id!]) { [weak self] (data, json, error) in
                guard let self = self else { return }
                if error != nil {
                    showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
                }
                
                guard let json = json else { return }
                let driverEarning = json[0]["Driver_earning"].stringValue
                UserDefaults.standard.setValue(driverEarning, forKey: "total_earning")
                
                if let totalEarning = UserDefaults.standard.string(forKey: "total_earning") {
                    self.paymentTotal.text = AppUtility.shared.country == .Pakistan ? "("+AppUtility.shared.currencySymbol+(Int(Double(totalEarning) ?? 0.0).withCommas())+")" : "£ (" + totalEarning + ")"
                }
            }

        } else {
        if let totalEarning = UserDefaults.standard.string(forKey: "total_earning") {
            paymentTotal.text = AppUtility.shared.country == .Pakistan ? "("+AppUtility.shared.currencySymbol+(Int(Double(totalEarning) ?? 0.0).withCommas())+")" : "£ (" + totalEarning + ")"
        }
        }
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

	private func showShadow(for tableView: UITableView) {
//		tableView.layer.shadowColor = UIColor.black.cgColor
//		tableView.dropShadow(color: UIColor(named: "shadowColor")!, offSet: .zero, radius: 2)

		tableView.layer.borderWidth = 1
		tableView.layer.borderColor = R.color.mehroonColor()?.cgColor
		tableView.layer.cornerRadius = 6

		tableShadowView.isHidden = false
	}

	private func hideShadow(for tableView: UITableView) {
		tableView.layer.borderWidth = 0
//		tableView.layer.shadowColor = UIColor.clear.cgColor
		tableShadowView.isHidden = true
	}
    
    @objc func refreshData(notification: Notification) {
        getPendingPayments()
    }

	var balanceAmount = 0
    func getPendingPayments() {
       
        guard let id = user_id else {
            return
        }
        let params = user_type == TransportationCompany ? ["transportation_id":id] : ["transporter_id":id]
        SVProgressHUD.show()
        let url = user_type == TransportationCompany ? "api/getAllPaytoLoadxJobsListForTC" : "api/getAllPaytoLoadxJobsList"
        APIManager.apiPost(serviceName: url, parameters: params) { [weak self] data, json, error in
            guard let self = self else {return}
            if error == nil{
                if let json = json{
                    let payToLoadX = PayToLoadX(json: json)
					self.balanceAmount = payToLoadX.summary.balance
					self.totalPayableToLoadX = payToLoadX.summary.balance.withCommas()
                    self.pendingPaymentsDataSource = payToLoadX.jobLists

                    self.totalEarning.text = "Pending Loadx Share"
                    self.paymentTotal.text = "("+AppUtility.shared.currencySymbol+self.totalPayableToLoadX+")"
//                    self.paymentButton.setTitle(totolPayabale, for: .normal)

					//header
					self.pendingPaymentHeaderView.title.text = payToLoadX.summary.weekRange

					//summary
                    self.pendingLoadXShare.text = "Rs. " + "\(payToLoadX.loadXShare.withCommas())"
                    self.pendingTransporterShare.text = "Rs. " + "\(payToLoadX.transporterShare.withCommas())"
                    self.balance.text = "Rs. " + "\(payToLoadX.summary.balance.withCommas())"

					//payment button title
					let titlePrefix = payToLoadX.summary.balanceType == .loadXToTransporter ? "Request for Payment " : "Pay Now "
					let buttonTitle = titlePrefix + "(\(AppUtility.shared.currencySymbol+self.totalPayableToLoadX))"
                    self.requestToLoadx = (payToLoadX.summary.balanceType == .loadXToTransporter)
					self.paymentButton.setTitle(buttonTitle, for: .normal)

					self.showShadow(for: self.tableView)
					self.tableView.tableHeaderView = self.pendingPaymentHeaderView

					self.tableView.reloadData()
                }
            }
            SVProgressHUD.dismiss()
        }
    }

    func getPaymentHistory() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if let totalEarning = UserDefaults.standard.string(forKey: "total_earning") {
			self.totalEarning.text = "Total Earning"
            paymentTotal.text = AppUtility.shared.country == .Pakistan ? "("+AppUtility.shared.currencySymbol+(Int(Double(totalEarning) ?? 0.0).withCommas())+")" : "£ (" + totalEarning + ")"
        }
        let endPointUrl = user_type == TransportationCompany ? "api/paymentHistoryTC" : "api/transporterPaymentHistoryList"
            let paymentHistory_URL = main_URL+endPointUrl
        let parameters : Parameters = user_type == TransportationCompany ? ["transportation_id" : user_id!] : ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(paymentHistory_URL, method : .post, parameters : parameters).responseJSON { [weak self]
                    response in
					guard let self = self else {return}

					self.hideShadow(for: self.tableView)
					self.tableView.tableHeaderView = nil

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
		if showInvoiceData {
			return 180
		}else {
			return 84
		}
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
			addCornerRadius(for: cell, indexPath: indexPath)
            return cell
        }
    }

	private func addCornerRadius(for cell: EarningTableViewCell, indexPath: IndexPath) {
		//if single cell round all corners
		if pendingPaymentsDataSource.count == 1{
			cell.setRoundedCorners(corners: .allCorners, radius: 5)
		}
		//round corner on top
		else if indexPath.row == 0 {
			cell.setRoundedCorners(corners: [.topRight, .topLeft], radius: 5)
			cell.bottomBorder.isHidden = false
		}
		//round corners at bottom
		else if indexPath.row == pendingPaymentsDataSource.count - 1 {
			cell.setRoundedCorners(corners: [.bottomRight, .bottomLeft], radius: 5)
			cell.bottomBorder.isHidden = true
		}
		//no round corners
		else {
			cell.setRoundedCorners(corners: .allCorners, radius: 0)
			cell.bottomBorder.isHidden = false
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
//        let payableAmount = paymentsToPay.reduce(0) { (result, item) -> Int in
//            return result + (Int(item.loadxShare) ?? 0)
//        }
//        let totalAmount = payableAmount == 0 ? totalPayableToLoadX : payableAmount.withCommas()
//        paymentButton.setTitle("PAY TOTAL AMOUNT "+AppUtility.shared.currencySymbol+totalAmount, for: .normal)
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
//        let vc = UploadReceiptViewController.instantiate()
//        vc.paymentsToPay = paymentsToPay
//        self.navigationController?.pushViewController(vc, animated: true)
        if let request = requestToLoadx, request == true {
            requestForPayment()
        } else {
		let vc = PaymentTypeViewController.instantiate()
		vc.amount = balanceAmount
		vc.paymentsToPay = paymentsToPay
		self.navigationController?.pushViewController(vc, animated: true)
        }
	}
    
    func requestForPayment() {
        guard let userId = user_id else { return }
        let parameters = user_type == TransportationCompany ? ["transportation_id" : userId, "send_req" : "1", "description" : ""] : ["transporter_id" : userId, "send_req" : "1", "description" : ""]
        SVProgressHUD.show()
        let url = user_type == TransportationCompany ? "api/sendPaymentRequestDataForTC" : "api/sendPaymentRequestData"
        APIManager.apiPostMultipart(serviceName: url, parameters: parameters, multipartImages: []) { (data, json, error, progress) in
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error!.localizedDescription, viewController: self)
            }

            guard let json = json else { return }
            let result = json[0]["result"].stringValue
            let message = json[0]["msg"].stringValue
            
            if result == "1" {
                let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "SuccessVC") as? SuccessVC
                vc?.titleStr = "Success"
                vc?.subtitleStr = "We've received your request. Your payment wil be transferred within 24 hours."
                vc?.btnTitle = "Dashboard"
            self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                showSuccessAlert(question: message, viewController: self)
//                showAlert(title: "Alert", message: message, viewController: self)
            }
        }
    }
    
}
