//
//  FloatingMultiLineTextField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 5/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

open class FloatingMultiLineTextField: FloatingField {
	
	//MARK: - Properties
	
	//MARK: UI
	internal override var input: InputType! {
		get {
			return textView
		}
		set {
			if let newValue = newValue as? FloatingFieldTextView {
				textView = newValue
			}
		}
	}
	
	open var textView = FloatingFieldTextView()
	
	//MARK: Content
	open weak var delegate: UITextViewDelegate? {
		get { return textView.delegate }
		set { textView.delegate = newValue }
	}
	
	fileprivate var didSetupConstraints = false
	
	//MARK: - Init's
	
	deinit {
		stopListeningToTextView()
	}
	
	convenience init() {
		self.init(frame: Frame.initialFrame)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

//MARK: - Initialization

internal extension FloatingMultiLineTextField {
	
	override func setup() {
		super.setup()
		
		textView.fadeTime = 0
		textView.textContainerInset = .zero
		textView.textContainer.lineFragmentPadding = 0
		
		listenToTextView()
		
		#if TARGET_INTERFACE_BUILDER
			text = "A multiline text view"
		#endif
	}
	
}

//MARK: - TextView

private var textViewKVOContext = 0

internal extension FloatingMultiLineTextField {
	
	@objc
	func textViewTextDidChangeNotification() {
		updateUI(animated: true)
		textView.setContentOffset(.zero, animated: true)
		
		valueChangedAction?(value)
	}
	
	@objc
	func textViewTextDidBeginEditingNotification() {
		updateUI(animated: true)
		
		hasBeenEdited = true
	}
	
	@objc
	func textViewTextDidEndEditingNotification() {
		updateUI(animated: true)
	}
	
	//MARK: - KVO
	
	func listenToTextView() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textViewTextDidBeginEditingNotification),
			name: NSNotification.Name.UITextViewTextDidBeginEditing,
			object: textView)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textViewTextDidChangeNotification),
			name: NSNotification.Name.UITextViewTextDidChange,
			object: textView)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textViewTextDidEndEditingNotification),
			name: NSNotification.Name.UITextViewTextDidEndEditing,
			object: textView)
		
		self.addObserver(self, forKeyPath: "textView.text", options: .new, context: &textViewKVOContext)
	}
	
	func stopListeningToTextView() {
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.UITextViewTextDidBeginEditing,
			object: textView)
		
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.UITextViewTextDidChange,
			object: textView)
		
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.UITextViewTextDidEndEditing,
			object: textView)
		
		self.removeObserver(self, forKeyPath: "textView.text", context: &textViewKVOContext)
	}
	
}

//MARK: - KVO

public extension FloatingMultiLineTextField {
	
	override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if context == &textViewKVOContext
			&& (change?[NSKeyValueChangeKey.newKey] as? String) != nil
		{
			updateUI(animated: true)
		} else {
			super.observeValue(forKeyPath: keyPath!, of: object!, change: change!, context: context)
		}
	}
	
}

//MARK: - IBDesignable

public extension FloatingMultiLineTextField {
	
	#if TARGET_INTERFACE_BUILDER
	override public func intrinsicContentSize() -> CGSize {
	return CGSize(width: UIViewNoIntrinsicMetric, height: 73)
	}
	#endif
	
}
