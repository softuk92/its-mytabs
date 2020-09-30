//
//  JobsInProgress.swift
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

var businessJobs : Bool?

class JobsInProgress: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var popupView: UIView!
//    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet var jobCancel_popview: UIView!
    @IBOutlet var jobComplete_popview: UIView!
    @IBOutlet weak var noJob_lbl: UILabel!
    @IBOutlet weak var book_job_lbl: UILabel!
    
    @IBOutlet weak var popup_iconView: UIView!
    @IBOutlet weak var Cancel_popup_iconView: UIView!
    
    
    var contact_person: String?
    var contact_no: String?
    var refference_no: String?
    
    let picker = UIDatePicker()
    lazy var jobsInProgressModel = [JobsInProgressModel]()
    var roundedPrice: Double = 0.0
    var refresher: UIRefreshControl!
    var bookedPrice : String?
    var imagePicker = UIImagePickerController()
    private var imagePicked = 0
    private var imageData1 : Data?
    var progressJobs = false
    var HEADER_HEIGHT = 60
    var menuShowing = false
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let year = Calendar.current.component(.year, from: Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.title = "Booked Jobs"+" ("+userInprogressJobs+")"
        self.popup_iconView.clipsToBounds = true
        self.popup_iconView.layer.cornerRadius = 18
        self.popup_iconView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        self.Cancel_popup_iconView.clipsToBounds = true
        self.Cancel_popup_iconView.layer.cornerRadius = 18
        self.Cancel_popup_iconView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        stackView.isHidden = true
//        searchBtn.isHidden = true
       
        getBookedJobs(url: "api/transporterInprogresJobs")
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
//        tableView.backgroundColor = UIColor.white
//        tableView.tableHeaderView = topView
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableHeaderView?.frame.size = CGSize(width: tableView.frame.width, height: CGFloat(HEADER_HEIGHT))
        
        tableView.register(UINib(nibName: "JobsInProgressCell", bundle: nil) , forCellReuseIdentifier: "jobsInProgress")
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refresher.addTarget(self, action: #selector(JobsInProgress.populate), for: UIControl.Event.valueChanged)
        tableView.addSubview(refresher)
        
        guard let bookJob = UserDefaults.standard.string(forKey: "Book_job") else { return }
        book_job_lbl.text = "(" + bookJob + ")"
    }
    
//    @IBAction func businessJobsBtn(_ sender: Any) {
//        if progressJobs == false {
//           businessJobsOutlet.setTitle("Booked Jobs ("+userInprogressJobs+")", for: .normal)
//           getBookedJobs(url: "api/transporterInprogresJobsBusiness")
//            self.title = "Business Jobs"+" ("+User_Inprogress_Jobs_Business+")"
//            progressJobs = true
//        } else {
//            businessJobsOutlet.setTitle("Business Jobs ("+User_Inprogress_Jobs_Business+")", for: .normal)
//            getBookedJobs(url: "api/transporterInprogresJobs")
//            self.title = "Booked Jobs"+" ("+userInprogressJobs+")"
//            progressJobs = false
//        }
//    }
    
    @objc func populate() {
        
        DispatchQueue.main.async {
//         if self.progressJobs == false {
//            } else {
//           self.getBookedJobs(url: "api/transporterInprogresJobsBusiness")
//            }
            self.getBookedJobs(url: "api/transporterInprogresJobs")
            self.refresher.endRefreshing()
            }
    }
  
    
    func getBookedJobs(url: String) {
        SVProgressHUD.show(withStatus: "Getting details...")
        if user_id != nil {
            let bookedJobs_URL = main_URL+url
            let parameters : Parameters = ["user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(bookedJobs_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("Jobs In Progress jsonData is \(jsonData)")
                        let result = jsonData[0]["result"].stringValue
//                        let message = jsonData[0]["message"].stringValue
                        self.jobsInProgressModel.removeAll()
                        if result == "0" {
                            self.tableView.backgroundView = nil
                            self.stackView.isHidden = false
//                            self.searchBtn.isHidden = false
                            self.tableView.reloadData()
                        } else {
                        let error = response.error
                        let data = response.data
                        if error == nil {
                            do {
                                self.jobsInProgressModel = try JSONDecoder().decode([JobsInProgressModel].self, from: data!)
                                SVProgressHUD.dismiss()
//                                print(self.jobsInProgressModel)

                                DispatchQueue.main.async {
//                                    self.tableView.backgroundView = UIImageView(image: UIImage(named: "background.png"))
                                    self.stackView.isHidden = true
//                                    self.searchBtn.isHidden = true
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
    
    //MARK: - UITABLEVIEW Delegate methods
       /***************************************************************/
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobsInProgressModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 0.2) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobsInProgress") as! JobsInProgressCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundView = nil
        cell.backgroundColor = nil
        
        let jobsInProgressRow = jobsInProgressModel[indexPath.row]
        
        cell.innerView.layer.cornerRadius = 10
        cell.jobCompleted_btn.layer.cornerRadius = 10
        cell.jobCompleted_btn.clipsToBounds = true
        cell.jobCompleted_btn.layer.maskedCorners = [ .layerMaxXMaxYCorner]
               
        cell.deletBtnOutlet.layer.cornerRadius = 10
        cell.deletBtnOutlet.clipsToBounds = true
        cell.deletBtnOutlet.layer.maskedCorners = [.layerMinXMaxYCorner]

        let switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
        
        let movingItem = jobsInProgressRow.moving_item
        cell.moving_item.text = movingItem.capitalized
        
        cell.pick_up.text = jobsInProgressRow.pu_house_no + " " + jobsInProgressRow.pick_up
        cell.drop_off.text = jobsInProgressRow.do_house_no + " " + jobsInProgressRow.drop_off
        
        let stringDate = jobsInProgressRow.date
        let convertedDate = self.convertDateFormatter(stringDate)
        cell.date.text = convertedDate
        let contactPerson = jobsInProgressRow.contact_person
//        cell.driver_name.setTitle(contactPerson.capitalized, for: .normal)
//        let driverEmail = jobsInProgressRow.contact_mail
        let driverPhone = jobsInProgressRow.contact_phone
//        if driverEmail != "" {
//            cell.driver_email.setTitle(driverEmail, for: .normal)
//        } else {
//            cell.driver_email.setTitle("N/A", for: .normal)
//        }
         /*   let is_cz_value = jobsInProgressRow.is_cz
            if is_cz_value == "1"{
                cell.cz_price_lbl.isHidden = false
                cell.sperate_line.isHidden = false
            }else{
                cell.cz_price_lbl.isHidden = true
                 cell.sperate_line.isHidden = true
            }*/
            
            let payment_type = jobsInProgressRow.payment_type
            if  payment_type == "full" {
                if switchCheck == true {
//                     cell.payment_method_Icon.image = UIImage(named: "bank_dark")
                    cell.payment_method_lbl.text = "Account Job"
                }else{
//                    cell.payment_method_Icon.image = UIImage(named: "bank")
                    cell.payment_method_lbl.text = "Account Job"
                }
            }else{
                if switchCheck == true {
//                    cell.payment_method_Icon.image = UIImage(named: "cashDark")
                     cell.payment_method_lbl.text = "Cash Job"
                }else{
//                    cell.payment_method_Icon.image = UIImage(named: "cash")
                    cell.payment_method_lbl.text = "Cash Job"
                }
        }
//            let payment_type1 = jobsInProgressRow.is_company_job
//                if  payment_type1 == "1" {
//                  if switchCheck == true {
////                    cell.payment_method_Icon.image = UIImage(named: "bank_dark")
//                    cell.payment_method_lbl.text = "Account Job"
//                }else{
////                    cell.payment_method_Icon.image = UIImage(named: "bank")
//                    cell.payment_method_lbl.text = "Account Job"
//                }
//            }else{
//                    if switchCheck == true {
////                        cell.payment_method_Icon.image = UIImage(named: "cashDark")
//                         cell.payment_method_lbl.text = "Cash Job"
//                    }else{
////                        cell.payment_method_Icon.image = UIImage(named: "cash")
//                        cell.payment_method_lbl.text = "Cash Job"
//                    }
//            }
        
        if driverPhone != "" {
//            cell.driver_phone.setTitle(driverPhone, for: .normal)
        } else {
//            cell.driver_phone.setTitle("N/A", for: .normal)
        }
        
        let is_companyJob = jobsInProgressRow.is_company_job
        
        if is_companyJob == "1" {
            cell.businessPatti.isHidden = false
            cell.widthBusiness.constant = 65
        } else {
            cell.businessPatti.isHidden = true
            cell.widthBusiness.constant = 0
        }
        
        let bookedJob_id = jobsInProgressRow.is_booked_job
        
        if bookedJob_id == "1" {
       /* cell.acceptedBidStack.isHidden = true
        cell.receivedAmountStack.isHidden = true
        cell.rightView.isHidden = true
        cell.leftView.isHidden = true
        cell.ctsChargesStack.isHidden = true
        cell.jobPriceStack.isHidden = false*/
        cell.deletBtnOutlet.isHidden = false
       
        let currentBid = jobsInProgressRow.current_bid
        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
        let doubleValue = Double(x)
//        let resultInitialPrice = Double(currentBid)! * Double(doubleValue!/100)
//        let resultInitialPrice = Double(currentBid)! * Double(0.25)
//        self.roundedPrice = Double(resultInitialPrice).rounded(toPlaces: 2)
//        let resultRemaining = Double(currentBid)! - self.roundedPrice
            cell.jobPrice.text = "£ "+"\(getDoubleValue(currentBid: Double(currentBid) ?? 0.0, doubleValue: doubleValue ?? 0.0))"
//        cell.trailingConstraint.constant = 60
        } else {
        cell.deletBtnOutlet.isHidden = true
      /*  cell.acceptedBidStack.isHidden = false
        cell.receivedAmountStack.isHidden = false
        cell.rightView.isHidden = false
        cell.leftView.isHidden = false
        cell.ctsChargesStack.isHidden = false
        cell.jobPriceStack.isHidden = true
        cell.trailingConstraint.constant = 10 */
        }
        
//        cell.price.text = "£"+jobsInProgressRow.current_bid
        let currentBid = jobsInProgressRow.current_bid
        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
        let doubleValue = Double(x)
        let resultInitialPrice = Double(currentBid)! * Double(doubleValue!/100)
//        let resultInitialPrice = Double(currentBid)! * Double(0.25)
        self.roundedPrice = Double(resultInitialPrice).rounded(toPlaces: 2)
//        cell.cts_charges.text = "£"+String(self.roundedPrice)
        
        let resultRemaining = Double(currentBid)! - self.roundedPrice
//        cell.remaining_amount.text = "£"+String(resultRemaining)
        
        cell.detailJobRow = { (selectedCell) in
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            protected = true
            let bookedJob_id = jobsInProgressRow.is_booked_job
            
            if bookedJob_id == "1" {
                bookedPriceBool = true
                let currentBid2 = jobsInProgressRow.current_bid
                let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
                let doubleValue = Double(x)
                let resultInitialPrice2 = Double(currentBid2)! * Double(doubleValue!/100)
//                let resultInitialPrice2 = Double(currentBid2)! * Double(0.25)
                self.roundedPrice = Double(resultInitialPrice2).rounded(toPlaces: 2)
                let resultRemaining2 = Double(currentBid2)! - self.roundedPrice
                self.bookedPrice = "£"+"\(resultRemaining2)"
                del_id = jobsInProgressRow.del_id
                let vc = self.sb.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
                vc.bookedJobPrice = self.bookedPrice
                vc.showHouseNumber = true
                self.navigationController?.pushViewController(vc, animated: true)
//                self.performSegue(withIdentifier: "detail", sender: self)
            } else {
                del_id = jobsInProgressRow.del_id
                let vc = self.sb.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
                vc.bookedJobPrice = self.bookedPrice
                vc.showHouseNumber = true
                self.navigationController?.pushViewController(vc, animated: true)
//                self.performSegue(withIdentifier: "detail", sender: self)
            }
        }
        
        cell.completeJobRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
           
            jb_id = self.jobsInProgressModel[indexPath.row].jb_id
            self.contact_person = self.jobsInProgressModel[indexPath.row].contact_person
            self.contact_no = self.jobsInProgressModel[indexPath.row].contact_phone
            self.refference_no = "LOADX"+String(self.year)+"J"+self.jobsInProgressModel[indexPath.row].del_id
            
            UIView.animate(withDuration: 0.3, animations: {
//                    self.jobComplete_popview.layer.borderColor = UIColor.gray.cgColor
//                    self.jobComplete_popview.layer.borderWidth = 1
                    self.jobComplete_popview.layer.cornerRadius = 18
                    self.tableView.alpha = 0.5
                    self.view.addSubview(self.jobComplete_popview)
                    self.jobComplete_popview.center = self.view.center
                      })
           
            }
        
        cell.deleteRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            jb_id = self.jobsInProgressModel[indexPath.row].jb_id
//            let refreshAlert = UIAlertController(title: "Confirm Cancel Job", message: "Are you sure you want to cancel this job?", preferredStyle: UIAlertController.Style.alert)
//
//            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
//                jb_id = self.jobsInProgressModel[indexPath.row].jb_id
//                self.deleteBtn()
//            }))
            
//            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
//                print("Handle Cancel Logic here")
//            }))
//
//            self.present(refreshAlert, animated: true, completion: nil)
             UIView.animate(withDuration: 0.3, animations: {
//                        self.jobCancel_popview.layer.borderColor = UIColor.gray.cgColor
//                        self.jobCancel_popview.layer.borderWidth = 1
                        self.jobCancel_popview.layer.cornerRadius = 18
                        self.tableView.alpha = 0.5
                        self.view.addSubview(self.jobCancel_popview)
                        self.jobCancel_popview.center = self.view.center
            })
        }
    
        
        cell.callRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            let callNumber = self.jobsInProgressModel[indexPath.row].contact_phone
            if callNumber != "" {
                if let url = URL(string: "tel://\(callNumber)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
        
        cell.emailRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            let email = self.jobsInProgressModel[indexPath.row].contact_mail
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
        cell.transporterProfileRow = {[weak self] (selectedCell) in
            guard let self = self else { return }
            let selectedIndex = self.tableView.indexPath(for: selectedCell)
            self.tableView.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
            transporter_id = self.jobsInProgressModel[indexPath.row].user_id
            self.performSegue(withIdentifier: "transporter", sender: self)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        protected = true
        
        let bookedJob_id = self.jobsInProgressModel[indexPath.row].is_booked_job
        
        if bookedJob_id == "1" {
            bookedPriceBool = true
            let currentBid2 = self.jobsInProgressModel[indexPath.row].current_bid
            let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
            let doubleValue = Double(x)
            let resultInitialPrice2 = Double(currentBid2)! * Double(doubleValue!/100)
//            let resultInitialPrice2 = Double(currentBid2)! * Double(0.25)
            self.roundedPrice = Double(resultInitialPrice2).rounded(toPlaces: 2)
            let resultRemaining2 = Double(currentBid2)! - self.roundedPrice
            self.bookedPrice = "£"+"\(resultRemaining2)"
            del_id = self.jobsInProgressModel[indexPath.row].del_id
//            self.performSegue(withIdentifier: "detail", sender: self)
            let vc = self.sb.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
               vc.bookedJobPrice = bookedPrice
            vc.showHouseNumber = true
        self.navigationController?.pushViewController(vc, animated: true)
        } else {
            del_id = self.jobsInProgressModel[indexPath.row].del_id
//            self.performSegue(withIdentifier: "detail", sender: self)
            let vc = self.sb.instantiateViewController(withIdentifier: "JobDetial_ViewController") as! JobDetial_ViewController
               vc.bookedJobPrice = bookedPrice
            vc.showHouseNumber = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func jocancel_noBtn_action(_ sender: Any) {
          self.jobCancel_popview.removeFromSuperview()
         self.tableView.alpha = 1
    }
    @IBAction func jobCancel_YesBtn(_ sender: Any) {
    
         let vc = self.sb.instantiateViewController(withIdentifier: "jobCancel_ViewController") as! jobCancel_ViewController
                  // self.deleteBtn()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func jobcomplete_YesBtn(_ sender: Any) {
//         self.performSegue(withIdentifier: "book", sender: self)
        self.jobComplete_popview.removeFromSuperview()
        self.tableView.alpha = 1
        let vc = self.sb.instantiateViewController(withIdentifier: "BookJobController") as! BookJobController
        vc.contact_no = contact_no
        vc.ref_no = refference_no
        vc.contactName = contact_person
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func jobComplete_noBtn(_ sender: Any) {
        self.jobComplete_popview.removeFromSuperview()
        self.tableView.alpha = 1
    }
    
    
    @IBOutlet weak var myImage1: UIImageView!
    @IBOutlet weak var receiverName: UITextField!
    @IBAction func selectImage(_ sender: UIButton) {
        imagePick(sender: sender.tag)
    }
    
    func imagePick(sender: Int) {
        let optionMenu = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        //2
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicked = sender
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera Not Available")
            }
        })
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicked = sender
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoAction)
        optionMenu.addAction(cancelAction)
        optionMenu.popoverPresentationController?.sourceView = self.view;
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 800, width: 1.0, height: 1.0)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let packedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if imagePicked == 1 {
            self.myImage1.image = packedImage
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func updateBtn(_ sender: Any) {
        completeJobData()
    }
    
    func completeJobData() {
        SVProgressHUD.show(withStatus: "Completing Job...")
        if user_id != nil && jb_id != nil {
            let updateBid_URL = main_URL+"api/transporterCompleteJobData"
            let parameters = ["jb_id" : jb_id!, "user_id" : user_id!, "receivername" : self.receiverName.text!]
            if imagePicked == 1 {
                var image1 = myImage1.image
                image1 = image1?.resizeWithWidth(width: 500)
                imageData1 = image1?.jpegData(compressionQuality: 0.2)
            }
            
            Alamofire.upload(multipartFormData: {
                (multipartFormData) in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
                if self.imagePicked == 1 {
                    multipartFormData.append(self.imageData1!, withName: "delprofimg", fileName: "swift_file1.jpeg", mimeType: "image/jpeg")
                }
            }, to:updateBid_URL)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
//                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        if response.result.value != nil {
//                            print(response.request!)  // original URL request
//                            print(response.response!) // URL response
//                            print(response.data!)     // server data
//                            print(response.result)   // result of response serialization
                            let jsonData : JSON = JSON(response.result.value!)
                            print("JSON: \(jsonData)")
                            let result = jsonData[0]["result"].stringValue
                            let message = jsonData[0]["message"].stringValue
                            SVProgressHUD.dismiss()
                            if result == "1" {
                                let vc = self.sb.instantiateViewController(withIdentifier: "completedJob") as! SuccessController
                            self.navigationController?.pushViewController(vc, animated: true)
                                
//                                self.performSegue(withIdentifier: "complete", sender: self)
                                
                            } else {
                                let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
                            SVProgressHUD.dismiss()
                            print("Error \(response.result.error!)")
                            let alert = UIAlertController(title: "Error", message: "Network Error", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print(encodingError)
                    SVProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Error!", message: "Connection error! Please check your internet connection", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            SVProgressHUD.dismiss()
            let alert = UIAlertController(title: "Alert!", message: "Please enter receiver name / upload proof image", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func crosssBtn(_ sender: Any) {
        popupView.removeFromSuperview()
        self.tableView.alpha = 1
    }

    func convertDateFormatter(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MMMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }
    
    //back function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if let vc = segue.destination as? JobDetailController {
            vc.bookedJobPrice = bookedPrice
        }
    }
}
