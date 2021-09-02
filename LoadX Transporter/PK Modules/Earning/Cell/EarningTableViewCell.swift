//
//  EarningTableViewCell.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 01/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
 
class EarningTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var vehiclType: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var jobId: UILabel!
    @IBOutlet weak var jobType: UILabel!
    @IBOutlet weak var jobTypeView: UIView!
    @IBOutlet weak var bottomBorder: UIView!

    @IBOutlet weak var loadXShare: UILabel!
    weak var cellDelegate:TableViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
     //   shadowView.bottomShadow(color: UIColor.black)
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
      //  self.vehiclType.text = data.vehicleType
		self.vehiclType.text = data.vehicle
        self.dateLabel.text = data.date

		let formattedPrice = data.price.withCommas()
        self.loadXShare.text = AppUtility.shared.currencySymbol+formattedPrice
       // self.jobId.text = data.jobID
		switch data.jType {
		case .loadXShare:
			self.jobType.text = "LoadX Share"
			self.jobTypeView.backgroundColor = UIColor(hexString: "#11AD04")
		case .transporterShare:
			self.jobType.text = "Transporter Share"
			self.jobTypeView.backgroundColor = UIColor(hexString: "#EABD00")
		}
    }


	func setRoundedCorners(corners: UIRectCorner, radius: CGFloat){
//		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

			self.setNeedsLayout()
			self.layoutIfNeeded()
			let maskPath1 = UIBezierPath(roundedRect: self.shadowView.bounds,
										 byRoundingCorners: corners,
										 cornerRadii: CGSize(width: radius, height: radius))
			let maskLayer1 = CAShapeLayer()
			maskLayer1.frame = self.shadowView.bounds
			maskLayer1.path = maskPath1.cgPath
			self.shadowView.layer.mask = maskLayer1
//		}
	}
    
}
