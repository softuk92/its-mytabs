//
//  ConstomImageView.swift
//  NationalUIKit
//
//  Created by Mehsam Saeed on 25/09/2019.
//  Copyright © 2019 Incubasys. All rights reserved.
//

import Foundation
import UIKit
 public class CustomizedView: UIView {
     @IBInspectable public var cornerRadius: CGFloat = 10{
        didSet{
             configureCornerRadious(radious: cornerRadius)
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 3{
        didSet{
            configureborderWidth(radious: borderWidth)
        }
    }
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear{
        didSet{
             configureBorderColor(color: borderColor)
        }
    }
    @IBInspectable public var drawShadow: Bool = false{
        didSet{
            guard drawShadow else {return}
            applyShadow(color: shadowColor,shadowAlpha: shadowAlpha)
        }
    }
    @IBInspectable public var shadowColor: UIColor = UIColor.clear
    @IBInspectable public var shadowAlpha: Float = 10
    
    override public func awakeFromNib() {
        configureUI()
    }
    
    private func configureUI(){
        configureCornerRadious(radious: cornerRadius)
        configureBorderColor(color: borderColor)
        configureborderWidth(radious: borderWidth)
    }
    private func configureCornerRadious(radious:CGFloat){
         self.layer.cornerRadius = cornerRadius
    }
    private func configureborderWidth(radious:CGFloat){
          self.layer.borderWidth = borderWidth
    }
    private func configureBorderColor(color:UIColor){
        self.layer.borderColor = borderColor.cgColor
    }
    
    private func applyShadow(color:UIColor,shadowAlpha:Float){
      //  self.layer.applySketchShadow(color: color, alpha: shadowAlpha, blur: 10, spread: 0)
    }
    
}
