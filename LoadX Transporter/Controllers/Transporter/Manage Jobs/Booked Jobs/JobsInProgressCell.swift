//
//  JobsInProgressCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class JobsInProgressCell: UITableViewCell {

    @IBOutlet weak var cellbackground_view: UIView!
    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var pick_up: UILabel!
    @IBOutlet weak var drop_off: UILabel!
    @IBOutlet weak var deliverDateIcon: UIImageView!
    @IBOutlet weak var deliveryDate_lbl: UILabel!
    @IBOutlet weak var jobCompleted_btn: UIButton!
   /* @IBOutlet weak var remianing_amount_lbl: UILabel!
    @IBOutlet weak var amount_view: UIView!
    @IBOutlet weak var customerInfo_view: UIView!
    @IBOutlet weak var tick_img: UIImageView!
    @IBOutlet weak var customer_info_lbl: UILabel!
    @IBOutlet weak var customerInfo_detial_view: UIView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var phoneIcon: UIImageView!
    
    @IBOutlet weak var ctsCharges_lbl: UILabel!
    @IBOutlet weak var acceptedBid_lbl: UILabel!
  
    @IBOutlet weak var driver_name: UIButton!
    @IBOutlet weak var driver_phone: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cts_charges: UILabel!
    @IBOutlet weak var remaining_amount: UILabel!
    @IBOutlet weak var acceptedBidStack: UIStackView!
    @IBOutlet weak var receivedAmountStack: UIStackView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var ctsChargesStack: UIStackView!
    @IBOutlet weak var jobPriceStack: UIStackView!
     @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
     @IBOutlet weak var cz_price_lbl: UILabel!
     @IBOutlet weak var sperate_line: UIView!
     @IBOutlet weak var payment_method_Icon: UIImageView!
      @IBOutlet weak var jobPrice_lalbe: UILabel!
     */
     @IBOutlet weak var widthBusiness: NSLayoutConstraint!
    @IBOutlet weak var jobPrice: UILabel!
      @IBOutlet weak var date: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var deletBtnOutlet: UIButton!
    @IBOutlet weak var businessPatti: UIImageView!
    
    @IBOutlet weak var payment_method_lbl: UILabel!
   
    
    var completeJobRow: ((JobsInProgressCell) -> Void)?
    var detailJobRow: ((JobsInProgressCell) -> Void)?
    var callRow: ((JobsInProgressCell) -> Void)?
    var emailRow: ((JobsInProgressCell) -> Void)?
    var transporterProfileRow: ((JobsInProgressCell) -> Void)?
    var deleteRow: ((JobsInProgressCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CompletedJobsCell.viewDetails))
        moving_item.isUserInteractionEnabled = true
        moving_item.addGestureRecognizer(tap)
//        self.innerView.dropShadow(color: .black, offSet: CGSize(width: -1, height: 1))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func viewDetails(sender: UITapGestureRecognizer) {
        detailJobRow?(self)
    }
    
    @IBAction func job_completed_btn(_ sender: Any) {
        completeJobRow?(self)
    }

    @IBAction func transporterProfile_btn(_ sender: Any) {
        transporterProfileRow?(self)
    }
    
    @IBAction func callTransporter(_ sender: Any) {
        callRow?(self)
    }
    
    @IBAction func emailBtn(_ sender: Any) {
        emailRow?(self)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        deleteRow?(self)
    }
    
}
