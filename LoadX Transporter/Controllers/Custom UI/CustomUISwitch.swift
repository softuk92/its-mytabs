//
//  CutomSwitchButton.swift
//  CarhtageTest
//
//  Created by Mehsam Saeed on 06/09/2019.
//  Copyright © 2019 hussaintechlabz. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa

public class CustomUISwitch: UIView, NibOwnerLoadable {
    
    //MARK: - outLet
    @IBOutlet private var switchView: UIView!
    
    //Constraints
    @IBOutlet private var trailing: NSLayoutConstraint!
//    @IBOutlet private var trailingLabel: NSLayoutConstraint!
    @IBOutlet private var leading: NSLayoutConstraint!
//    @IBOutlet private var leadingLabel: NSLayoutConstraint!
    @IBOutlet private weak var thumbView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    
    public var switchState = BehaviorRelay<Bool>(value:  false)
    
    private var isConstrintSet=true
    //var isConstrintSet=PublishSubject<Bool>()
    
    private var animationTime=0.4
    private let disposeBag=DisposeBag()
    
    
    //MARK: - Views Methods
    override public func awakeFromNib() {
        loadNibContent()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(actTap))
        self.addGestureRecognizer(tap)
        
        switchState.subscribe(onNext: { [weak self] (isOn) in
            guard let self = self else {return}
            self.trailing.isActive = isOn
//            self.trailingLabel.isActive = isOn
            self.leading.isActive = !isOn
//            self.leadingLabel.isActive = !isOn
            self.label.text = isOn ? "ON" : "OFF"
            self.thumbView.backgroundColor = isOn ? /*UIColor(red: 16/255, green: 174/255, blue: 2/255, alpha: 1.0)*/R.color.mehroonColor() : UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1.0)
            self.switchView.backgroundColor = isOn ? /*UIColor(red: 11/255, green: 100/255, blue: 1/255, alpha: 1.0)*/R.color.newBlueColor() : UIColor.white
            self.switchView.layer.borderWidth = isOn ? 0 : 1.0
            self.animate(animate: true)
            self.layoutIfNeeded()
        }).disposed(by: disposeBag)
        self.trailing.isActive = false
    }
    
    @objc private func actTap() {
        let oldValue = switchState.value
        switchState.accept(!oldValue)
    }
    
    func set(state: Bool) {
        switchState.accept(state)
    }
    
    override public func layoutSubviews() {
        switchView.layer.cornerRadius = switchView.frame.size.height/2
        thumbView.layer.cornerRadius=thumbView.frame.height/2
    }
    
    private func animate(animate:Bool){
        let time = animate ? self.animationTime :0
        UIView.animate(withDuration: time, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    /// Call this function on object to add Swip functionality in Switch
    public func configureGesture(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            let oldValue = switchState.value
            if oldValue == false{
                switchState.accept(true)
                print("Swipe Right")
            }
        }
        else if gesture.direction == .left {
            let oldValue = switchState.value
            if oldValue == true{
                switchState.accept(false)
                print("Swipe Left")
            }
        }
    }
    
}
