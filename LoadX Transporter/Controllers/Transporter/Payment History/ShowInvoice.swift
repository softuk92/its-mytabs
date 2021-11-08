//
//  ShowInvoice.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/12/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import QuickLook

class ShowInvoice: UIViewController {

    @IBOutlet var parentView: UIView!
    @IBOutlet weak var invoice_no: UILabel!
    @IBOutlet weak var invoice_lbl: UILabel!
    @IBOutlet weak var invoice_lbl2: UILabel!
    @IBOutlet weak var invoice_no2: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var issueDate_lbl: UILabel!
    @IBOutlet weak var issueDate_lbl2: UILabel!
    @IBOutlet weak var date2: UILabel!
    @IBOutlet weak var transporter_partner: UILabel!
    @IBOutlet weak var transporter_lbl: UILabel!
    @IBOutlet weak var transporter_lbl2: UILabel!
    @IBOutlet weak var transporter_partner2: UILabel!
    @IBOutlet weak var customer_lbl: UILabel!
    @IBOutlet weak var customer_lbl2: UILabel!
    @IBOutlet weak var customer_name: UILabel!
    @IBOutlet weak var customer_name2: UILabel!
    @IBOutlet weak var job_id_label: UILabel!
    @IBOutlet weak var jobId_lbl2: UILabel!
    @IBOutlet weak var job_id_lbl: UILabel!
    @IBOutlet weak var job_id_label2: UILabel!
    @IBOutlet weak var current_bid: UILabel!
    @IBOutlet weak var current_bid2: UILabel!
    @IBOutlet weak var bidPrice_lbl: UILabel!
    @IBOutlet weak var bidPrice_lbl2: UILabel!
    @IBOutlet weak var ctsCharge_lbl: UILabel!
    @IBOutlet weak var cts_charges: UILabel!
    @IBOutlet weak var ctsCharges_lbl2: UILabel!
    @IBOutlet weak var cts_charges2: UILabel!
    @IBOutlet weak var remainingAmount_lbl: UILabel!
    @IBOutlet weak var remainingAmount_lbl2: UILabel!
    @IBOutlet weak var remaining_amount: UILabel!
    @IBOutlet weak var remaining_amount2: UILabel!
    @IBOutlet weak var received_amount: UILabel!
    @IBOutlet weak var recived_lbl: UILabel!
    @IBOutlet weak var recived_lbl2: UILabel!
    @IBOutlet weak var received_amount2: UILabel!
    @IBOutlet weak var invoiceOutlet: UIButton!
    @IBOutlet var popupView: UIView!
    @IBOutlet weak var cz_price_lbl: UILabel!
    @IBOutlet weak var detail_view: UIView!
    @IBOutlet weak var transporter_view: UIView!
    @IBOutlet weak var customer_view: UIView!
    @IBOutlet weak var detial_View2: UIView!
    @IBOutlet weak var transporter_view2: UIView!
    @IBOutlet weak var customer_view2: UIView!
    
    var switchCheck = UserDefaults.standard.bool(forKey: "mySwitch")
    
        
    let year = Calendar.current.component(.year, from: Date())
    var roundedPrice: Double = 0.0
    
    let pdfUrl = main_URL+"user/userdownloadinvoice/"
    var finalURL = ""
    var paymentID = ""
    var invoiceNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invoice"
        showInvoice()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        darkMood()
    }
    
    func darkMood(){
        if switchCheck == true {
            parentView.backgroundColor = UIColor.darkGray
            popupView.backgroundColor = UIColor.darkGray
            transporter_view.backgroundColor = UIColor(hexString: "252A2D")
            customer_view.backgroundColor = UIColor(hexString: "252A2D")
            transporter_view2.backgroundColor = UIColor(hexString: "252A2D")
            customer_view2.backgroundColor = UIColor(hexString: "252A2D")
            invoice_lbl.textColor = UIColor.white
            invoice_no.textColor = UIColor.white
            invoice_no2.textColor = UIColor.white
            invoice_lbl2.textColor = UIColor.white
            issueDate_lbl.textColor = UIColor.white
            issueDate_lbl2.textColor = UIColor.white
            date.textColor = UIColor.white
            date2.textColor = UIColor.white
            
            transporter_lbl.textColor = UIColor.white
            transporter_lbl2.textColor = UIColor.white
            transporter_partner.textColor = UIColor.white
            transporter_partner2.textColor = UIColor.white
            customer_lbl.textColor = UIColor.white
            customer_lbl2.textColor = UIColor.white
            customer_name.textColor = UIColor.white
            customer_name2.textColor = UIColor.white
            
            jobId_lbl2.textColor = UIColor.white
            job_id_lbl.textColor = UIColor.white
            job_id_label.textColor = UIColor.white
            job_id_label2.textColor = UIColor.white
            bidPrice_lbl.textColor = UIColor.white
            bidPrice_lbl2.textColor = UIColor.white
            current_bid.textColor = UIColor.white
            current_bid2.textColor = UIColor.white
                     
            cts_charges.textColor = UIColor.white
            cts_charges2.textColor = UIColor.white
            ctsCharge_lbl.textColor = UIColor.white
            ctsCharges_lbl2.textColor = UIColor.white
            remaining_amount.textColor = UIColor.white
            remaining_amount2.textColor = UIColor.white
            remainingAmount_lbl.textColor = UIColor.white
            remainingAmount_lbl2.textColor = UIColor.white
            
            recived_lbl.textColor = UIColor.white
            recived_lbl2.textColor = UIColor.white
            received_amount.textColor = UIColor.white
            received_amount2.textColor = UIColor.white
            cz_price_lbl.textColor = UIColor.white
            
            
            invoiceOutlet.setBackgroundImage(UIImage(named: "darkMood_yellowBtn"), for: .normal)
            invoiceOutlet.setTitleColor(.white, for: .normal)
            
        }else{
            
        }
    }
    
    func showInvoice() {
        SVProgressHUD.show(withStatus: "Getting details...")
        if payment_id != nil && user_id != nil {
            let endPointUrl = user_type == TransportationCompany ? "api/invoiceDetailTC" : "api/trsnsporterViewInvoiceDetail"
            let showInvoice_URL = main_URL+endPointUrl
            let parameters : Parameters = user_type == TransportationCompany ? ["payment_id" : payment_id!, "transportation_id" : user_id!] : ["payment_id" : payment_id!, "user_id" : user_id!]
            if Connectivity.isConnectedToInternet() {
                Alamofire.request(showInvoice_URL, method : .post, parameters : parameters).responseJSON {
                    response in
                    if response.result.isSuccess {
                        SVProgressHUD.dismiss()
                        
                        let jsonData : JSON = JSON(response.result.value!)
                        print("show Invoice jsonData is \(jsonData)")
                        let jobID = jsonData[0]["payment_id"].stringValue
                        self.paymentID = jsonData[0]["payment_id"].stringValue
                        self.finalURL = self.pdfUrl+jobID
                        
                        let job_id = "LOADX"+String(self.year)+"JI"+jobID
                        self.invoice_no.text = job_id
                        self.invoice_no2.text = job_id
                        self.invoiceNo = job_id
                        let jobID2 = jsonData[0]["del_id"].stringValue
//                        let job_id2 = "LOADX"+String(self.year)+"J"+jobID2
                        let job_id2 = AppUtility.shared.getLoadXJobID(id: jobID2)
                        self.job_id_label.text = job_id2
                        self.job_id_label2.text = job_id2
                        
                        if user_name != nil {
                        self.transporter_partner.text = user_name?.capitalized
                            self.transporter_partner2.text = user_name?.capitalized
                        }
                        let cz_value = jsonData[0]["is_cz"].stringValue
                        if cz_value == "1"{
                            self.cz_price_lbl.isHidden = false
                        }else{
                            self.cz_price_lbl.isHidden = true
                        }
                        let customerName = jsonData[0]["user_name"].stringValue
                        self.customer_name.text = customerName.capitalized
                        self.customer_name2.text = customerName.capitalized

                        self.current_bid.text = "£"+jsonData[0]["current_bid"].stringValue
                        self.current_bid2.text = "£"+jsonData[0]["current_bid"].stringValue

                        let currentBid = jsonData[0]["current_bid"].stringValue
                        let x =  UserDefaults.standard.string(forKey: "initial_deposite_value") ?? "25"
                        let doubleValue = Double(x)
                        let resultInitialPrice = Double(currentBid)! * Double(doubleValue!/100)
//                        let resultInitialPrice = Double(currentBid)! * Double(0.25)
                        self.roundedPrice = Double(resultInitialPrice).rounded(toPlaces: 2)
                        self.cts_charges.text = "£"+String(self.roundedPrice)
                        self.cts_charges2.text = "£"+String(self.roundedPrice)
                        
                        let resultRemaining = Double(currentBid)! - self.roundedPrice
                        self.remaining_amount.text = "£"+String(resultRemaining)
                        self.remaining_amount2.text = "£"+String(resultRemaining)
                        self.received_amount.text = "£"+String(resultRemaining)
                        self.received_amount2.text = "£"+String(resultRemaining)
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
        SVProgressHUD.show(withStatus: "Downloading...")
//        invoiceOutlet.isHidden = true
        createPdfFromView(aView: self.popupView, saveToDocumentsWithFileName: "LoadX Invoice "+invoiceNo+".pdf")
    }
   /* @IBAction func callUs(_ sender: UIButton) {
           if let url = URL(string: "tel://\(self.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10, *) {
                   UIApplication.shared.open(url)
               } else {
                   UIApplication.shared.openURL(url)
               }
           }
           
       }
       
       @IBAction func openEmail(_ sender: Any) {
           
           let email = "info@loadx.co.uk"
           if let url = URL(string: "mailto:\(email)") {
               if #available(iOS 10.0, *) {
                   UIApplication.shared.open(url)
               } else {
                   UIApplication.shared.openURL(url)
               }
           }
       }*/
    
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

extension ShowInvoice : QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
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
    
    
}

