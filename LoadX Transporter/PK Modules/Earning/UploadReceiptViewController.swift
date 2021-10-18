//
//  UploadReceptViewController.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 02/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import Alamofire
import SVProgressHUD
import SwiftyJSON

class UploadReceiptViewController: UIViewController,StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = R.storyboard.earning()
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var accNo: UILabel!
    @IBOutlet weak var accHolder: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var receiptImage: UIImageView!
    @IBOutlet weak var uploadButtonView: UIView!
    @IBOutlet weak var submit: UIButton!
    
    var paymentsToPay = [PayToLoadXItme]()
    var dataSource: UploadReceipt?
    var imageSelector: ImageSelector!
	var paymentMethod = PaymentMethod.debitCard
    var amount: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSelector = ImageSelector()
        imageSelector.delegate = self
        shadowView.bottomShadow(color: UIColor.black)
        //uploadButtonView.clipsToBounds = true
        uploadButtonView.layer.cornerRadius = 10
//        uploadButtonView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        fetechData()
        if let amountP = amount {
            totalAmount.text = "Rs. "+amountP
        }
        submit.setTitle(string.submit, for: .normal)
    }
    
    
    
    func fetechData() {
        guard let id = user_id else {return}
        var checkBox = [String]()
        for model in paymentsToPay{
            let checkBoxx = "\(model.loadxShare)/\(model.delID)"
            checkBox.append(checkBoxx)
        }
        let params:Parameters = ["user_id":id,"pay_checkbox":"\(checkBox)"]

        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/uploadReceipt", parameters: params) {[weak self] data, json, error in
            guard let self = self else {return}
            SVProgressHUD.dismiss()
            if error == nil{
                if let json = json{
                    self.dataSource = UploadReceipt(json: json)
                    self.populateData()
                }
            }

            
        }
    }
    
    
    func populateData() {
        bankName.text = dataSource?.bankName.capitalized
        accNo.text = dataSource?.accNo
        accHolder.text = dataSource?.accHolder
        self.totalAmount.text = AppUtility.shared.currencySymbol+(dataSource?.totalAmountToPay.withCommas() ?? "")
    }
    
    @IBAction func didTapBack(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadTapped(sender: UIButton){
        uploadReceipt()
    }
    
    @IBAction func uploadReceipt(_ sender: Any) {
        imageSelector.showOptions(viewController: self)
    }
    
    func uploadReceipt() {
        guard let receiptImg = receiptImage.image, let userId = user_id else { return }
//        let jobIds = dataSource?.jobLists.map{$0.jobIDS} ?? []
        let parameters = user_type == TransportationCompany ? ["transportation_id" : userId, "send_req" : "1", "description" : self.messageTV.text!] : ["transporter_id" : userId, "send_req" : "1", "description" : self.messageTV.text!]
        SVProgressHUD.show()
        
        var input = [MultipartData]()
        if let receiptimageData = receiptImg.resizeWithWidth(width: 500)?.jpegData(compressionQuality: 0.5) {
            input.append(MultipartData.init(data: receiptimageData, paramName: "receipt_prof_img", fileName: receiptImg.description))
        }
        let url = user_type == TransportationCompany ? "api/sendPaymentRequestDataForTC" : "api/sendPaymentRequestData"
        APIManager.apiPostMultipart(serviceName: url, parameters: parameters, multipartImages: input) { (data, json, error, progress) in
            SVProgressHUD.dismiss()
            if error != nil {
                showAlert(title: "Error", message: error!.localizedDescription, viewController: self)
            }
            if progress != nil {
                SVProgressHUD.showProgress(Float(progress ?? 0), status: "Uploading Receipt...")
            } else {
                SVProgressHUD.dismiss()
            }
            
            guard let json = json else { return }
            let result = json[0]["result"].stringValue
            let message = json[0]["message"].stringValue
            
            if result == "1" {
                let vc = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: "SuccessVC") as? SuccessVC
                vc?.titleStr = "Success"
                vc?.subtitleStr = "Thanks for the payment. Your request is in progress. We will inform you within 24 hours."
                vc?.btnTitle = "Dashboard"
            self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                showAlert(title: "Alert", message: message, viewController: self)
            }
        }
    }
}

extension UploadReceiptViewController: ImageSelectorDelegate {
    func imageSelector(didSelectImage image: UIImage?, imgName: String?) {
        receiptImage.image = image
    }
}
