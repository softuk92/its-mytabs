//
//  PaymentTypeViewController.swift
//  LoadX Transporter
//
//  Created by Mansoor Ali on 27/08/2021.
//  Copyright © 2021 BIAD Services Ltd. All rights reserved.
//

import UIKit
import Reusable

enum PaymentMethod {
	case debitCard
	case bankTranser
}

class CardSelectionView: UIView {
	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var icon: UIImageView!

	var actionCallback: (() -> Void)?

	override func awakeFromNib() {
		super.awakeFromNib()
	//	self.dropShadow(color: R.color.shadowColor()!, opacity: 0.8, offSet: CGSize(width: 0, height: 3), radius: 4, scale: false)
		self.layer.cornerRadius = 5
		addShadow()

		button.setImage(R.image.unchecked(), for: .normal)
		button.setImage(R.image.checked(), for: .selected)

		let tap = UITapGestureRecognizer(target: self, action: #selector(actTap))
		self.addGestureRecognizer(tap)
	}

	private func addShadow() {
		self.layer.cornerRadius = 6
		self.layer.shadowOpacity = 0.8
		self.layer.shadowOffset = CGSize(width: 0, height: 3)
		self.layer.shadowRadius = 4
		self.layer.shadowColor = R.color.shadowColor()?.cgColor
	}

	@objc private func actTap(_ sender: UIButton) {
		actionCallback?()
	}

	func select() {
//		button.setImage(R.image.checked(), for: .normal)
		button.isSelected = true
		showBorder(for: self)
		icon.image = R.image.checked()
	}

	func deselect() {
		self.layer.borderWidth = 0
//		button.setImage(R.image.unchecked(), for: .normal)
		button.isSelected = false
		icon.image = R.image.unchecked()
	}

	private func showBorder(for view: UIView) {
		view.layer.borderWidth = 1
		view.layer.borderColor = R.color.mehroonColor()?.cgColor
	}
}

class PaymentTypeViewController: UIViewController {

	@IBOutlet weak var debitCardView: CardSelectionView!
	@IBOutlet weak var bankTransferView: CardSelectionView!
	@IBOutlet weak var payNow: UIButton!
	var amount = 0
	var paymentsToPay = [PayToLoadXItme]()

	static func instantiate() -> PaymentTypeViewController {
		let vc = PaymentTypeViewController(nibName: "PaymentTypeViewController", bundle: Bundle.main)
		return vc
	}

	var paymentMethod = PaymentMethod.bankTranser {
		didSet {
			switch paymentMethod {
			case .debitCard:
				debitCardView.select()
				bankTransferView.deselect()
			case .bankTranser:
				bankTransferView.select()
				debitCardView.deselect()
			}
		}
	}

	private func showBorder(for view: UIView) {
		view.layer.borderWidth = 1
		view.layer.borderColor = R.color.mehroonColor()?.cgColor
	}

    override func viewDidLoad() {
        super.viewDidLoad()


		//payment method selection
		paymentMethod = .bankTranser


		debitCardView.actionCallback = { [weak self] in
			self?.paymentMethod = .debitCard
		}

		bankTransferView.actionCallback = { [weak self] in
			self?.paymentMethod = .bankTranser
		}

		//set paynow title
		let buttonTitle = attributedTitle(text1: "Pay Now ", text2: "(Rs. \(amount))")
		payNow.setAttributedTitle(buttonTitle, for: .normal)
//		payNow.titleLabel?.attributedText = buttonTitle
//		payNow.titleLabel?.text = buttonTitle.string


    }

	func attributedTitle(text1: String, text2: String) -> NSAttributedString {
		let text1Attributed = NSAttributedString(string: text1, attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-Light", size: 14)!])
		let text2Attributed = NSAttributedString(string: text2, attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 14)!])
		let mutable = NSMutableAttributedString(attributedString: text1Attributed)
		mutable.append(text2Attributed)
		return mutable
	}


	@IBAction func actPayNow() {
		let vc = UploadReceiptViewController.instantiate()
		vc.paymentMethod = paymentMethod
		vc.paymentsToPay = paymentsToPay
		self.navigationController?.pushViewController(vc, animated: true)
	}

	@IBAction func actBack() {
		self.navigationController?.popViewController(animated: true)
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
