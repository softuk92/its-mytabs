
//  AppIntro_ViewController.swift
//  LoadX Transporter
//
//  Created by CTS Move on 12/03/2020.
//  Copyright © 2020 BIAD Services Ltd. All rights reserved.
//

import UIKit
import BmoViewPager

class AppIntro_ViewController: UIViewController , BmoViewPagerDataSource, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet weak var pagerView: BmoViewPager!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var previousVC: UIViewController?
    var showingIndex: Int = 0
    var pageVC: UIPageViewController?
    
    var nextController : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.delegate = self
        pagerView.dataSource = self
        // Do any additional setup after loading the view.
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
                    nextController = 0
                   
                    return vc
                    
                }
            case 1:
                if let vc = storyboard?.instantiateViewController(withIdentifier: "VC2") as? VC2 {
                   nextController = 1
                    return vc
                }
            case 2:
                if let vc = storyboard?.instantiateViewController(withIdentifier: "VC3") as? VC3 {
                   nextController = 2
                    self.nextButton.titleLabel?.text = "Next"
                    return vc
                }
            case 3:
                if let vc = storyboard?.instantiateViewController(withIdentifier: "VC4") as? VC4 {
                    print("this is 4th controller")
                    self.nextButton.titleLabel?.text = "Finish"
                  nextController = 3
                    return vc
                }
            default:
                break
            }
            return UIViewController()
        }

    func setPager() {
            pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewControllerMain") as! UIPageViewController?
            pageVC?.dataSource = self
            pageVC?.delegate = self
        let startVC = viewControllerAtIndex(tempIndex: nextController!)
            _ = startVC.view
            
            pageVC?.setViewControllers([startVC], direction: .forward, animated: false, completion: nil)
            pageVC?.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEGHT)
            self.addChild(pageVC!)
            self.view.addSubview((pageVC?.view)!)
            self.pageVC?.didMove(toParent: self)
            
        }
    
    @IBAction func Next_action(_ sender: Any) {
        
     if nextController == 0 {
         self.setPager()
            let startVC = viewControllerAtIndex(tempIndex: 0)
                    _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse , animated: false, completion: nil)
             
     }else if nextController == 1 {
         self.setPager()
        let startVC = viewControllerAtIndex(tempIndex: 1)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: false, completion: nil)
     }else if nextController == 2 {
         self.setPager()
        let startVC = viewControllerAtIndex(tempIndex: 2)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse , animated: false, completion: nil)
     }else if nextController == 3 {
         self.setPager()
        let startVC = viewControllerAtIndex(tempIndex: 2)
            _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse , animated: false, completion: nil)
        }
    }
    
    
    func viewControllerAtIndex(tempIndex: Int) -> UIViewController {
             
                if tempIndex == 0 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC1") as! VC1

                    return vc
                }
                else if tempIndex == 1 {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC2" ) as! VC2
                 
                    return vc
                }  else if tempIndex == 2 {
                     let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC3") as! VC3

                     return vc
                    
                 } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VC4") as! VC4

                    return vc
                    
                    }
             }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
           return nil
       }
       
       func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
           return nil
       }
    }

    extension AppIntro_ViewController: BmoViewPagerDelegate {
        func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int) {
            pageControl.currentPage = page
            nextController = page
        }
    }
