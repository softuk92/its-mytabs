//
//  job_DetialView_TableViewCell.swift
//  LoadX Transporter
//
//  Created by CTS Move on 27/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit

class job_DetialView_TableViewCell: UITableViewCell {

    @IBOutlet weak var job_description_lbl: UILabel!
    
    @IBOutlet weak var jobDescrp_height: NSLayoutConstraint!
    @IBOutlet weak var jobDesrpt_view: UIView!
    
    @IBOutlet weak var inventory_view: UIView!
    @IBOutlet weak var inventory_view_height: NSLayoutConstraint!
    @IBOutlet weak var inventoryList_view: UIView!
    @IBOutlet weak var sofa_value: UILabel!
    
    @IBOutlet weak var inventory_view_hieght: NSLayoutConstraint!
    @IBOutlet weak var jobId_lbl: UILabel!
    @IBOutlet weak var category_lbl: UILabel!
    @IBOutlet weak var movingFrom_lbl: UILabel!
    @IBOutlet weak var movingTo_lbl: UILabel!
    @IBOutlet weak var pickUp_lbl: UILabel!
    @IBOutlet weak var pickUp_time: UILabel!
    @IBOutlet weak var postedDate_lbl: UILabel!
    @IBOutlet weak var vehicleType_lbl: UILabel!
    @IBOutlet weak var No_of_vehicle_lbl: UILabel!
    @IBOutlet weak var no_of_helpers_lbl: UILabel!
    @IBOutlet weak var no_of_beds_lbl: UILabel!
    @IBOutlet weak var no_of_items_lbl: UILabel!
    @IBOutlet weak var supermarketName_lbl: UILabel!
    @IBOutlet weak var vehicleOperational_lbl: UILabel!
    
    @IBOutlet weak var jobId_view: UIView!
    @IBOutlet weak var category_view: UIView!
    @IBOutlet weak var MovingFrom_view: UIView!
    @IBOutlet weak var movingTo_view: UIView!
    @IBOutlet weak var pickUp_Date_view: UIView!
    @IBOutlet weak var pickUp_time_view: UIView!
    @IBOutlet weak var posted_date_view: UIView!
    @IBOutlet weak var vehicleType_view: UIView!
    @IBOutlet weak var noOfVehicle_view: UIView!
    @IBOutlet weak var noOfHelpers_view: UIView!
    @IBOutlet weak var noOfBeds_view: UIView!
    @IBOutlet weak var noOfItems_view: UIView!
    @IBOutlet weak var supermarketName_view: UIView!
    @IBOutlet weak var vehicleOperational_view: UIView!
    
    @IBOutlet weak var jobDetialView_height: NSLayoutConstraint!
    @IBOutlet weak var movingFrom_height: NSLayoutConstraint!
    @IBOutlet weak var movingTo_height: NSLayoutConstraint!
    @IBOutlet weak var vehicleType_height: NSLayoutConstraint!
    @IBOutlet weak var no_ofVehicle_height: NSLayoutConstraint!
    @IBOutlet weak var noOfHelper_height: NSLayoutConstraint!
    @IBOutlet weak var noOfBed_height: NSLayoutConstraint!
    @IBOutlet weak var noOfItem_height: NSLayoutConstraint!
    @IBOutlet weak var supermarketName_height: NSLayoutConstraint!
    @IBOutlet weak var vehicleOperational_height: NSLayoutConstraint!
    @IBOutlet weak var detialView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
