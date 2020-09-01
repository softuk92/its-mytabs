//
//  UserManaulController.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 2/28/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

import UIKit
import YouTubePlayer
import QuickLook
import Alamofire
import SVProgressHUD

class UserManaulController: UIViewController {

    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    let url = URL(string: "https://www.youtube.com/watch?v=ZRe1Q1fa4DU")
    let url2 = URL(string: main_URL+"assets/user-manuals/transport-partner-manual.pdf")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User Manual"
        if url != nil {
            videoPlayer.loadVideoURL(url!)
        }
        
    }

    @IBAction func downloadPDF(_ sender: Any) {
        openPDF()
    }
    
    func openPDF() {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("file.pdf")
            return (documentsURL, [.removePreviousFile])
        }
        
        Alamofire.download(url2!, to: destination)
            .downloadProgress(closure: { (progress) in
                SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Downloading file...")
            })
            .responseData { response in
                if let destinationUrl = response.destinationURL {
                    
                    print("destinationUrl \(destinationUrl.absoluteURL)")
                    SVProgressHUD.dismiss()
                    self.openQlPreview()
                }
                
        }
    }
    
    func openQlPreview() {
        let previoew = QLPreviewController.init()
        previoew.dataSource = self
        previoew.delegate = self
        self.present(previoew, animated: true, completion: nil)
    }
    
}

extension UserManaulController : QLPreviewControllerDelegate , QLPreviewControllerDataSource{
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let documentsURL = try! FileManager().url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true)
        
        let path = documentsURL.appendingPathComponent("file.pdf")
        return path as QLPreviewItem
    }
    
    func previewController(_ controller: QLPreviewController, shouldOpen url: URL, for item: QLPreviewItem) -> Bool {
        return true
    }
    
    
}
