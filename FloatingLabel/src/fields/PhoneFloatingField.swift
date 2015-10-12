//
//  PhoneFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 17/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

@IBDesignable
public class PhoneFloatingField: UIView, TextFieldType, Validatable {
	
	//MARK: - Properties
	
	//MARK: UI
	public let prefixField = ActionFloatingField() // eg. +32
	public let suffixField = FloatingTextField() // eg. 123 45 67 89
	
	//MARK: Constraints
	private var prefixWidthConstraint: NSLayoutConstraint!
	
	//MARK: Content
	public var value: String? {
		get { return text }
		set { text = newValue }
	}
	
	public var valueChangedAction: ((String?) -> Void)?
	
	@IBInspectable public var text: String? {
		get {
			return phoneNumber
		}
		set {
			if let newValue = newValue {
				let (prefix, suffix) = PhoneHelper.componentsFromNumber(newValue)
				
				if let prefix = prefix {
					self.prefix = "+\(prefix)"
				} else {
					self.prefix = ""
				}
				
				if let suffix = suffix {
					self.suffix = suffix
				} else {
					self.suffix = ""
				}
			} else {
				prefix = ""
				suffix = ""
			}
		}
	}
	
	public var phoneNumber: String? {
		var phoneNumber = ""
		
		if let prefix = prefixField.text {
			phoneNumber += prefix
		}
		
		if let suffix = suffixField.text {
			phoneNumber += suffix
		}
		
		return phoneNumber.isEmpty ? nil : phoneNumber
	}
	
	public var prefix: String? {
		get {
			return prefixField.text
		}
		set {
			prefixField.text = newValue
			prefixChanged()
		}
	}
	
	public var suffix: String? {
		get { return suffixField.text }
		set { suffixField.text = newValue }
	}
	
	@IBInspectable public var prefixPlaceholder: String? {
		get {
			return prefixField.placeholder
		}
		set {
			prefixField.placeholder = newValue
			prefixChanged()
		}
	}
	
	@IBInspectable public var suffixPlaceholder: String? {
		get { return suffixField.placeholder }
		set { suffixField.placeholder = newValue }
	}
	
	@IBInspectable public var helpText: String? {
		get { return suffixField.helpText }
		set { suffixField.helpText = newValue }
	}
	
	@IBInspectable public var errorText: String? {
		willSet { validations = [Validation(.PhoneNumber, message: newValue)] }
	}
	
	public var validations = [Validation(.PhoneNumber)]
	
	public var validation: Validation? {
		get { return validations.first }
		set { validations.replaceFirstItemBy(newValue) }
	}
	
	public var isValid: Bool {
		if !suffixField.hasBeenEdited {
			return true
		} else {
			return checkValidity(text: phoneNumber, validations: validations, level: .Error).isValid
		}
	}
	
	public var isEditing: Bool {
		return suffixField.isEditing
	}
	
	public var prefixHandler: Closure! {
		get { return prefixField.action }
		set { prefixField.action = newValue }
	}
	
	private var didSetupConstraints = false
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: Frame.InitialFrame)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI()
	}
	
}

//MARK: - UI

extension PhoneFloatingField {
	
	private func setupUI() {
		updateConstraintsIfNeeded()
		setupFields()
	}
	
	private func setupFields() {
		prefixField.autocorrectionType = .No
		prefixField.spellCheckingType = .No
		prefixField.rightView = UIImageView(image: Icon.Arrow.image().template())
		prefixField.rightViewMode = .Always
		prefixField.validation = Validation({ [unowned self] text in
			if !text.isEmpty,
				let suffix = self.suffixField.text
				where !suffix.isEmpty
			{
				self.suffixField.validate()
			}
			
			return true
		})
		
		suffixField.autocorrectionType = .No
		suffixField.spellCheckingType = .No
		suffixField.keyboardType = .NumberPad
		suffixField.valueChangedAction = { [unowned self] value in
			print("test")
			self.valueChangedAction?(value)
		}
		suffixField.validation = Validation(
			{ [unowned self] _ in
				return DataValidationHelper.isPhoneNumberValid(self.phoneNumber ?? "")
			},
			message: validation?.message ?? Validation.messages[.PhoneNumber]?.message ?? "")
		
		#if TARGET_INTERFACE_BUILDER
			prefixPlaceholder = "Prefix"
			suffixPlaceholder = "Phone number"
			text = "+32123456"
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
		addSubview(prefixField)
		addSubview(suffixField)
		
		prefixField.translatesAutoresizingMaskIntoConstraints = false
		suffixField.translatesAutoresizingMaskIntoConstraints = false
		
		addConstraints(format: "H:|[prefixField][suffixField]|", views: ["prefixField": prefixField, "suffixField": suffixField])
		addConstraints(format: "V:|[prefixField]-(>=0)-|", views: ["prefixField": prefixField])
		addConstraints(format: "V:|[suffixField]-(>=0)-|", views: ["suffixField": suffixField])
		
		prefixWidthConstraint = NSLayoutConstraint(
			item: prefixField,
			attribute: .Width,
			relatedBy: .Equal,
			toItem: nil,
			attribute: .NotAnAttribute,
			multiplier: 1,
			constant: prefixField.contentWidth())
		
		prefixField.addConstraint(prefixWidthConstraint)
		
		prefixField.setContentCompressionResistancePriority(Constraints.PhoneField.Prefix.CompressionResistancePriority, forAxis: .Horizontal)
		prefixField.setContentHuggingPriority(Constraints.PhoneField.Prefix.VerticalHuggingPriority, forAxis: .Vertical)
		suffixField.setContentHuggingPriority(Constraints.PhoneField.Prefix.VerticalHuggingPriority, forAxis: .Vertical)
	}
	
}

//MARK: - Prefix/Suffix handling

private extension PhoneFloatingField {
	
	func prefixChanged() {
		prefixWidthConstraint.constant = prefixField.contentWidth()
	}
	
}

//MARK: - Validation

public extension PhoneFloatingField {
	
	public func validate() {
		suffixField.validate()
	}
	
	public func makeSuffixRequired() {
		validations.insert(Validation(
			{ [unowned self] value in
				if let text = self.suffixField.text {
					return !text.isEmpty
				} else {
					return false
				}
			},
			message: Validation.messages[.Required]?.message),
			atIndex: 0)
		
		suffixField.validations.insert(Validation(.Required), atIndex: 0)
	}
	
}

//MARK: - Responder

public extension PhoneFloatingField {
	
	override func canBecomeFirstResponder() -> Bool {
		return suffixField.canBecomeFirstResponder()
	}
	
	override func becomeFirstResponder() -> Bool {
		return suffixField.becomeFirstResponder()
	}
	
	override func resignFirstResponder() -> Bool {
		return suffixField.resignFirstResponder()
	}
	
	override func isFirstResponder() -> Bool {
		return suffixField.isFirstResponder()
	}
	
	override func canResignFirstResponder() -> Bool {
		return suffixField.canResignFirstResponder()
	}
	
}

//MARK: - UIView (UIConstraintBasedLayoutLayering)

public extension PhoneFloatingField {
	
	override func viewForBaselineLayout() -> UIView {
		return suffixField.viewForBaselineLayout()
	}
	
}