//
//  ShowRouteInvoiceViewController.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 05/01/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import QuickLook
import MessageUI


class ShowRouteInvoiceViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var invoiceNoLabel: UILabel!
    @IBOutlet weak var invoiceNoLabel2: UILabel!
    @IBOutlet weak var issuedDate: UILabel!
    @IBOutlet weak var issuedDate2: UILabel!
    @IBOutlet weak var transportPartner: UILabel!
    @IBOutlet weak var transportPartner2: UILabel!
    @IBOutlet weak var routeId: UILabel!
    @IBOutlet weak var routeId2: UILabel!
    @IBOutlet weak var transporterShare: UILabel!
    @IBOutlet weak var transporterShare2: UILabel!
    @IBOutlet weak var cashCollected: UILabel!
    @IBOutlet weak var cashCollected2: UILabel!
    @IBOutlet weak var outstanding: UILabel!
    @IBOutlet weak var outstanding2: UILabel!
    @IBOutlet weak var downloadInvoice: UIButton!
    
    @IBOutlet var popupView: UIView!
    
    let year = Calendar.current.component(.year, from: Date())
    let pdfUrl = main_URL+"user/userdownloadinvoice/"
    var finalURL = ""
    var paymentID = ""
    var invoiceNo = ""
    
    @IBOutlet var phoneTab: UITapGestureRecognizer!
    
//    @IBOutlet weak var callpopup_innerView: UIView!
//    @IBOutlet weak var emial_innerView: UIView!
//    @IBOutlet weak var search_innerView: UIView!
    
    var phoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invoice"

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
                    self.phoneNumber = jsonData[0]["phone_w_code"].stringValue
                }else{
//                    showAlert(title: "", message: response.result.error?.localizedDescription ?? "")
                }
            }
        }
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
        if let url = URL(string: "tel://\(020850570111)"), UIApplication.shared.canOpenURL(url) {
                  if #available(iOS 10, *) {
                      UIApplication.shared.open(url)
                  } else {
                      UIApplication.shared.openURL(url)
                  }
              }
    }
    @IBAction func SearchLocation_action(_ sender: Any) {
        let url = URL(string: "http://maps.apple.com/maps?saddr=&daddr=\(51.5681498),\(-0.2397992)")
        UIApplication.shared.open(url!)
    }

    @IBAction func back_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    func showInvoice() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if payment_id != nil && user_id != nil {
            let showInvoice_URL = main_URL+"api/trsnsporterViewInvoiceRouteDetail"
            let parameters : Parameters = ["payment_id" : payment_id!, "user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(showInvoice_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("show Route Invoice booked jsonData is \(jsonData)")
                        let jobID = jsonData[0]["payment_id"].stringValue
                        self.paymentID = jsonData[0]["payment_id"].stringValue
                        self.finalURL = self.pdfUrl+jobID
                        let job_id = "LOADX"+String(self.year)+"JI"+jobID
                        self.invoiceNoLabel.text = job_id
                        self.invoiceNoLabel2.text = job_id
                        self.invoiceNo = job_id
                        
                        self.transportPartner.text = jsonData[0]["transporter_partner"].stringValue.capitalized
                        self.transportPartner2.text = jsonData[0]["transporter_partner"].stringValue.capitalized
                        
                        self.routeId.text = "LR00\(jsonData[0]["route_id"].stringValue)"
                        self.routeId2.text = "LR00\(jsonData[0]["route_id"].stringValue)"

                        let share = Double(jsonData[0]["lr_transporter_share"].stringValue)
                        self.transporterShare.text = "£"+String(format: "%.2f", (share ?? 0.00))
                        self.transporterShare2.text = "£"+String(format: "%.2f", (share ?? 0.00))
                        let totalCashCollect = Double(jsonData[0]["total_cash_collect"].stringValue)
                        self.cashCollected.text = "£"+String(format: "%.2f", (totalCashCollect ?? 0.00))
                        self.cashCollected2.text = "£"+String(format: "%.2f", (totalCashCollect ?? 0.00))
                        let outstandingAmount = Double(jsonData[0]["outstanding"].stringValue)
                        self.outstanding.text = "£"+String(format: "%.2f", (outstandingAmount ?? 0.00))
                        self.outstanding2.text = "£"+String(format: "%.2f", (outstandingAmount ?? 0.00))
                                                
                        let date = jsonData[0]["pay_date"].stringValue
                        let stringDate = String(date.prefix(10))
                        self.issuedDate.text = self.convertDateFormater(stringDate)
                        self.issuedDate2.text = self.convertDateFormater(stringDate)
                        
                    } else {
                        SVProgressHUD.dismiss()
                        self.present(showAlert(title: "Error", message: response.error?.localizedDescription ?? ""), animated: true, completion: nil)
                    }
                }
            } else {
                SVProgressHUD.dismiss()
                self.present(showAlert(title: "", message: "No internet connection"), animated: true, completion: nil)
            }
        } else {
            SVProgressHUD.dismiss()
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
        SVProgressHUD.show(withStatus: "Downloading...")
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

extension ShowRouteInvoiceViewController : QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
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
        self.downloadInvoice.isHidden = false
    }
    
    
}
