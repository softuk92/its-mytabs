//
//  ImageViewCell.swift
//  LoadX Transporter
//
//  Created by CTS Move on 07/12/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class ImageViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
