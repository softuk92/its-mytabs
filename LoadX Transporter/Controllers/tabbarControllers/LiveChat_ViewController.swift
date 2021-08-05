//
//  LiveChat_ViewController.swift
//  LoadX Transporter
//
//  Created by AIR BOOK on 13/05/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import WebKit

class LiveChat_ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webview: WKWebView!
    
//    var webview: WKWebView!

//    override func loadView() {
//        webview = WKWebView()
//        webview.navigationDelegate = self
//        view = webview
//    }
    override func viewDidLoad() {
       super.viewDidLoad()
//        webView = WKWebView(frame: view.frame)
        
        if AppUtility.shared.country == .Pakistan {
       let url = URL(string: "https://tawk.to/chat/60dda77b7f4b000ac03a840b/1f9gtcfet")!
        let requestObj = URLRequest(url: url)
   webview.load(requestObj)
        } else {
            let url = URL(string: "https://tawk.to/chat/5eb295cba1bad90e54a22be7/default")!
             let requestObj = URLRequest(url: url)
        webview.load(requestObj)

        }
//   self.view.addSubview(webView)
//        self.view.sendSubviewToBack(webView)
        
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


