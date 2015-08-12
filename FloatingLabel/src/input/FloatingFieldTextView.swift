//
//  FloatingFieldTextView.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 5/08/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal class FloatingFieldTextView: SZTextView {
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		if bounds.size != intrinsicContentSize() {
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