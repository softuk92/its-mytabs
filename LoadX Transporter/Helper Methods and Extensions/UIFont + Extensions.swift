//
//  UIFont+Utilities.swift
//  Utilities
//
//  Created by Mehsam Saeed on 25/09/2019.
//  Copyright © 2019 Incubasys. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Register Font
public extension UIFont {

    static func registerFont(withFilenameString filenameString: String, bundle: Bundle) {

        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }

        guard let font = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}

//MARK:- Override system font

fileprivate extension String {
    func font(size: CGFloat) -> UIFont {
        return UIFont(name: self, size: size)!
    }
}

extension UIFont {

    //MARK:- CustomFont
    static var customFont: CustomFont!

    public struct CustomFont {
        var light: String
        var ultraLight: String
        var thin: String
        let regular: String
        let medium: String
        let semibold: String
        let bold: String
        var heavy: String
        var black: String

        public init(regular: String, medium: String, semibold: String, bold: String) {
            self.light = regular
            self.ultraLight = regular
            self.thin = regular
            self.regular = regular
            self.medium = medium
            self.semibold = semibold
            self.bold = bold
            self.heavy = bold
            self.black = bold
        }
    }

    @objc class func mySystemFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .light:
            return customFont.light.font(size: size)
        case .ultraLight:
            return customFont.ultraLight.font(size: size)
        case .thin:
            return customFont.thin.font(size: size)
        case .regular:
            return customFont.regular.font(size: size)
        case .medium:
            return customFont.medium.font(size: size)
        case .semibold:
            return customFont.semibold.font(size: size)
        case .bold:
            return customFont.bold.font(size: size)
        case .heavy:
            return customFont.heavy.font(size: size)
        case .black:
            return customFont.black.font(size: size)
        case .semibold:
            return customFont.light.font(size: size)
        default:
            return customFont.regular.font(size: size)
        }
    }

    /*
    @objc class func mySystemFontItalic(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return customFont.italic.font(size: size)
    }
    */


    @objc class func mySystemFontRegular(ofSize size: CGFloat) -> UIFont {
        return mySystemFont(ofSize: size, weight: .regular)
    }

    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        return mySystemFont(ofSize: size, weight: .bold)
    }

    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        return mySystemFont(ofSize: size, weight: .regular)
    }



    @objc convenience init?(myCoder aDecoder: NSCoder) {
        let attribute = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[attribute] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        var fontName = ""
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = UIFont.customFont.regular
        case "CTFontMediumUsage":
            fontName = UIFont.customFont.medium
        case "CTFontSemiboldUsage","CTFontEmphasizedUsage":
            fontName = UIFont.customFont.semibold
        case "CTFontBoldUsage":
            fontName = UIFont.customFont.bold
        case "CTFontHeavyUsage":
            fontName = UIFont.customFont.heavy
        case "CTFontBlackUsage":
            fontName = UIFont.customFont.black
        case "CTFontObliqueUsage":
            fontName = UIFont.customFont.regular
        default:
            fontName = UIFont.customFont.regular
        }
         self.init(name: fontName, size: fontDescriptor.pointSize)
    }

    public class func overrideDefaultTypography(customFont: CustomFont) {
        self.customFont = customFont
        guard self == UIFont.self else { return }

        if let systemFontMethodWithWeight = class_getClassMethod(self, #selector(systemFont(ofSize: weight:))),
            let mySystemFontMethodWithWeight = class_getClassMethod(self, #selector(mySystemFont(ofSize: weight:))) {
            method_exchangeImplementations(systemFontMethodWithWeight, mySystemFontMethodWithWeight)
        }

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFontRegular(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }

        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }

        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))),
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}

public extension UIFont {
    static func printFontFamilies() {
        dump(UIFont.familyNames)
    }

    static func printFont(ofFamily family: String) {
        dump(UIFont.fontNames(forFamilyName: family))
    }
}

