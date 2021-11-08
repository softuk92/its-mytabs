
//  AppIntro_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 12/03/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import BmoViewPager

class AppIntro_ViewController: UIViewController , BmoViewPagerDataSource {
    
    @IBOutlet weak var pagerView: BmoViewPager!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var previousVC: UIViewController?
    var showingIndex: Int = 0
    var pageVC: UIPageViewController?
    
    var nextController = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.delegate = self
        pagerView.dataSource = self
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
        
    }
    
    @IBAction func skip_action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 4
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {

        switch page {
        case 0:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "VC1") as? VC1 {
                return vc
            }
        case 1:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "VC2") as? VC2 {
                return vc
            }
        case 2:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "VC3") as? VC3 {
                return vc
            }
        case 3:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "VC4") as? VC4 {
                return vc
            }
        default:
            break
        }
        return UIViewController()
    }
    
    @IBAction func Next_action(_ sender: Any) {
        if self.nextButton.titleLabel?.text == "Finish" {
            self.navigationController?.popViewController(animated: true)
        }
        
        if self.nextController == 0 {
            self.pagerView.pageControlIndex = 1
            self.pagerView.presentedPageIndex = 1
        } else if self.nextController == 1 {
            self.pagerView.pageControlIndex = 2
            self.pagerView.presentedPageIndex = 2
        } else if self.nextController == 2 {
            self.pagerView.pageControlIndex = 3
            self.pagerView.presentedPageIndex = 3
        } 
    }
}

extension AppIntro_ViewController: BmoViewPagerDelegate {
    func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int) {
//        print("page: \(page)")
        pageControl.currentPage = page
        nextController = page
        if page == 3 {
            self.nextButton.setTitle("Finish", for: .normal)
        }
    }
}
