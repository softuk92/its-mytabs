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
    override func awakeFromNib() {
        super.awakeFromNib()
        shadowView.bottomShadow(color: UIColor.black)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didTabButton(sender: UIButton){
        sender.isSelected = !sender.isSelected
    }
   // @IBOutlet weak var shadowView: UIView!

    
}
