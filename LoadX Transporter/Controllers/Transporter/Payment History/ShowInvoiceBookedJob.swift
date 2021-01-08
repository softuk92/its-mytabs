 //
//  ShowInvoiceBookedJob.swift
//  CTS Move Transporter
//
//  Created by Fahad Baig on 27/05/2019.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import QuickLook
import MessageUI


class ShowInvoiceBookedJob: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var invoice_lbl: UILabel!
    @IBOutlet weak var invoice_lbl2: UILabel!
    @IBOutlet weak var invoice_no: UILabel!
    @IBOutlet weak var invoice_no2: UILabel!
    @IBOutlet weak var issueDate_lbl: UILabel!
    @IBOutlet weak var issueDate_lbl2: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var transporter_view: UIView!
    @IBOutlet weak var transporter_view2: UIView!
    @IBOutlet weak var customer_view: UIView!
    @IBOutlet weak var customer_view2: UIView!
    @IBOutlet weak var transporter_lbl: UILabel!
    @IBOutlet weak var transporter_partner: UILabel!
    @IBOutlet weak var transporter_partner2: UILabel!
    @IBOutlet weak var customer_lbl: UILabel!
    @IBOutlet weak var customer_name: UILabel!
    @IBOutlet weak var customer_name2: UILabel!
    @IBOutlet weak var detial_view: UIView!
    @IBOutlet weak var detial_view2: UIView!
    
    @IBOutlet var email_popup_view: UIView!
    @IBOutlet var phone_popupView: UIView!
    @IBOutlet var location_popupView: UIView!
    
    @IBOutlet weak var customer_lbl2: UILabel!
    @IBOutlet weak var transporter_lbl2: UILabel!
    @IBOutlet weak var jobId_lbl2: UILabel!
    @IBOutlet weak var jobId_lbl: UILabel!
    @IBOutlet weak var jobPrice_lbl2: UILabel!
    @IBOutlet weak var jobprice_lbl: UILabel!
    @IBOutlet weak var job_id_label: UILabel!
    @IBOutlet weak var job_id_label2: UILabel!
    @IBOutlet weak var current_bid: UILabel!
    @IBOutlet weak var current_bid2: UILabel!
    
    @IBOutlet weak var recived_lbl2: UILabel!
    @IBOutlet weak var recived_lbl: UILabel!
    @IBOutlet weak var received_amount: UILabel!
    @IBOutlet weak var received_amount2: UILabel!
    
    @IBOutlet weak var invoiceOutlet: UIButton!
    @IBOutlet var popupView: UIView!
    
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
       
       
    
    let year = Calendar.current.component(.year, from: Date())
    var roundedPrice: Double = 0.0
    let pdfUrl = main_URL+"user/userdownloadinvoice/"
    var finalURL = ""
    var paymentID = ""
    var invoiceNo = ""
    
    @IBOutlet var phoneTab: UITapGestureRecognizer!
    @IBOutlet weak var cz_priceLbl: UILabel!
    @IBOutlet weak var cz_priceLbl2: UILabel!
    
    @IBOutlet weak var callpopup_innerView: UIView!
    @IBOutlet weak var emial_innerView: UIView!
    @IBOutlet weak var search_innerView: UIView!
    
    var phoneNumber: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invoice"
        self.customer_lbl.text = "Billed To:"
        self.callpopup_innerView.clipsToBounds = true
        self.callpopup_innerView.layer.cornerRadius = 18
        self.callpopup_innerView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        self.emial_innerView.clipsToBounds = true
        self.emial_innerView.layer.cornerRadius = 18
        self.emial_innerView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        self.search_innerView.clipsToBounds = true
        self.search_innerView.layer.cornerRadius = 18
        self.search_innerView.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        
        showInvoice()
        get_contact_no()
     
    }
    
    func get_contact_no(){
        SVProgressHUD.show(withStatus: "Please wait...")
        let url = main_URL+"api/get_phone_no"
        
        if Connectivity.isConnectedToInternet() {
            Alamofire.request(url, method : .get, parameters : nil).responseJSON {
                response in
                if  response.result.isSuccess {
                    SVProgressHUD.dismiss()
                    let jsonData : JSON = JSON(response.result.value!)
                    print("Contact Number is :.......\(jsonData)")
                    
                    let show_phone_num = jsonData[0]["phone_no"].string
                    print("this is phone number \(show_phone_num)")
                    self.phoneNumber = jsonData[0]["phone_w_code"].string!
                    
                    print("this is phone number with code \(self.phoneNumber)")
                    
                }else{
                    let alert = UIAlertController(title: "Error", message: "Contact Number Api not working", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "You are not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func location_btn_action(_ sender: Any) {

                UIView.animate(withDuration: 0.3, animations: {
    
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.parentView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(blurEffectView)
//        self.blurView = blurEffectView
//
                    self.parentView.alpha = 0.3
                                              
                    self.location_popupView.layer.cornerRadius = 18
                     //            self.tableView.alpha = 0.5
                    self.view.addSubview(self.location_popupView)
                    self.location_popupView.center = self.view.center
                      })
    }
    @IBAction func phone_btn_action(_ sender: Any) {
              UIView.animate(withDuration: 0.3, animations: {
        
//               self.parentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
                                         
                         self.parentView.alpha = 0.3
                self.phone_popupView.layer.cornerRadius = 18
                         //            self.tableView.alpha = 0.5
                        self.view.addSubview(self.phone_popupView)
                        self.phone_popupView.center = self.view.center
                          })
    }
    
    @IBAction func email_action(_ sender: Any) {
              UIView.animate(withDuration: 0.3, animations: {
//            self.parentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
                self.parentView.alpha = 0.3
                self.email_popup_view.layer.cornerRadius = 18
                         //            self.tableView.alpha = 0.5
                self.view.addSubview(self.email_popup_view)
                self.email_popup_view.center = self.view.center
            })
    }
   
    
    @IBAction func email_btn_action(_ sender: Any) {
//       if not working use this link https://stackoverflow.com/questions/25981422/how-to-open-mail-app-from-swift
        
//        let email = "info@loadx.co.uk"
//        if let url = URL(string: "mailto:\(email)") {
//          if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url)
//          } else {
//            UIApplication.shared.openURL(url)
//          }
//        }
        sendEmail()
    }
    
    func sendEmail() {
      if MFMailComposeViewController.canSendMail() {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["info@loadx.co.uk"])
        mail.setMessageBody("<p>If you have any query please tell us</p>", isHTML: true)

        present(mail, animated: true)
      } else {
        // show failure alert
      }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
              case MFMailComposeResult.cancelled.rawValue:
                  print("Cancelled")
              case MFMailComposeResult.saved.rawValue:
                  print("Saved")
              case MFMailComposeResult.sent.rawValue:
                  print("Sent")
              case MFMailComposeResult.failed.rawValue:
                  print("Error: \(String(describing: error?.localizedDescription))")
              default:
                  break
              }
      controller.dismiss(animated: true)
    }
    
    @IBAction func call_action(_ sender: Any) {
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
                  if #available(iOS 10, *) {
                      UIApplication.shared.open(url)
                  } else {
                      UIApplication.shared.openURL(url)
                  }
              }
    }
    @IBAction func SearchLocation_action(_ sender: Any) {
//    if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(51.5681498),\(-0.2397992)&directionsmode=driving") {
//        UIApplication.shared.open(url, options: [:])
//    }
        
//        let url = "http://maps.apple.com/maps?saddr=\(51.5681498),\(-0.2397992)"
//        UIApplication.shared.openURL(URL(string:url)!)
        let url = URL(string: "http://maps.apple.com/maps?saddr=&daddr=\(51.5681498),\(-0.2397992)")
        UIApplication.shared.open(url!)
    }
    
    @IBAction func closeBtn_action(_ sender: Any) {
//         self.parentView.backgroundColor = UIColor.white.withAlphaComponent(1)
                         self.parentView.alpha = 1
        self.phone_popupView.removeFromSuperview()
        self.email_popup_view.removeFromSuperview()
        self.location_popupView.removeFromSuperview()
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        
    }
    @IBAction func back_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    func showInvoice() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if payment_id != nil && user_id != nil {
            let showInvoice_URL = main_URL+"api/trsnsporterViewInvoiceDetail"
            let parameters : Parameters = ["payment_id" : payment_id!, "user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(showInvoice_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("show Invoice booked jsonData is \(jsonData)")
                        let jobID = jsonData[0]["payment_id"].stringValue
                        self.paymentID = jsonData[0]["payment_id"].stringValue
                        self.finalURL = self.pdfUrl+jobID
                        let job_id = "LOADX"+String(self.year)+"JI"+jobID
//                        self.invoice_no.text = job_id
//                        self.invoice_no2.text = job_id
                        self.invoiceNo = job_id
                        let jobID2 = jsonData[0]["del_id"].stringValue
                        let job_id2 = "LOADX"+String(self.year)+"J"+jobID2
                        self.job_id_label.text = job_id2
                        self.job_id_label2.text = job_id2
                        self.invoice_no.text = job_id
                        self.invoice_no2.text = job_id
                        if user_name != nil {
                        //    self.transporter_partner.text = user_name?.capitalized
//                            self.transporter_partner2.text = user_name?.capitalized
                        }
                      
                        let cz_value = jsonData[0]["is_cz"].stringValue
                        if cz_value == "1" {
                            self.cz_priceLbl.isHidden = false
                            self.cz_priceLbl2.isHidden = false
                        }else{
                            self.cz_priceLbl.isHidden = true
                            self.cz_priceLbl2.isHidden = true
                        }
                        
                        let customerName = jsonData[0]["user_name"].stringValue
                        self.customer_name.text = customerName.capitalized
//                        customerName.capitalized
                        self.customer_name2.text = user_name
//                            customerName.capitalized
                        self.current_bid.text = "£"+jsonData[0]["current_bid"].stringValue
                        self.current_bid2.text = "£"+jsonData[0]["current_bid"].stringValue
                        let currentBid = jsonData[0]["current_bid"].stringValue
                        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
                        let doubleValue = Double(x)
                        let finalPrice = getDoubleValue(currentBid: Double(currentBid) ?? 0.0, doubleValue: doubleValue ?? 0.0)
                        self.current_bid.text = "£"+finalPrice
                        self.current_bid2.text = "£"+finalPrice
                        self.received_amount.text = "£"+finalPrice
                        self.received_amount2.text = "£"+finalPrice
                        let date = jsonData[0]["pay_date"].stringValue
                        let stringDate = String(date.prefix(10))
                        
                        let convertedDate = self.convertDateFormater(stringDate)
                        self.date.text = convertedDate
                        self.date2.text = convertedDate
                    } else {
                        SVProgressHUD.dismiss()
                        let alert = UIAlertController(title: "Alert", message: response.result.error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
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
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        return  dateFormatter.string(from: date!)
        
    }

    @IBAction func downloadPDF(_ sender: Any) {
//        openPDF()
        SVProgressHUD.show(withStatus: "Downloading...")
//        invoiceOutlet.isHidden = true
        createPdfFromView(aView: self.popupView, saveToDocumentsWithFileName: "LoadX Invoice "+invoiceNo+".pdf")
    
    }
    
    func createPdfFromView(aView: UIView, saveToDocumentsWithFileName fileName: String)
    {
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
        UIGraphicsBeginPDFPage()
        
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
        
        aView.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsFileName = documentDirectories + "/" + fileName
            debugPrint(documentsFileName)
            pdfData.write(toFile: documentsFileName, atomically: true)
            SVProgressHUD.dismiss()
            self.openQlPreview()
        }
    }
    
    func openPDF() {
        if finalURL != "" {
            print("final url is \(finalURL)")
            let url2 = URL(string: finalURL)
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent("file.pdf")
                return (documentsURL, [.removePreviousFile])
            }
            
            Alamofire.download(url2!, to: destination)
                .downloadProgress(closure: { (progress) in
                    SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Downloading file...")
                })
                .responseData { response in
                    if let destinationUrl = response.destinationURL {
                        
                        print("destinationUrl \(destinationUrl.absoluteURL)")
                        SVProgressHUD.dismiss()
                        
                        self.openQlPreview()
                    }
                    
            }
        }
    }
    
    func openQlPreview() {
        let previoew = QLPreviewController.init()
        previoew.dataSource = self
        previoew.delegate = self
        self.present(previoew, animated: true, completion: nil)
    }
    
}

extension ShowInvoiceBookedJob : QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let documentsURL = try! FileManager().url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true)
        
        let path = documentsURL.appendingPathComponent("LoadX Invoice "+invoiceNo+".pdf")
        return path as QLPreviewItem
    }
    
    func previewController(_ controller: QLPreviewController, shouldOpen url: URL, for item: QLPreviewItem) -> Bool {
        return true
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        self.invoiceOutlet.isHidden = false
    }
    
    
}
