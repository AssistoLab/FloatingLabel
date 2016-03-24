//
//  FloatingFieldTextView.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 5/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit
import SZTextView

public class FloatingFieldTextView: SZTextView {
	
	//MARK: - Init's
	
	init() {
		super.init(frame: CGRectZero, textContainer: nil)
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
	
	private var shouldUpdateSizeIfNeeded = true
	
}

//MARK: - UIView

public extension FloatingFieldTextView {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if shouldUpdateSizeIfNeeded && bounds.size != intrinsicContentSize() {
			invalidateIntrinsicContentSize()
			parentCollectionView()?.collectionViewLayout.invalidateLayout()
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
			selector: #selector(textViewTextDidBeginEditingNotification),
			name: UITextViewTextDidBeginEditingNotification,
			object: self)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: #selector(textViewTextDidChangeNotification),
			name: UITextViewTextDidChangeNotification,
			object: self)
		
		NSNotificationCenter.defaultCenter().addObserver(
			self,
			selector: #selector(textViewTextDidEndEditingNotification),
			name: UITextViewTextDidEndEditingNotification,
			object: self)
		
		self.addObserver(self, forKeyPath: "text", options: .New, context: &textKVOContext)
	}
	
	func stopListeningToTextView() {
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextViewTextDidBeginEditingNotification,
			object: self)
		
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextViewTextDidChangeNotification,
			object: self)
		
		NSNotificationCenter.defaultCenter().removeObserver(
			self,
			name: UITextViewTextDidEndEditingNotification,
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
	
	override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if context == &textKVOContext
			&& (change?[NSKeyValueChangeNewKey] as? String) != nil
		{
			parentCollectionView()?.collectionViewLayout.invalidateLayout()
		}
		
		super.observeValueForKeyPath(keyPath!, ofObject: object!, change: change!, context: context)
	}
	
}