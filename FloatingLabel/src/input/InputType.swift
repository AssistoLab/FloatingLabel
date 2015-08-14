//
//  FloatingFieldInput.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 4/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal protocol InputType {
	
	//HACK: doesn't work without the leadings "__". It's a weird compilator bug.
	
	var __text: String! { get set }
	var __placeholder: String? { get set }
	var __editing: Bool { get }
	var __isEmpty: Bool { get }
	var __inputView: UIView? { get set }
	var __font: UIFont! { get set }
	var __textColor: UIColor! { get set }
	var __tintColor: UIColor! { get set }
	var __textAlignment: NSTextAlignment { get set }
	
	var __autocapitalizationType: UITextAutocapitalizationType { get set }
	var __autocorrectionType: UITextAutocorrectionType { get set }
	var __spellCheckingType: UITextSpellCheckingType { get set }
	var __keyboardType: UIKeyboardType { get set }
	var __keyboardAppearance: UIKeyboardAppearance { get set }
	var __returnKeyType: UIReturnKeyType { get set }
	var __enablesReturnKeyAutomatically: Bool { get set }
	var __secureTextEntry: Bool { get set }
	
	func viewForBaselineLayout() -> UIView?
	func intrinsicContentSize() -> CGSize
	func invalidateIntrinsicContentSize()
	func sizeToFit()
	func canBecomeFirstResponder() -> Bool
	func becomeFirstResponder() -> Bool
	func resignFirstResponder() -> Bool
	func isFirstResponder() -> Bool
	func canResignFirstResponder() -> Bool
	
}

extension FloatingFieldTextField: InputType {
	
	var __text: String! {
		get { return text }
		set { text = newValue }
	}
	
	var __placeholder: String? {
		get { return placeholder }
		set { placeholder = newValue }
	}
	
	var __editing: Bool {
		return editing
	}
	
	var __isEmpty: Bool {
		return text?.isEmpty ?? false
	}
	
	var __inputView: UIView? {
		get { return inputView }
		set { inputView = newValue }
	}
	
	var __font: UIFont! {
		get { return font }
		set { font = newValue }
	}
	
	var __textColor: UIColor! {
		get { return textColor }
		set { textColor = newValue }
	}
	
	var __tintColor: UIColor! {
		get { return tintColor }
		set { tintColor = newValue }
	}
	
	var __textAlignment: NSTextAlignment {
		get { return textAlignment }
		set { textAlignment = newValue }
	}
	
	var __autocapitalizationType: UITextAutocapitalizationType {
		get { return autocapitalizationType }
		set { autocapitalizationType = newValue }
	}
	
	var __autocorrectionType: UITextAutocorrectionType {
		get { return autocorrectionType }
		set { autocorrectionType = newValue }
	}
	
	var __spellCheckingType: UITextSpellCheckingType {
		get { return spellCheckingType }
		set { spellCheckingType = newValue }
	}
	
	var __keyboardType: UIKeyboardType {
		get { return keyboardType }
		set { keyboardType = newValue }
	}
	
	var __keyboardAppearance: UIKeyboardAppearance {
		get { return keyboardAppearance }
		set { keyboardAppearance = newValue }
	}
	
	var __returnKeyType: UIReturnKeyType {
		get { return returnKeyType }
		set { returnKeyType = newValue }
	}
	
	var __enablesReturnKeyAutomatically: Bool {
		get { return enablesReturnKeyAutomatically }
		set { enablesReturnKeyAutomatically = newValue }
	}
	
	var __secureTextEntry: Bool {
		get { return secureTextEntry }
		set { secureTextEntry = newValue }
	}
	
}

extension FloatingFieldTextView: InputType {
	
	var __text: String! {
		get { return text }
		set { text = newValue }
	}
	
	var __placeholder: String? {
		get { return placeholder }
		set { placeholder = newValue }
	}
	
	var __editing: Bool {
		return isFirstResponder()
	}
	
	var __isEmpty: Bool {
		return text?.isEmpty ?? false
	}
	
	var __inputView: UIView? {
		get { return inputView }
		set { inputView = newValue }
	}
	
	var __font: UIFont! {
		get { return font }
		set { font = newValue }
	}
	
	var __textColor: UIColor! {
		get { return textColor }
		set { textColor = newValue }
	}
	
	var __tintColor: UIColor! {
		get { return tintColor }
		set { tintColor = newValue }
	}
	
	var __textAlignment: NSTextAlignment {
		get { return textAlignment }
		set { textAlignment = newValue }
	}
	
	var __autocapitalizationType: UITextAutocapitalizationType {
		get { return autocapitalizationType }
		set { autocapitalizationType = newValue }
	}
	
	var __autocorrectionType: UITextAutocorrectionType {
		get { return autocorrectionType }
		set { autocorrectionType = newValue }
	}
	
	var __spellCheckingType: UITextSpellCheckingType {
		get { return spellCheckingType }
		set { spellCheckingType = newValue }
	}
	
	var __keyboardType: UIKeyboardType {
		get { return keyboardType }
		set { keyboardType = newValue }
	}
	
	var __keyboardAppearance: UIKeyboardAppearance {
		get { return keyboardAppearance }
		set { keyboardAppearance = newValue }
	}
	
	var __returnKeyType: UIReturnKeyType {
		get { return returnKeyType }
		set { returnKeyType = newValue }
	}
	
	var __enablesReturnKeyAutomatically: Bool {
		get { return enablesReturnKeyAutomatically }
		set { enablesReturnKeyAutomatically = newValue }
	}
	
	var __secureTextEntry: Bool {
		get { return secureTextEntry }
		set { secureTextEntry = newValue }
	}
	
}