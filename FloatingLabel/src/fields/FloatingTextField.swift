//
//  FloatingTextField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 4/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import DropDown

open class FloatingTextField: FloatingField {
	
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
	
	open var textField = FloatingFieldTextField()
	
	open weak var delegate: UITextFieldDelegate? {
		get { return textField.delegate }
		set { textField.delegate = newValue }
	}
	
	//MARK: - Deinit
	
	deinit {
		stopListeningToTextField()
	}
	
}

//MARK: - Initialization

public extension FloatingTextField {
	
	override func setup() {
		super.setup()
		
		listenToTextField()
	}
	
}

//MARK: - Update UI

public extension FloatingTextField {
	
	override func updateUI(animated: Bool) {
		super.updateUI(animated: animated)
		
		let changes: Closure = {
			self.rightView?.tintColor = self.separatorLine.backgroundColor
		}
		
		applyChanges(changes, animated)
	}
	
}

//MARK: - TextField

private var textFieldKVOContext = 0

extension FloatingTextField {
	
	@objc
	public func textFieldTextDidChangeNotification() {
		updateUI(animated: true)
		valueChangedAction?(value)
	}
	
	@objc
	public func textFieldTextDidBeginEditingNotification() {
		updateUI(animated: true)
		hasBeenEdited = true
	}
	
	@objc
	public func textFieldTextDidEndEditingNotification() {
		updateUI(animated: true)
	}
	
	//MARK: - KVO
	
	func listenToTextField() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textFieldTextDidBeginEditingNotification),
			name: NSNotification.Name.UITextFieldTextDidBeginEditing,
			object: textField)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textFieldTextDidChangeNotification),
			name: NSNotification.Name.UITextFieldTextDidChange,
			object: textField)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textFieldTextDidEndEditingNotification),
			name: NSNotification.Name.UITextFieldTextDidEndEditing,
			object: textField)
		
		self.addObserver(self, forKeyPath: "textField.text", options: .new, context: &textFieldKVOContext)
	}
	
	func stopListeningToTextField() {
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.UITextFieldTextDidBeginEditing,
			object: textField)
		
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.UITextFieldTextDidChange,
			object: textField)
		
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.UITextFieldTextDidEndEditing,
			object: textField)
		
		self.removeObserver(self, forKeyPath: "textField.text", context: &textFieldKVOContext)
	}
	
}

//MARK: - KVO

public extension FloatingField {
	
	override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if context == &textFieldKVOContext
			&& (change?[NSKeyValueChangeKey.newKey] as? String) != nil
		{
			updateUI(animated: true)
		} else {
			super.observeValue(forKeyPath: keyPath!, of: object!, change: change!, context: context)
		}
	}
	
}
