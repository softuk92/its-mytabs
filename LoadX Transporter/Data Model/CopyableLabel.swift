//
//  File.swift
//  CTS Move Transporter
//
//  Created by Fahad Baigh on 4/11/19.
//  Copyright © 2019 BIAD Services Ltd. All rights reserved.
//

class CopyableLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    func sharedInit() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
    }
    
    @objc func showMenu(_ recognizer: UILongPressGestureRecognizer) {
        self.becomeFirstResponder()
        
        let menu = UIMenuController.shared
        
        let locationOfTouchInLabel = recognizer.location(in: self)
        
        if !menu.isMenuVisible {
            var rect = bounds
            rect.origin = locationOfTouchInLabel
            rect.size = CGSize(width: 1, height: 1)
            
            menu.setTargetRect(rect, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        
        board.string = text
        
        let menu = UIMenuController.shared
        
        menu.setMenuVisible(false, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
}
