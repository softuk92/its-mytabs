//
//  Strings.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 08/10/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation

var string: StringResources {
    //Locale.current.languageCode == "ar" ? StringAr() : StringsEn()
//    return StringsEn()
    if Config.shared.currentLanguage.value == .ur {
        return StringsUr()
    }
    else {
        return StringsEn()
    }
}

protocol StringResources {
    var submit: String {get}
    var JobCancelReason: String {get}
    var pickupArrived: String {get}
    var uploadImages: String {get}
    var disclaimer: String {get}
    var leavingForDropoff: String {get}
    var dropoffArrived: String {get}
    var cashCollected: String {get}
    var disclaimerDetails: String {get}
    var haveYouCollectedCashOnThisJob: String {get}
    var cashReceived: String {get}
    var jobCompleted: String {get}
    var uploadDeliveryProof: String {get}
    var receiverSignature: String {get}
    var dashboard: String {get}
    var backToJob: String {get}
    var AreYouSureYouWantToAcceptThisJob : String {get}
    var yes: String {get}
    var no: String {get}
    var price: String {get}
    var date: String {get}
    var time: String {get}
    var search: String {get}
    var clear: String {get}
    var updateProfile: String {get}
    var AreYouSureYouWantToLogOut: String {get}
    var updatePassword: String {get}
    var areYouSureYouWantToDeactivateAccount: String {get}
    var close: String {get}
    var profileUpdatedSuccessfully: String {get}
    var acceptJob: String {get}
}


class StringsEn: StringResources {
    let submit = "Submit"
    let JobCancelReason = "Job Cancel Reason"
    let pickupArrived: String = "Arrived"
    let uploadImages: String = "Upload Images"
    let disclaimer: String = "Disclaimer"
    let leavingForDropoff: String = "Leaving for Dropoff"
    let dropoffArrived: String = "Arrived"
    let cashCollected: String = "Cash Collected"
    let disclaimerDetails: String = "This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our services and the choices you have associated with that data.\n\nBy using the Service, you agree to the collection and use of information in accordance with this policy. Unless otherwise deﬁned in this privacy policy, terms used in this privacy policy have the same meanings as in our terms and conditions.\n\nThe terms our, us, we and Service refer to LoadX on this page.\n\n1. What personal information do we collect?\n\nWe process different types of information for various purposes to provide and improve our Service to you."
    let haveYouCollectedCashOnThisJob: String = "Have you collected cash on this job?"
    let cashReceived: String = "Cash Received"
    let jobCompleted: String = "Job Completed"
    let uploadDeliveryProof: String = "Upload Delivery Proof"
    let receiverSignature: String = "Receiver Signature"
    let dashboard: String = "Dashboard"
    let backToJob: String = "Back to Job"
    let AreYouSureYouWantToAcceptThisJob: String = "Are you sure you want to accept this job?"
    let yes: String = "Yes"
    let no: String = "No"
    let price: String = "Price"
    let date: String = "Date"
    let time: String = "Time"
    let search: String = "Search"
    let clear: String = "Clear"
    let updateProfile: String = "Update Profile"
    let AreYouSureYouWantToLogOut: String = "Are you sure you want to log out?"
    let updatePassword: String = "Update Password"
    let areYouSureYouWantToDeactivateAccount: String = "Are you sure you want to deactivate your account?"
    let close: String = "Close"
    let profileUpdatedSuccessfully: String = "Profile Updated Successfully."
    let acceptJob: String = "Accept Job"
}

class StringsUr: StringResources {
    let submit = "جمع کروائیں"
    let JobCancelReason = "جاب منسوخ کرنے کی وجہ۔"
    let pickupArrived = "سامان کی جگہ پر پہنچ گیا ہون"
    let uploadImages: String = "تصاویر اپ لوڈ کریں"
    let disclaimer: String = "شرائط و ضوابط۔"
    let leavingForDropoff: String = "سامان پہنچانے کے لیے نکل گیا ہوں"
    let dropoffArrived: String = "سامان کی جگہ پر پہنچ گیا ہوں"
    let cashCollected: String = "؟کیا رقم وصول کی"
    let disclaimerDetails: String = "ہمارے شرائط و ضوابط میں یہ بات شامل ہے کہ ہم آپ کی اشیاء کو آپ کی بتائی ہوئی جگہ پر بحفاظت پہنچائیں۔ کوئی بھی اضافی کام جیسے آپ کی اشیاء کو آپ کے مکان/دفتر کے اندر لے جانا یا فرنیچر کو کھولنا یا جوڑنا , بڑی اشیاء کو چھوٹی جگہ سے گزارنا وغیرہ آپ کی ذمہ داری ہوگا۔ اگر آپ ہمیں یہ کام کرنے کو کہیں گے تو اس دوران اگر کوئی نقصان ہوگا تو اسکے ذمہ دار ہم نہیں ہوں گے۔"
    let haveYouCollectedCashOnThisJob: String = "کیا آپ نے اس جاب پر نقد رقم وصول کی ھے؟"
    let cashReceived: String = "جی نقد رقم وصول کی ھے"
    let jobCompleted: String = "کیا جاب مکمل ھو گئی؟"
    let uploadDeliveryProof: String = "سامان پہنچانے کا ثبوت آپ لوڈ کریں"
    let receiverSignature: String = "وصول کرنے والے کے دستخط"
    let dashboard: String = "واپس جائیں"
    let backToJob: String = "واپس جائیں"
    let AreYouSureYouWantToAcceptThisJob: String = "کیا آپ یہ بکنگ حاصل کرنا چاہتے ہیں؟"
    let yes: String = "جی ہاں"
    let no: String = "نہیں"
    let price: String = "قیمت"
    let date: String = "تاریخ"
    let time: String = "وقت"
    let search: String = "تلاش کریں"
    let clear: String = "ختم کریں"
    let updateProfile: String = "تفصیلات اپ لوڈ کریں"
    let AreYouSureYouWantToLogOut: String = "کیا  آپ  لاگ  آؤٹ  کرنا  چاہتے  ہیں؟"
    let updatePassword: String = "پاس ورڈ اپ ڈیٹ کریں۔"
    let areYouSureYouWantToDeactivateAccount: String = "کیا آپ اپنا اکاؤنٹ غیر فعال کرنا چاہتے ہیں؟"
    let close: String = "بند کریں"
    let profileUpdatedSuccessfully: String = "پروفائل کامیابی کے ساتھ اپ ڈیٹ ہو گیا۔"
    let acceptJob: String = "جاب قبول کریں"
}
