//
//  RegisterViewControllerPk.swift
//  LoadX Transporter
//
//  Created by Muhammad Fahad Baig on 13/07/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import DropDown
import SVProgressHUD
import IBAnimatable
import GoogleMaps
import GooglePlaces
import SKPhotoBrowser
import MobileCoreServices

class RegisterViewControllerPk: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var fullName: AnimatableTextField!
    @IBOutlet weak var email_address: AnimatableTextField!
    @IBOutlet weak var phone_no: AnimatableTextField!
    @IBOutlet weak var address: AnimatableTextField!
    @IBOutlet weak var van_type: AnimatableTextField!
    @IBOutlet weak var vehicle_reg_no: AnimatableTextField!
    @IBOutlet weak var cnicFrontimage: UIImageView!
    @IBOutlet weak var cnicBackimage: UIImageView!
    
    @IBOutlet weak var cnicFrontBtn: UIButton!
    @IBOutlet weak var cnicBackBtn: UIButton!
    @IBOutlet weak var Registration_btn: UIButton!
    @IBOutlet weak var login_btn: UIButton!
    
    @IBOutlet weak var vehiclesListView: UIView!
    @IBOutlet weak var innerVehiclesListView: UIView!
    @IBOutlet weak var tableview: UITableView!
    
    var list = ["Car","Small Van",
                "Medium Van",
                "Large Van",
                "Luton Van",
                "Rubbish Removal Truck",
                "3.5 Ton Vehicle Recovery Truck",
                "7.5 Ton Vehicle Recovery Truck",
                "7.5 Ton Truck",
                "Container Truck",
                "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sign Up"
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundView = nil
        tableview.backgroundColor = UIColor.clear
        self.innerVehiclesListView.layer.cornerRadius = 10
    }
    
    
    @IBAction private func btnCross_Pressed(_ sender : UIButton) {
        vehiclesListView.isHidden = true
    }
    
    @IBAction private func btnShowPop(_ sender : UIButton) {
        vehiclesListView.isHidden = false
    }
    
    @IBAction func back_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - Select Vehicle Drop Down
    /***************************************************************/
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == van_type {
            
            self.van_type.rightImage = UIImage(named: "ArrowUp")
            self.view.endEditing(true)
        }
        view.endEditing(true)
        
    }
    
    //MARK: - Address for UITEXTFIELD
    /***************************************************************/
    
    @IBAction func address_btn(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        if #available(iOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark   {
                // self.traitCollection.userInterfaceStyle == .dark
                autocompleteController.primaryTextColor = UIColor.white
                autocompleteController.secondaryTextColor = UIColor.lightGray
                autocompleteController.tableCellSeparatorColor = UIColor.lightGray
                autocompleteController.tableCellBackgroundColor = UIColor.darkGray
            } else {
                autocompleteController.primaryTextColor = UIColor.black
                autocompleteController.secondaryTextColor = UIColor.lightGray
                autocompleteController.tableCellSeparatorColor = UIColor.lightGray
                autocompleteController.tableCellBackgroundColor = UIColor.white
            }
        }
        autocompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        filter.country = "UK"
        
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phone_no {
            guard let textFieldText = phone_no.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 11
            
        }else{
            
            guard let textFieldText = vehicle_reg_no.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 7
            
        }
    }
    
    
    @IBAction func register_now_btn(_ sender: Any) {
        
        if fullName.text == "" {
            //  SVProgressHUD.showError(withStatus: "Please Enter Correct email Address")
            
            fullName.attributedPlaceholder = NSAttributedString(string: "Please enter full name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
        }
        if  email_address.text == "" {
            //  SVProgressHUD.showError(withStatus: "Please Enter Correct email Address")
            
            email_address.attributedPlaceholder = NSAttributedString(string: "Please enter full email address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
        }
        if self.phone_no.text == "" || phone_no.text?.count != 11 || (self.phone_no.text?.hasPrefix("0")) != true {
            
            phone_no.attributedPlaceholder = NSAttributedString(string: "Please enter 11 digit number start with 0 ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
            //           SVProgressHUD.showError(withStatus: "Please enter 11 digit number start with 0 ")
            
        }
        if self.address.text == "" {
            address.attributedPlaceholder = NSAttributedString(string: "Please Enter Your Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            //  SVProgressHUD.showError(withStatus: "Please Enter Address ")
        }
        if self.van_type.text == "" {
            van_type.attributedPlaceholder = NSAttributedString(string: "Enter Van Type", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            // SVProgressHUD.showError(withStatus: "Please Enter Van Type ")
        }
        if self.vehicle_reg_no.text == "" {
            vehicle_reg_no.attributedPlaceholder = NSAttributedString(string: "Enter Vehicle Reg.No", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            // SVProgressHUD.showError(withStatus: "Please Enter Vehicle Reg Number ")
        }
        if fullName.text != "" && email_address.text != "" && phone_no.text != "" && address.text != "" && van_type.text != "" && vehicle_reg_no.text != "" {
            registerTransporter()
        }
        
    }
    
    //register function
    func registerTransporter() {
        
        
        //                parameters = ["tname" : self.fullName.text!, "temail" : self.email_address.text!, "tphone" : self.phone_no.text!, "taddress" : self.address.text!, "vantype" : self.van_type.text!, "registration-number" : self.vehicle_reg_no.text!, "cmb_id" : cmb_id, "cmd_id" : cmd_id, "car_model_manual" : self.enterCarModel.text ?? ""]
        //
    }
    
    @available(iOS 13.0, *)
    @IBAction func login_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewControllerPk") as! LoginViewControllerPk
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension RegisterViewControllerPk: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(String(describing: place.name))")
        dismiss(animated: true, completion: nil)
        self.address.text = place.formattedAddress
        
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//MARK: UITableViewDelegate
extension RegisterViewControllerPk: UITableViewDataSource , UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobNatureCell", for: indexPath) as? JobNatureCell
        cell?.layer.cornerRadius = 10
        cell?.backgroundColor = UIColor.clear
        cell?.backgroundView = nil
        cell?.lblJobNature.text = self.list[indexPath.row]
        if indexPath.row == 10 {
            cell?.bottomLineView.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedValue = self.list[indexPath.row]
        self.van_type.text = selectedValue
        vehiclesListView.isHidden = true
        
    }
    
}

