//
//  LabelClassForLang.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 18/10/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
import UIKit

//MARK: Labels
public class BaseLabel: UILabel {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    public func configure() {
        self.textAlignment = Config.shared.currentLanguage.value == .en ? .left : .right
    }
    
    public func configureTextColor(textColor: UIColor, textTintColor: UIColor?) {
        if let color = textTintColor {
            self.textColor = color
        }else {
            self.textColor = textColor
        }

    }
}
