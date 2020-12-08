//
//  ApiManager.swift
//  LoadX Transporter
//
//  Created by Fahad Baig on 10/11/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public struct MultipartData {
    let data: Data
    let paramName: String
    let fileName: String
}

class APIManager: NSObject {

class func apiGet(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (Data?, JSON?, NSError?) -> ()) {

    Alamofire.request(main_URL+serviceName, method: .get, parameters: parameters).responseJSON { (response) in
        
        switch(response.result) {
        case .success(_):
            if let data = response.result.value{
                let json = JSON(data)
                completionHandler(response.data,json,nil)
            }
            break

        case .failure(_):
            completionHandler(nil, nil,response.result.error as NSError?)
            break

        }
    }
}

class func apiPost(serviceName:String,parameters: [String:Any]?, completionHandler: @escaping (Data?, JSON?, NSError?) -> ()) {

    Alamofire.request(main_URL+serviceName, method: .post, parameters: parameters).responseJSON { (response) in

        switch(response.result) {
        case .success(_):
            if let data = response.result.value{
                let json = JSON(data)
                completionHandler(response.data,json,nil)
            }
            break

        case .failure(_):
            completionHandler(nil,nil,response.result.error as NSError?)
            break
        }
    }
}
    
    class func apiPostMultipart(serviceName: String, parameters: [String:Optional<String>], multipartImages: [MultipartData], completionHandler: @escaping (Data?, JSON?, Error?) -> ()) {
//        if imagePicked == 1 {
//            var image1 = myImage1.image
//            image1 = image1?.resizeWithWidth(width: 500)
//            imageData1 = image1?.jpegData(compressionQuality: 0.2)
//        }
        Alamofire.upload(multipartFormData: {
            (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append(value!.data(using: .utf8)!, withName: key)
            }
            
            for images in multipartImages {
                multipartFormData.append(images.data, withName: images.paramName, fileName: images.fileName, mimeType: "image/jpeg")
            }
        }, to:main_URL+serviceName)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if let data = response.result.value{
                        let json = JSON(data)
                        completionHandler(response.data,json,nil)
                    }
                }
                break
            case .failure(let encodingError):
                completionHandler(nil,nil,encodingError)
                break
            }
        }
    }

}
