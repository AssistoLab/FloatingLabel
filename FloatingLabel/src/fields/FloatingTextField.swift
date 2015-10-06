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
	
	override func updateUI(animated animated: Bool) {
		super.updateUI(animated: animated)
		
		let changes: Closure = {
			rightView?.tintColor = separatorLine.backgroundColor
		}
		
		applyChanges(changes, animated)
	}
	
}

//MARK: - TextField

private var textFieldKVOContext = 0

internal extension FloatingTextField {
	
	@objc
	func textFieldTextDidChangeNotification() {
		updateUI(animated: true)
		valueChangedAction?(value)
	}
	
	@objc
	func textFieldTextDidBeginEditingNotification() {
		updateUI(animated: true)
		hasBeenEdited = true
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
		
		self.addObserver(self, forKeyPath: "textField.text", options: .New, context: &textFieldKVOContext)
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
		
		self.removeObserver(self, forKeyPath: "textField.text", context: &textFieldKVOContext)
	}
	
}

//MARK: - KVO

public extension FloatingField {
	
	override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if context == &textFieldKVOContext
			&& (change?[NSKeyValueChangeNewKey] as? String) != nil
		{
			updateUI(animated: true)
		} else {
			super.observeValueForKeyPath(keyPath!, ofObject: object!, change: change!, context: context)
		}
	}
	
}