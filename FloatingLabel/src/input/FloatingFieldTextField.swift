//
//  FloatingFieldTextField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 23/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal class FloatingFieldTextField: UITextField {
	
	var showCursor = true
	var enableContextMenu = true
	var enableSelection = true
	
}

//MARK: - Customization

extension FloatingFieldTextField {
	
	internal func disableEditionByUser() {
		showCursor = false
		enableContextMenu = false
		enableSelection = false
	}
	
	// show/hide cursor
	override func caretRectForPosition(position: UITextPosition!) -> CGRect {
		if showCursor {
			return super.caretRectForPosition(position)
		} else {
			return CGRectZero
		}
	}
	
	// enable/disable context menu
	override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
		if enableContextMenu {
			return super.canPerformAction(action, withSender: sender)
		} else {
			return false
		}
	}
	
	// enable/disable text selection
	override func selectionRectsForRange(range: UITextRange) -> [AnyObject] {
		if enableSelection {
			return super.selectionRectsForRange(range)
		} else {
			return []
		}
	}
	
	// enable/disable magnifier
	override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
		if !enableSelection
			&& (gestureRecognizer is UILongPressGestureRecognizer
				|| (gestureRecognizer is UITapGestureRecognizer
					&& (gestureRecognizer as! UITapGestureRecognizer).numberOfTapsRequired == 2))
		{
			return false
		} else {
			return super.gestureRecognizerShouldBegin(gestureRecognizer)
		}
	}
	
}