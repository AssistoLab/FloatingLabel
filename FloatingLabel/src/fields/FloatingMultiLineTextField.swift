//
//  FloatingMultiLineTextField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 5/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

public class FloatingMultiLineTextField: FloatingField {
	
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
	
	internal var textView = FloatingFieldTextView()
	
	//MARK: Content
	public weak var delegate: UITextViewDelegate? {
		get { return textView.delegate }
		set { textView.delegate = newValue }
	}
	
	private var didSetupConstraints = false
	
	//MARK: - Init's
	
	deinit {
		stopListeningToTextView()
	}
	
	convenience init() {
		self.init(frame: Frame.InitialFrame)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}

//MARK: - Initialization

internal extension FloatingMultiLineTextField {
	
	override func setup() {
		super.setup()
		
		textView.fadeTime = 0
		textView.textContainerInset = UIEdgeInsetsZero
		textView.textContainer.lineFragmentPadding = 0
		
		listenToTextView()
		
		#if TARGET_INTERFACE_BUILDER
			text = "A multiline text view"
		#endif
	}
	
}

//MARK: - TextView

internal extension FloatingMultiLineTextField {
	
	@objc
	func textViewTextDidChangeNotification() {
		textView.setContentOffset(CGPointZero, animated: true)
		updateUI(animated: true)
	}
	
	@objc
	func textViewTextDidBeginEditingNotification() {
		updateUI(animated: true)
		
		hasBeenEdited = true
		valueChangedAction?(value)
	}
	
	@objc
	func textViewTextDidEndEditingNotification() {
		updateUI(animated: true)
	}
	
	//MARK: - KVO
	
	func listenToTextView() {
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textViewTextDidBeginEditingNotification",
			name: UITextViewTextDidBeginEditingNotification,
			object: textView)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textViewTextDidChangeNotification",
			name: UITextViewTextDidChangeNotification,
			object: textView)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textViewTextDidEndEditingNotification",
			name: UITextViewTextDidEndEditingNotification,
			object: textView)
	}
	
	func stopListeningToTextView() {
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextViewTextDidBeginEditingNotification,
			object: textView)
		
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextViewTextDidChangeNotification,
			object: textView)
		
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextViewTextDidEndEditingNotification,
			object: textView)
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