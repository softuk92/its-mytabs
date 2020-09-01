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

//    @IBOutlet weak var webview: WKWebView!
    
    var webview: WKWebView!

    override func loadView() {
        webview = WKWebView()
        webview.navigationDelegate = self
        view = webview
    }
    override func viewDidLoad() {
       super.viewDidLoad()
//        webView = WKWebView(frame: view.frame)
        
       let url = URL(string: "https://tawk.to/chat/5eb295cba1bad90e54a22be7/default?$_tawk_sk=5ebbc54286b22af366d40bfb&$_tawk_tk=f0b922a1d473a077ec91ac875c0e508f&v=683")!
        let requestObj = URLRequest(url: url as URL)
    
//        webView = WKWebView(frame: self.view.frame)
   webview.navigationDelegate = self
   webview.load(requestObj)
//   self.view.addSubview(webView)
//        self.view.sendSubviewToBack(webView)
        webview.allowsBackForwardNavigationGestures = true
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
    print(error.localizedDescription)
    }


     func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("Start to load")
        }

     func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    print("finish to load")
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
