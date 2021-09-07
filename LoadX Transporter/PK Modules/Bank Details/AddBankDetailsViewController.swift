//
//  AddBankDetailsViewController.swift
//  LoadX Transporter
//
//  Created by Muhammad Fahad Baig on 07/09/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import IBAnimatable

class AddBankDetailsViewController: UIViewController {
    
    @IBOutlet weak var bankName: AnimatableTextField!
    @IBOutlet weak var accountTitle: AnimatableTextField!
    @IBOutlet weak var accountIban: AnimatableTextField!
    @IBOutlet weak var branchCode: AnimatableTextField!
    @IBOutlet weak var addBankBtn: UIButton!
    
    @IBOutlet weak var banksListView: UIView!
    @IBOutlet weak var innerBanksListView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    var list = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((AppUtility.shared.bankMO?.accountTitle ?? "") == "N/A") || ((AppUtility.shared.bankMO?.accountTitle ?? "") == "") {
            addBankBtn.setTitle("Add Details", for: .normal)
        } else {
            bankName.text = AppUtility.shared.bankMO?.bankName.capitalized
            accountTitle.text = AppUtility.shared.bankMO?.accountTitle.capitalized
            accountIban.text = AppUtility.shared.bankMO?.accountIban
            branchCode.text = AppUtility.shared.bankMO?.branchCode.capitalized
            addBankBtn.setTitle("Update Details", for: .normal)
        }
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundView = nil
        tableview.backgroundColor = UIColor.clear
        self.innerBanksListView.layer.cornerRadius = 10
        
        AppUtility.shared.getBankList { [weak self] (result) in
            switch result {
            case .success(let banks):
                self?.list = banks.map{$0.bank_name}
                self?.tableview.reloadData()
            case .failure(_):
                return
            }
            
        }
        
    }
    
    @IBAction private func btnCross_Pressed(_ sender : UIButton) {
        banksListView.isHidden = true
    }
    
    @IBAction private func btnShowPop(_ sender : UIButton) {
        banksListView.isHidden = false
    }
    
    @IBAction func bankBtnAct(_ sender: Any) {
        guard let userID = user_id, let bankName = bankName.text, let accountTitle = accountTitle.text, let accountIban = accountIban.text, let branchCode = branchCode.text  else { return }
        let parameters = ["bank_name" : bankName, "account_title" : accountTitle, "account_iban" : accountIban, "branch_code" : branchCode, "user_id": userID]
        APIManager.apiPost(serviceName: "api/addBankDetails", parameters: parameters) { [weak self] (data, json, error) in
            guard let self = self else { return }
            if error != nil {
                showAlert(title: "Error", message: error?.localizedDescription ?? "", viewController: self)
            }
            guard let json = json else { return }
            let result = json[0]["result"].stringValue
            let message = json[0]["message"].stringValue
            if result == "1" {
                AppUtility.shared.bankMO = BankMO.init(accountTitle: accountTitle, accountIban: accountIban, bankName: bankName, branchCode: branchCode)
                self.addBankBtn.setTitle("Update Details", for: .normal)
                showSuccessAlert(question: "Bank Details Updated Successfully", viewController: self)
            } else {
                showAlert(title: "Error", message: message, viewController: self)
            }
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: UITableViewDelegate
extension AddBankDetailsViewController: UITableViewDataSource , UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobNatureCell", for: indexPath) as? JobNatureCell
        cell?.layer.cornerRadius = 10
        cell?.backgroundColor = UIColor.clear
        cell?.backgroundView = nil
        cell?.lblJobNature.text = self.list[indexPath.row]
        if indexPath.row == 11 {
            cell?.bottomLineView.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedValue = self.list[indexPath.row]
        bankName.text = selectedValue
        banksListView.isHidden = true
    }
    
}
