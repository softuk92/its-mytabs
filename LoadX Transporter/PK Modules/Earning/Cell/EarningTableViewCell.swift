//
//  EarningTableViewCell.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 01/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
 
class EarningTableViewCell: UITableViewCell, NibReusable{
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var vehiclType: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var jobId: UILabel!

    @IBOutlet weak var loadXShare: UILabel!
    weak var cellDelegate:TableViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.bottomShadow(color: UIColor.black)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didTabButton(sender: UIButton){
        sender.isSelected = !sender.isSelected
        cellDelegate?.didTapButton(cell: self, selected: sender.isSelected)
    }
   // @IBOutlet weak var shadowView: UIView!
    func populateData(data:PayToLoadXItme)  {
        self.vehiclType.text = data.vehicleType
        self.dateLabel.text = data.date
        self.loadXShare.text = data.loadxShare
        self.jobId.text = data.jobID
    }

    
}
