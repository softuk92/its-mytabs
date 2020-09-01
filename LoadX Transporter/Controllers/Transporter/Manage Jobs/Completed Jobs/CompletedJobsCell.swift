//
//  CompletedJobsCell.swift
//  CTS Move
//
//  Created by Fahad Baigh on 2/1/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit

class CompletedJobsCell: UITableViewCell {

    @IBOutlet weak var moving_item: UILabel!
    @IBOutlet weak var pick_up: UILabel!
    @IBOutlet weak var drop_off: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var businessPatti: UIImageView!
    @IBOutlet weak var widthBusiness: NSLayoutConstraint!
   
    @IBOutlet weak var payment_type_lbl: UILabel!
    @IBOutlet weak var dateIcon: UIImageView!
   
    @IBOutlet weak var completion_dateView: UIView!
    @IBOutlet weak var completionDate_Lbl: UILabel!
    @IBOutlet weak var cellBackground_view: UIView!
    /*@IBOutlet weak var Revice_amount_view: UIView!
    @IBOutlet weak var driver_view: UIView!
    @IBOutlet weak var payment_type_icon: UIImageView!
    @IBOutlet weak var driver_name: UIButton!
    @IBOutlet weak var receivedAmount: UILabel!
     @IBOutlet weak var user_Icon_img: UIImageView!*/
    @IBOutlet weak var delete_btn: UIButton!
    
    var deleteRow: ((CompletedJobsCell) -> Void)?
    var transporterProfileRow: ((CompletedJobsCell) -> Void)?
    var detailJobRow: ((CompletedJobsCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CompletedJobsCell.viewDetails))
        moving_item.isUserInteractionEnabled = true
        moving_item.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func viewDetails(sender: UITapGestureRecognizer) {
        detailJobRow?(self)
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        deleteRow?(self)
    }
    
    @IBAction func getTransporterProfile(_ sender: Any) {
        transporterProfileRow?(self)
    }
    

}
