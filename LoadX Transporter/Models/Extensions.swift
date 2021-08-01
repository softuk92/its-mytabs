//
//  Extensions.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 07/09/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import Foundation
import UIKit


public func getDoubleValue(currentBid: Double, doubleValue: Double) -> String {
    let resultInitialPrice = currentBid * Double(doubleValue/100)
    
    let resultRemaining = currentBid - resultInitialPrice.rounded(toPlaces: 2)
    
//    if String(resultRemaining).contains(".0") {
//        return String(format: "%.1f", resultRemaining)
//    } else {
    if AppUtility.shared.country == .Pakistan {
        let price = Int(resultRemaining).withCommas()
        return String(price)
    } else {
        return String(format: "%.2f", resultRemaining)
    }
//    }
}

public func getDoubleValue2(currentBid: Double, doubleValue: Double) -> String {
    let resultInitialPrice = currentBid * Double(doubleValue/100)
    
    let resultRemaining = currentBid - resultInitialPrice.rounded(toPlaces: 2)
    
    if AppUtility.shared.country == .Pakistan {
        let price = Int(resultRemaining).withCommas()
        return String(price)
    } else {
        return String(format: "%.2f", resultRemaining)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
