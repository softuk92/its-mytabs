//
//  Strings.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 08/10/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

let string: StringResources = {
    //Locale.current.languageCode == "ar" ? StringAr() : StringsEn()
//    return StringsEn()
    if Config.shared.currentLanguage.value == .ur {
        return StringsUr()
    }
    else {
        return StringsEn()
    }
}()

protocol StringResources {
    var submit: String {get}
    var JobCancelReason: String {get}
    var pickupArrived: String {get}
    var uploadImages: String {get}
    var disclaimer: String {get}
    var leavingForDropoff: String {get}
}

class StringsEn: StringResources {
    let submit = "Submit"
    let JobCancelReason = "Job Cancel Reason"
    let pickupArrived: String = "Arrived"
    let uploadImages: String = "Upload Images"
    let disclaimer: String = "Disclaimer"
    let leavingForDropoff: String = "Leaving for Dropoff"
}

class StringsUr: StringResources {
    let submit = "جمع کروائیں"
    let JobCancelReason = "جاب منسوخ کرنے کی وجہ۔"
    let pickupArrived = "سامان کی جگہ پر پہنچ گیا ہون"
    let uploadImages: String = "تصاویر اپ لوڈ کریں"
    let disclaimer: String = "شرائط و ضوابط۔"
    let leavingForDropoff: String = "سامان پہنچانے کے لیے نکل گیا ہوں"
}
