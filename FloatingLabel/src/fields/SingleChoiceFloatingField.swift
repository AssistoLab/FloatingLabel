//
//  SwitchField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 27/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

@IBDesignable
open class SingleChoiceFloatingField: UIView, FieldType {

	//MARK: - Properties

	//MARK: UI
	fileprivate let choiceLabel = UILabel()
	@objc open let choiceSwitch = UISwitch()

	//MARK: Appearance
	@IBInspectable @objc open dynamic var activeColor = UIColor.blue {
		willSet { onTintColor = newValue }
	}

	@IBInspectable @objc open dynamic var textColor = UIColor.black {
		willSet { choiceLabel.textColor = newValue }
	}

	@IBInspectable @objc open dynamic var textFont = UIFont.systemFont(ofSize: 15) {
		willSet { choiceLabel.font = newValue }
	}

	//MARK: Content
	@IBInspectable @objc open var value: Bool {
		get { return on }
		set { on = newValue }
	}

	@IBInspectable @objc open var text: String! {
		get { return choiceLabel.text }
		set { choiceLabel.text = newValue }
	}

	@objc open var textAlignment: NSTextAlignment {
		get { return choiceLabel.textAlignment }
		set { choiceLabel.textAlignment = newValue }
	}

	@objc open var valueChangedAction: ((Bool) -> Void)?

	fileprivate var didSetupConstraints = false

	//MARK: - Init's

	convenience init() {
		self.init(frame: Frame.initialFrame)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

}

//MARK: - Setup

private extension SingleChoiceFloatingField {

	func setup() {
		setupUI()
		choiceSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
	}

}

//MARK: - UI

extension SingleChoiceFloatingField {

	fileprivate func setupUI() {
		updateConstraintsIfNeeded()

		choiceLabel.textColor = textColor
		choiceLabel.font = textFont
		choiceLabel.numberOfLines = SingleChoiceText.numberOfLines

		onTintColor = activeColor

		#if TARGET_INTERFACE_BUILDER
			text = "A single choice field"
		#endif
	}

	open override func updateConstraints() {
		if !didSetupConstraints {
			setupConstraints()
		}

		didSetupConstraints = true
		super.updateConstraints()
	}

	fileprivate func setupConstraints() {
		addSubview(choiceLabel)
		addSubview(choiceSwitch)

		choiceLabel.translatesAutoresizingMaskIntoConstraints = false
		choiceSwitch.translatesAutoresizingMaskIntoConstraints = false

		let verticalMetrics = ["padding": Constraints.SingleChoiceField.verticalPadding]

		addConstraints(
			format: "H:|-(padding)-[choiceLabel]-(padding)-[choiceSwitch]-(padding)-|",
			metrics: ["padding": Constraints.horizontalPadding],
			views: [
				"choiceLabel": choiceLabel,
				"choiceSwitch": choiceSwitch
			])

		addConstraints(
			format: "V:|-(padding)-[choiceLabel]-(padding)-|",
			metrics: verticalMetrics,
			views: ["choiceLabel": choiceLabel])

		addConstraints(
			format: "V:|-(padding)-[choiceSwitch]-(>=padding)-|",
			metrics: verticalMetrics,
			views: ["choiceSwitch": choiceSwitch])

		choiceSwitch.setContentCompressionResistancePriority(Constraints.SingleChoiceField.switchCompressionResistancePriority, for: .horizontal)
	}

}

//MARK: - Switch

extension SingleChoiceFloatingField {

	public var onTintColor: UIColor! {
		get { return choiceSwitch.onTintColor }
		set { choiceSwitch.onTintColor = newValue }
	}

	override open var tintColor: UIColor? {
		willSet { choiceSwitch.tintColor = newValue }
	}

	public var thumbTintColor: UIColor? {
		get { return choiceSwitch.thumbTintColor }
		set { choiceSwitch.thumbTintColor = newValue }
	}

	public var onImage: UIImage? {
		get { return choiceSwitch.onImage }
		set { choiceSwitch.onImage = newValue }
	}

	public var offImage: UIImage? {
		get { return choiceSwitch.offImage }
		set { choiceSwitch.offImage = newValue }
	}

	public var on: Bool {
		get { return choiceSwitch.isOn }
		set { choiceSwitch.isOn = newValue }
	}

	public func setOn(_ on: Bool, animated: Bool) {
		choiceSwitch.setOn(on, animated: animated)
	}

	@objc
	public func switchValueChanged() {
		valueChangedAction?(on)
	}
}
