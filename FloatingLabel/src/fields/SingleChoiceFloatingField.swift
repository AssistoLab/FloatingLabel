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
public class SingleChoiceFloatingField: UIView, FieldType {

	//MARK: - Properties

	//MARK: UI
	private let choiceLabel = UILabel()
	public let choiceSwitch = UISwitch()

	//MARK: Appearance
	@IBInspectable public dynamic var activeColor: UIColor = UIColor.blueColor() {
		willSet { onTintColor = newValue }
	}

	@IBInspectable public dynamic var textColor: UIColor = UIColor.blackColor() {
		willSet { choiceLabel.textColor = newValue }
	}

	@IBInspectable public dynamic var textFont: UIFont = UIFont.systemFontOfSize(15) {
		willSet { choiceLabel.font = newValue }
	}

	//MARK: Content
	@IBInspectable public var value: Bool {
		get { return on }
		set { on = newValue }
	}

	@IBInspectable public var text: String! {
		get { return choiceLabel.text }
		set { choiceLabel.text = newValue }
	}

	public var textAlignment: NSTextAlignment {
		get { return choiceLabel.textAlignment }
		set { choiceLabel.textAlignment = newValue }
	}

	public var valueChangedAction: ((Bool) -> Void)?

	private var didSetupConstraints = false

	//MARK: - Init's

	convenience init() {
		self.init(frame: Frame.InitialFrame)
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
		choiceSwitch.addTarget(self, action: #selector(switchValueChanged), forControlEvents: .ValueChanged)
	}

}

//MARK: - UI

extension SingleChoiceFloatingField {

	private func setupUI() {
		updateConstraintsIfNeeded()

		choiceLabel.textColor = textColor
		choiceLabel.font = textFont
		choiceLabel.numberOfLines = SingleChoiceText.NumberOfLines

		onTintColor = activeColor

		#if TARGET_INTERFACE_BUILDER
			text = "A single choice field"
		#endif
	}

	public override func updateConstraints() {
		if !didSetupConstraints {
			setupConstraints()
		}

		didSetupConstraints = true
		super.updateConstraints()
	}

	private func setupConstraints() {
		addSubview(choiceLabel)
		addSubview(choiceSwitch)

		choiceLabel.translatesAutoresizingMaskIntoConstraints = false
		choiceSwitch.translatesAutoresizingMaskIntoConstraints = false

		let verticalMetrics = ["padding": Constraints.SingleChoiceField.VerticalPadding]

		addConstraints(
			format: "H:|-(padding)-[choiceLabel]-(padding)-[choiceSwitch]-(padding)-|",
			metrics: ["padding": Constraints.HorizontalPadding],
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

		choiceSwitch.setContentCompressionResistancePriority(Constraints.SingleChoiceField.SwitchCompressionResistancePriority, forAxis: .Horizontal)
	}

}

//MARK: - Switch

public extension SingleChoiceFloatingField {

	var onTintColor: UIColor! {
		get { return choiceSwitch.onTintColor }
		set { choiceSwitch.onTintColor = newValue }
	}

	override var tintColor: UIColor? {
		willSet { choiceSwitch.tintColor = newValue }
	}

	var thumbTintColor: UIColor? {
		get { return choiceSwitch.thumbTintColor }
		set { choiceSwitch.thumbTintColor = newValue }
	}

	var onImage: UIImage? {
		get { return choiceSwitch.onImage }
		set { choiceSwitch.onImage = newValue }
	}

	var offImage: UIImage? {
		get { return choiceSwitch.offImage }
		set { choiceSwitch.offImage = newValue }
	}

	var on: Bool {
		get { return choiceSwitch.on }
		set { choiceSwitch.on = newValue }
	}

	func setOn(on: Bool, animated: Bool) {
		choiceSwitch.setOn(on, animated: animated)
	}

	@objc
	func switchValueChanged() {
		valueChangedAction?(on)
	}
}
