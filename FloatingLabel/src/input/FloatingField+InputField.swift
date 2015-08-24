//
//  FloatingField+UITextField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 15/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

//MARK: - Properties

public extension FloatingField {
	
	@IBInspectable var text: String! {
		get {
			return input.__text
		}
		set {
			if newValue != text {
				input.__text = newValue
				hasBeenEdited = true
				updateUI(animated: true)
			}
		}
	}
	
	@IBInspectable var placeholder: String? {
		get {
			return input.__placeholder
		}
		set {
			input.__placeholder = newValue
			floatingLabel.text = newValue
		}
	}
	
	var textAlignment: NSTextAlignment {
		get {
			return input.__textAlignment
		}
		set {
			input.__textAlignment = newValue
			floatingLabel.textAlignment = newValue
			helperLabel.textAlignment = newValue
		}
	}
	
}

public extension FloatingTextField {
	
	var minimumFontSize: CGFloat {
		get { return textField.minimumFontSize }
		set { textField.minimumFontSize = newValue }
	}
	
	var adjustsFontSizeToFitWidth: Bool {
		get { return textField.adjustsFontSizeToFitWidth }
		set { textField.adjustsFontSizeToFitWidth = newValue }
	}
	
	var rightView: UIView? {
		get { return textField.rightView }
		set { textField.rightView = newValue }
	}
	
	var rightViewMode: UITextFieldViewMode {
		get { return textField.rightViewMode }
		set { textField.rightViewMode = newValue }
	}
	
}

//MARK: - Responder

public extension FloatingField {
	
	override func canBecomeFirstResponder() -> Bool {
		return input.canBecomeFirstResponder()
	}
	
	override func becomeFirstResponder() -> Bool {
		return input.becomeFirstResponder()
	}
	
	override func resignFirstResponder() -> Bool {
		return input.resignFirstResponder()
	}
	
	override func isFirstResponder() -> Bool {
		return input.isFirstResponder()
	}
	
	override func canResignFirstResponder() -> Bool {
		return input.canResignFirstResponder()
	}
	
}

//MARK: - UITextInputTraits

extension FloatingField: UITextInputTraits {
	
	public var autocapitalizationType: UITextAutocapitalizationType {
		get { return input.__autocapitalizationType }
		set { input.__autocapitalizationType = newValue }
	}
	
	public var autocorrectionType: UITextAutocorrectionType {
		get { return input.__autocorrectionType }
		set { input.__autocorrectionType = newValue }
	}
	
	public var spellCheckingType: UITextSpellCheckingType {
		get { return input.__spellCheckingType }
		set { input.__spellCheckingType = newValue }
	}
	
	public var keyboardType: UIKeyboardType {
		get { return input.__keyboardType }
		set { input.__keyboardType = newValue }
	}
	
	public var keyboardAppearance: UIKeyboardAppearance {
		get { return input.__keyboardAppearance }
		set { input.__keyboardAppearance = newValue }
	}
	
	public var returnKeyType: UIReturnKeyType {
		get { return input.__returnKeyType }
		set { input.__returnKeyType = newValue }
	}
	
	public var enablesReturnKeyAutomatically: Bool {
		get { return input.__enablesReturnKeyAutomatically }
		set { input.__enablesReturnKeyAutomatically = newValue }
	}
	
	public var passwordModeEnabled: Bool {
		get { return input.__secureTextEntry }
		set { input.__secureTextEntry = newValue }
	}
	
}