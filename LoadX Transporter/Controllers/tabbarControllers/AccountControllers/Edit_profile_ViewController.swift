//
//  Edit_profile_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 10/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import IBAnimatable
import DropDown
import GoogleMaps
import GooglePlaces

class Edit_profile_ViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var fullName_tf: AnimatableTextField!
    @IBOutlet weak var email_address_tf: AnimatableTextField!
    @IBOutlet weak var phoneNo_tf: AnimatableTextField!
    @IBOutlet weak var adress_tf: AnimatableTextField!
    @IBOutlet weak var van_type_tf: AnimatableTextField!
    @IBOutlet weak var vanRegNo_tf: AnimatableTextField!
    @IBOutlet weak var aboutMe: UITextView!
    
    @IBOutlet weak var vanType_tableView: UITableView!
    @IBOutlet weak var dropdown_popupView: UIView!
    
    @IBOutlet weak var vanTypeDropDown: UIView!
    let dropDown1 = DropDown()
    let list = ["Car","Small Van",
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
        profileDetail()
        aboutMe.layer.cornerRadius = 5
        aboutMe.layer.borderWidth = 1
        aboutMe.layer.borderColor = UIColor.black.cgColor
        vanType_tableView.delegate = self
        vanType_tableView.dataSource = self
        vanType_tableView.reloadData()
//        van_type_tf.delegate = self
//        dropDown1.anchorView = vanTypeDropDown
//        dropDown1.backgroundColor = UIColor.white
//        dropDown1.dataSource = list
//        if #available(iOS 13.0, *) {
//            if UITraitCollection.current.userInterfaceStyle == .dark  {
//                dropDown1.backgroundColor = UIColor.secondarySystemBackground
//                dropDown1.textColor = UIColor.label
//              }
//            } else {
//                         // Fallback on earlier versions
//            }
//
//        dropDown1.selectionAction = { [unowned self] (index: Int, item: String) in
//        print("Selected item: \(item) at index: \(index)")
//        self.van_type_tf.text = item
//        self.vanRegNo_tf.becomeFirstResponder()
//        dropDown1.bottomOffset = CGPoint(x: 0, y:(dropDown1.anchorView?.plainView.bounds.height)!)
               
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func btnCross_Pressed(_ sender : UIButton) {
    //        HomeViewController
            self.dropdown_popupView.isHidden = true

        }
        
        @IBAction private func btnShowPop(_ sender : UIButton) {
            //        HomeViewController
            self.dropdown_popupView.isHidden = false
            
        }
        
    
    @IBAction func back_action(_ sender: Any) {
       self.navigationController!.popViewController(animated: true)
    }
     
    @IBAction func updateBtn_action(_ sender: Any) {
        
        let isValidateName = validateName(name: fullName_tf.text!)
              
              let temp = self.email_address_tf.text!
              let x = isValidEmail1(testStr: temp)
              
                  if (isValidateName == false) {
//                      SVProgressHUD.showError(withStatus: "")
                      fullName_tf.attributedPlaceholder = NSAttributedString(string: "Please Enter Your Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                     
                  }else if  x == false {
//                  SVProgressHUD.showError(withStatus: "Please Enter Correct email Address")
                                 
                  email_address_tf.attributedPlaceholder = NSAttributedString(string: "Enter Full Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                  
              } else if self.phoneNo_tf.text == "" || phoneNo_tf.text?.count != 11 && (phoneNo_tf.text?.hasPrefix("0"))!{
                  phoneNo_tf.attributedPlaceholder = NSAttributedString(string: "Contact Phone No", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//                   SVProgressHUD.showError(withStatus: "Please Enter Contact Phone No")
              }else if self.adress_tf.text == "" {
                  adress_tf.attributedPlaceholder = NSAttributedString(string: "Please Enter Your Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//                   SVProgressHUD.showError(withStatus: "Please Enter Address ")
              }else if self.van_type_tf.text == "" {
                  van_type_tf.attributedPlaceholder = NSAttributedString(string: "Enter Van Type", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//                   SVProgressHUD.showError(withStatus: "Please Enter Van Type ")
              }else if self.vanRegNo_tf.text == "" {
                  vanRegNo_tf.attributedPlaceholder = NSAttributedString(string: "Enter Vehicle Reg. No", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//                   SVProgressHUD.showError(withStatus: "Please Enter Vehicle Reg Number ")
              }else{
                 updateprofileData()
              }

    }
    
    func updateprofileData() {
        SVProgressHUD.show(withStatus: "Getting details...")
        
        if self.fullName_tf.text != "" && self.phoneNo_tf.text != "" {
            let updateProfileData_URL = main_URL+"api/transporterUpdateProfileData"
            let parameters : Parameters = ["tname" : self.fullName_tf.text!, "tphone" : self.phoneNo_tf.text!, "taddress" : self.adress_tf.text!, "vantype" : self.van_type_tf.text!, "registration-number" : self.vanRegNo_tf.text!, "user_id" : user_id!, "aboutme" : ""]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(updateProfileData_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("update Profle Data jsonData is \(jsonData)")
                      let result = jsonData[0]["result"].stringValue
                        if result == "1" {
                            SVProgressHUD.showSuccess(withStatus: "Profile updated successfully.")
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
            let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: - Select Vehicle Drop Down
      /***************************************************************/
      
      func textFieldDidBeginEditing(_ textField: UITextField) {
          if textField == van_type_tf {
              dropDown1.show()
              self.view.endEditing(true)
          }
      }
    //MARK: - Pickuplocation for UITEXTFIELD
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
    //MARK: - validation of email and username
             /***************************************************************/
        
    public func validateName(name: String) ->Bool {
          // Length be 18 characters max and 3 characters minimum, you can always modify.
          let nameRegex = "^[A-Za-z]{3,25}$"
          let trimmedString = name.trimmingCharacters(in: .whitespaces)
          let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
          let isValidateName = validateName.evaluate(with: trimmedString)
          return isValidateName
       }
   func isValidEmail1(testStr:String) -> Bool {
           
   print("validate emilId: \(testStr)")
   let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
   let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
   let result = emailTest.evaluate(with: testStr)
   return result
   }
    
    
    func profileDetail() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let bookedJobs_URL = main_URL+"api/getTransporterProfileDetail"
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(bookedJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("transporter Profile jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
//            self.fullName.text = jsonData[0]["user_name"].stringValue
                       
                        if result != "0" {
                        
                        self.fullName_tf.text = jsonData[0]["user_name"].stringValue
                        self.email_address_tf.text = jsonData[0]["user_email"].stringValue
                        self.aboutMe.text = jsonData[0]["about_me"].stringValue
                        self.phoneNo_tf.text = jsonData[0]["user_phone"].stringValue
                        self.adress_tf.text = jsonData[0]["user_address"].stringValue
                        let vanType = jsonData[0]["van_type"].stringValue
                            if vanType != "" {
                                if vanType == "SWB Van" {
                                    self.van_type_tf.text = "Small Van"
                                } else if vanType == "MWB Van" {
                                    self.van_type_tf.text = "Medium Van"
                                } else if vanType == "LWB Van" {
                                    self.van_type_tf.text = "Large Van"
                                } else {
                                    self.van_type_tf.text = vanType
                                }
                            } else {
                                
                            }
                        self.vanRegNo_tf.text = jsonData[0]["truck_registration"].stringValue
                         
                    } else {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: "Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("Error \(response.result.error!)")
                    }
                }
             else {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
            }else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Error", message: "Internet connection is missing", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    }
}
//MARK: - GMSAutocomplete for Google Autocomplete
/***************************************************************/
extension Edit_profile_ViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        dismiss(animated: true, completion: nil)
        self.adress_tf.text = place.formattedAddress
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
extension Edit_profile_ViewController: UITableViewDataSource , UITableViewDelegate  {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "JobNatureCell", for: indexPath) as? JobNatureCell
            cell?.lblJobNature.text = self.list[indexPath.row]
            return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
            let selectedValue = self.list[indexPath.row]
            self.van_type_tf.text = selectedValue
            dropdown_popupView.isHidden = true
        
    }
}
