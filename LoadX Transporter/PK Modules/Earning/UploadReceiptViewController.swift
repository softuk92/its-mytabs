//
//  UploadReceptViewController.swift
//  LoadX Transporter
//
//  Created by Mehsam Saeed on 02/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable
class UploadReceiptViewController: UIViewController,StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = R.storyboard.earning()
    @IBOutlet weak var shadowView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
