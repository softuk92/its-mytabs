//
//  ManageTransporterViewCell.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 19/09/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable


class ManageTransporterViewCell: UITableViewCell,NibReusable {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var mobileTiele: UILabel!
    @IBOutlet weak var vehical: UILabel!
    @IBOutlet weak var vehicalType: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: TableViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.shadowView.applyShadowToView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func setData(data: ManageDriver) {
        titleLabel.text = data.userName
        status.text = data.status
        mobileNumber.text = data.userPhone
        vehical.text = data.vanType
        if data.status.lowercased() == "Approved".lowercased(){
            self.status.textColor = UIColor(hexString: "04A700")
        }
        else if data.status.lowercased() == "pending".lowercased(){
            self.status.textColor = UIColor(hexString: "D79300")
        }
        else{
            self.status.textColor = R.color.mehroonColor() ?? UIColor.black
        }
    }
    
    @IBAction func editButtonTapped(sender: UIButton){
        delegate?.editButtonTapped(cell: self)
    }
    
    @IBAction func deleteButtonTapped(sender: UIButton){
        delegate?.deleteButtonTapped(cell: self)
    }
    
    
}
