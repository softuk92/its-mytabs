//
//  Reach_Us_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 04/02/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import ZDCChat

class Reach_Us_ViewController : UIViewController {

    @IBOutlet weak var gifImage: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.isHidden = isCompanyDriver == "1"
    }
    @IBAction func backBtn_action(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    @IBAction func contactUs(_ sender: Any) {

        let sb = UIStoryboard(name: "Main", bundle: nil)

        let showVC = sb.instantiateViewController(withIdentifier: "ContactUsViewController") as? ContactUsViewController

        self.navigationController?.pushViewController(showVC!, animated: true)
    }
    
    @IBAction func liveChat_action(_ sender: Any) {
      //   ZDCChat.start(in: self.navigationController, withConfig: nil)
   let sb = UIStoryboard(name: "Main", bundle: nil)
          
          let showVC = sb.instantiateViewController(withIdentifier: "LiveChat_ViewController") as? LiveChat_ViewController
      
          self.navigationController?.pushViewController(showVC!, animated: true)
    }
    @IBAction func rateUs_action(_ sender: Any) {
    
    rateApp(appId: "id1458875857?mt=8") { (success) in
            print("Rateapp \(success)")
        }
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
      
        guard let url = URL(string : "https://itunes.apple.com/app/" + appId) else {
                      completion(false)
                      return
                  }
            guard #available(iOS 10, *) else {
        
            completion(UIApplication.shared.openURL(url))
                      return
                  }
        
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
              
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
