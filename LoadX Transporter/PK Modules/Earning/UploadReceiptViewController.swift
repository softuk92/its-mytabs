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
class UploadReceiptViewController: UIViewController,StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = R.storyboard.earning()
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bankName: UILabel!
    @IBOutlet weak var accNo: UILabel!
    @IBOutlet weak var accHolder: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var messageTV: UITextView!

    @IBOutlet weak var uploadButtonView: UIView!

    var paymentsToPay = [PayToLoadXItme]()
    var dataSource: UploadReceipt?
   

    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.bottomShadow(color: UIColor.black)
        uploadButtonView.clipsToBounds = true
        uploadButtonView.layer.cornerRadius = 10
        uploadButtonView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        fetechData()
    }
    
    func fetechData()  {
        guard let id = user_id else {return}
        var checkBooks = [String]()
        for model in paymentsToPay{
            let checkBox = "\(model.loadxShare)/\(model.delID)"
            checkBooks.append(checkBox)
        }
        let params:Parameters = ["user_id":id,"pay_checkbox":checkBooks]

        SVProgressHUD.show()
        APIManager.apiPost(serviceName: "api/uploadReceipt", parameters: params) {[weak self] data, json, error in
            guard let self = self else {return}
            if error == nil{
                if let json = json{
                    self.dataSource = UploadReceipt(json: json)
                    self.populateData()
                }
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    
    func populateData() {
        bankName.text = dataSource?.bankName.capitalized
        accNo.text = dataSource?.accNo
        accHolder.text = dataSource?.accHolder
        self.totalAmount.text = dataSource?.totalAmountToPay.withCommas()
    }
    
    @IBAction func didTapBack(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func uploadTapped(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
