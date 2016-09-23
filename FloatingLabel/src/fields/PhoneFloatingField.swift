
//
//  PhoneFloatingField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 17/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

@IBDesignable
open class PhoneFloatingField: UIView, TextFieldType, Validatable {
	
	//MARK: - Properties
	
	//MARK: UI
	open let prefixField = ActionFloatingField() // eg. +32
	open let suffixField = FloatingTextField() // eg. 123 45 67 89
	
	//MARK: Constraints
	fileprivate var prefixWidthConstraint: NSLayoutConstraint!
	
	//MARK: Content
	open var value: String? {
		get { return text }
		set { text = newValue }
	}
	
	open var valueChangedAction: ((String?) -> Void)?
	
	@IBInspectable open var text: String? {
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
	
	open var phoneNumber: String? {
		var phoneNumber = ""
		
		if let prefix = prefixField.text {
			phoneNumber += prefix
		}
		
		if let suffix = suffixField.text {
			phoneNumber += suffix
		}
		
		return phoneNumber.isEmpty ? nil : phoneNumber
	}
	
	open var prefix: String? {
		get {
			return prefixField.text
		}
		set {
			prefixField.text = newValue
			prefixChanged()
		}
	}
	
	open var suffix: String? {
		get { return suffixField.text }
		set { suffixField.text = newValue }
	}
	
	@IBInspectable open var prefixPlaceholder: String? {
		get {
			return prefixField.placeholder
		}
		set {
			prefixField.placeholder = newValue
			prefixChanged()
		}
	}
	
	@IBInspectable open var suffixPlaceholder: String? {
		get { return suffixField.placeholder }
		set { suffixField.placeholder = newValue }
	}
	
	@IBInspectable open var helpText: String? {
		get { return suffixField.helpText }
		set { suffixField.helpText = newValue }
	}
	
	@IBInspectable open var errorText: String? {
		willSet { validations = [Validation(.phoneNumber, message: newValue)] }
	}
	
	open var validations = [Validation(.phoneNumber)]
	
	open var validation: Validation? {
		get { return validations.first }
		set { validations.replaceFirstItemBy(newValue) }
	}
	
	open var isValid: Bool {
		if !suffixField.hasBeenEdited {
			return true
		} else {
			return checkValidity(text: phoneNumber, validations: validations, level: .error).isValid
		}
	}
	
	open var isEditing: Bool {
		return suffixField.isEditing
	}
	
	open var prefixHandler: Closure! {
		get { return prefixField.action }
		set { prefixField.action = newValue }
	}
	
	fileprivate var didSetupConstraints = false
	
	//MARK: - Init's
	
	convenience init() {
		self.init(frame: Frame.initialFrame)
	}
	
	public override init(frame: CGRect) {
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
	
	fileprivate func setupUI() {
		updateConstraintsIfNeeded()
		setupFields()
	}
	
	fileprivate func setupFields() {
		prefixField.autocorrectionType = .no
		prefixField.spellCheckingType = .no
		prefixField.rightView = UIImageView(image: Icon.Arrow.image().template())
		prefixField.rightViewMode = .always
		prefixField.validation = Validation({ [unowned self] text in
			if !text.isEmpty,
				let suffix = self.suffixField.text
				, !suffix.isEmpty
			{
				self.suffixField.validate()
			}
			
			return true
		})
		
		suffixField.autocorrectionType = .no
		suffixField.spellCheckingType = .no
		suffixField.keyboardType = .numberPad
		suffixField.valueChangedAction = { [unowned self] value in
			self.valueChangedAction?(value)
		}
		suffixField.validation = Validation(
			{ [unowned self] _ in
				return DataValidationHelper.isValid(phone: self.phoneNumber ?? "")
			},
			message: validation?.message ?? Validation.messages[.phoneNumber]?.message ?? "")
		
		#if TARGET_INTERFACE_BUILDER
			prefixPlaceholder = "Prefix"
			suffixPlaceholder = "Phone number"
			text = "+32123456"
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
		addSubview(prefixField)
		addSubview(suffixField)
		
		prefixField.translatesAutoresizingMaskIntoConstraints = false
		suffixField.translatesAutoresizingMaskIntoConstraints = false
		
		addConstraints(format: "H:|[prefixField][suffixField]|", views: ["prefixField": prefixField, "suffixField": suffixField])
		addConstraints(format: "V:|[prefixField]-(>=0)-|", views: ["prefixField": prefixField])
		addConstraints(format: "V:|[suffixField]-(>=0)-|", views: ["suffixField": suffixField])
		
		prefixWidthConstraint = NSLayoutConstraint(
			item: prefixField,
			attribute: .width,
			relatedBy: .equal,
			toItem: nil,
			attribute: .notAnAttribute,
			multiplier: 1,
			constant: prefixField.contentWidth())
		
		prefixField.addConstraint(prefixWidthConstraint)
		
		prefixField.setContentCompressionResistancePriority(Constraints.PhoneField.Prefix.compressionResistancePriority, for: .horizontal)
		prefixField.setContentHuggingPriority(Constraints.PhoneField.Prefix.verticalHuggingPriority, for: .vertical)
		suffixField.setContentHuggingPriority(Constraints.PhoneField.Prefix.verticalHuggingPriority, for: .vertical)
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
			message: Validation.messages[.required]?.message),
			at: 0)
		
		suffixField.validations.insert(Validation(.required), at: 0)
	}
	
}

//MARK: - Responder

extension PhoneFloatingField {
	
	override open var canBecomeFirstResponder: Bool {
		return suffixField.canBecomeFirstResponder
	}
	
	override open func becomeFirstResponder() -> Bool {
		return suffixField.becomeFirstResponder()
	}
	
	override open func resignFirstResponder() -> Bool {
		return suffixField.resignFirstResponder()
	}
	
	override open var isFirstResponder: Bool {
		return suffixField.isFirstResponder
	}
	
	override open var canResignFirstResponder: Bool {
		return suffixField.canResignFirstResponder
	}
	
}

//MARK: - UIView (UIConstraintBasedLayoutLayering)

public extension PhoneFloatingField {
	
	override open func forBaselineLayout() -> UIView {
		return suffixField.forBaselineLayout()
	}
	
}
