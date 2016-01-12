//
//  FloatingFieldTextView.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 5/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal class FloatingFieldTextView: SZTextView {
	
	//MARK: - Init's
	
	init() {
		super.init(frame: CGRectZero, textContainer: nil)
		listenToTextView()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		listenToTextView()
	}
	
	deinit {
		stopListeningToTextView()
	}
	
	//MARK: - Properties
	
	private var shouldUpdateSizeIfNeeded = true
	
}

//MARK: - UIView

extension FloatingFieldTextView {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if shouldUpdateSizeIfNeeded && bounds.size != intrinsicContentSize() {
			invalidateIntrinsicContentSize()
		}
	}
	
	override func intrinsicContentSize() -> CGSize {
		#if TARGET_INTERFACE_BUILDER
			return CGSize(width: UIViewNoIntrinsicMetric, height: 24)
		#else
			return contentSize
		#endif
	}
	
}

//MARK: - Listeners

extension FloatingFieldTextView {
	
	private func listenToTextView() {
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textViewTextDidEndEditingNotification",
			name: UITextViewTextDidEndEditingNotification,
			object: self)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: "textViewTextDidBeginEditingNotification",
			name: UITextViewTextDidBeginEditingNotification,
			object: self)
	}
	
	func stopListeningToTextView() {
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextViewTextDidBeginEditingNotification,
			object: self)
		
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextViewTextDidEndEditingNotification,
			object: self)
	}
	
	@objc
	func textViewTextDidEndEditingNotification() {
		shouldUpdateSizeIfNeeded = false
	}
	
	@objc
	func textViewTextDidBeginEditingNotification() {
		shouldUpdateSizeIfNeeded = true
	}
	
}