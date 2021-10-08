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
}

class StringsEn: StringResources {
    let submit = "Submit"
}

class StringsUr: StringResources {
    let submit = "جمع کروائیں"
}

