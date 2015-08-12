//
//  FloatingTextField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 4/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class FloatingTextField: FloatingField {
	
	internal override var input: InputType! {
		get {
			return textField
		}
		set {
			if let newValue = newValue as? FloatingFieldTextField {
				textField = newValue
			}
		}
	}
	
	internal var textField = FloatingFieldTextField()
	
	public weak var delegate: UITextFieldDelegate? {
		get { return textField.delegate }
		set { textField.delegate = newValue }
	}
	
	//MARK: - Deinit
	
	deinit {
		stopListeningToTextField()
	}
	
}

//MARK: - Initialization

internal extension FloatingTextField {
	
	override func setup() {
		super.setup()
		
		listenToTextField()
	}
	
}

//MARK: - Update UI

internal extension FloatingTextField {
	
	override func updateUI(#animated: Bool) {
		super.updateUI(animated: animated)
		
		let changes: Closure = { [unowned self] in
			rightView?.tintColor = separatorLine.backgroundColor
		}
		
		applyChanges(changes, animated)
	}
	
}

//MARK: - TextField

internal extension FloatingTextField {
	
	@objc
	func textFieldTextDidChangeNotification() {
		updateUI(animated: true)
	}
	
	@objc
	func textFieldTextDidBeginEditingNotification() {
		updateUI(animated: true)
		
		hasBeenEdited = true
		valueChangedAction?(value)
	}
	
	@objc
	func textFieldTextDidEndEditingNotification() {
		updateUI(animated: true)
	}
	
	//MARK: - KVO
	
	func listenToTextField() {
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textFieldTextDidBeginEditingNotification",
			name: UITextFieldTextDidBeginEditingNotification,
			object: textField)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textFieldTextDidChangeNotification",
			name: UITextFieldTextDidChangeNotification,
			object: textField)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textFieldTextDidEndEditingNotification",
			name: UITextFieldTextDidEndEditingNotification,
			object: textField)
	}
	
	func stopListeningToTextField() {
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextFieldTextDidBeginEditingNotification,
			object: textField)
		
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextFieldTextDidChangeNotification,
			object: textField)
		
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextFieldTextDidEndEditingNotification,
			object: textField)
	}
	
}