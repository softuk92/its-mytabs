//
//  Config.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 08/10/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum TextDirection{
    case LeftToRight
    case RightToLeft
}

public enum LoadxLanguage: String {
    case en = "en"
    case ur = "ur"

    public var isRTL: Bool {
        switch self {
        case .en:
            return false
        case .ur:
            return true
        }
    }
}

class Config{
    
    private var disposeBag = DisposeBag()
    
    private let keyCurrentLanguage = "keyCurrentLanguage"
    
    static var shared:Config = Config()
    
//    var remoteURL:URL{
//        #if DEBUG
//        return URL(string: "http://134.209.253.224/national_development/")!
//        #else
//        return URL(string: "http://134.209.253.224/national_development/")!
//        #endif
//        //http://10.1.2.192/national/
//    }
    var currentLanguage = BehaviorRelay<LoadxLanguage>(value: .en)
    
    func localizedString(en:String?, ur:String?, defaultString:String = "") -> Observable<String>{
        return currentLanguage.map { (lng) -> String in
//            return ((lng == .en) ? (en ?? ar) : (ar ?? en)) ?? defaultString
            return ((lng == .en) ? en : ("‏\(ur ?? defaultString)‏")) ?? defaultString
        }
    }
    func staticLocalisedString(en:String?, ur:String?, defaultString:String = "") -> String{
        let lang = currentLanguage.value
//        return ((lang == .en) ? (en ?? ar) : (ar ?? en)) ?? defaultString
        return ((lang == .en) ? en : ("‏\(ur ?? defaultString)‏")) ?? defaultString
    }
    private init(){
        let lngRawValue = UserDefaults.standard.string(forKey: self.keyCurrentLanguage)
        if let lng = LoadxLanguage(rawValue: lngRawValue ?? "" ){
            currentLanguage.accept(lng)
        }
        currentLanguage.skip(1).subscribe(onNext: { [weak self] (lng) in
            guard let self = self else {return}
            UserDefaults.standard.set(lng.rawValue, forKey: self.keyCurrentLanguage)
            },onError: {(error) in

        }).disposed(by: disposeBag)
    }
    
    var setLanguage: AnyObserver<LoadxLanguage>{
           let language = PublishSubject<LoadxLanguage>()
           language.bind(to: Config.shared.currentLanguage).disposed(by: disposeBag)
           return language.asObserver()
    }
}
