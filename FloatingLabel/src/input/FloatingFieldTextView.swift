//
//  FloatingFieldTextView.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 5/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import SZTextView

open class FloatingFieldTextView: SZTextView {
	
	//MARK: - Init's
	
	init() {
		super.init(frame: .zero, textContainer: nil)
		listenToTextView()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		listenToTextView()
	}
	
	deinit {
		stopListeningToTextView()
	}
	
	//MARK: - Properties
	
	fileprivate var shouldUpdateSizeIfNeeded = true
	
}

//MARK: - UIView

extension FloatingFieldTextView {
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		
		if shouldUpdateSizeIfNeeded && bounds.size != intrinsicContentSize {
			invalidateIntrinsicContentSize()
			parentCollectionView()?.collectionViewLayout.invalidateLayout()
		}
	}
	
	override open var intrinsicContentSize: CGSize {
		#if TARGET_INTERFACE_BUILDER
			return CGSize(width: UIViewNoIntrinsicMetric, height: 24)
		#else
			return contentSize
		#endif
	}
	
}

//MARK: - Listeners

extension FloatingFieldTextView {
	
	fileprivate func listenToTextView() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textViewTextDidBeginEditingNotification),
			name: NSNotification.Name.UITextViewTextDidBeginEditing,
			object: self)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textViewTextDidChangeNotification),
			name: NSNotification.Name.UITextViewTextDidChange,
			object: self)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(textViewTextDidEndEditingNotification),
			name: NSNotification.Name.UITextViewTextDidEndEditing,
			object: self)
		
		self.addObserver(self, forKeyPath: "text", options: .new, context: &textKVOContext)
	}
	
	func stopListeningToTextView() {
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.UITextViewTextDidBeginEditing,
			object: self)
		
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.UITextViewTextDidChange,
			object: self)
		
		NotificationCenter.default.removeObserver(
			self,
			name: NSNotification.Name.UITextViewTextDidEndEditing,
			object: self)
		
		self.removeObserver(self, forKeyPath: "text", context: &textKVOContext)
	}
	
	@objc
	func textViewTextDidEndEditingNotification() {
		shouldUpdateSizeIfNeeded = false
		parentCollectionView()?.collectionViewLayout.invalidateLayout()
	}
	
	@objc
	func textViewTextDidBeginEditingNotification() {
		shouldUpdateSizeIfNeeded = true
	}
	
	@objc
	func textViewTextDidChangeNotification() {
		shouldUpdateSizeIfNeeded = true
		parentCollectionView()?.collectionViewLayout.invalidateLayout()
	}
	
}

//MARK: - KVO

private var textKVOContext = 0

extension FloatingFieldTextView {
	
	override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if context == &textKVOContext
			&& (change?[NSKeyValueChangeKey.newKey] as? String) != nil
		{
			parentCollectionView()?.collectionViewLayout.invalidateLayout()
		}
		
		super.observeValue(forKeyPath: keyPath!, of: object!, change: change!, context: context)
	}
	
}
