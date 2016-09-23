//
//  FloatingFieldTextField.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 23/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

open class FloatingFieldTextField: UITextField {
	
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
	override open func caretRect(for position: UITextPosition) -> CGRect {
		if showCursor {
			return super.caretRect(for: position)
		} else {
			return .zero
		}
	}
	
	// enable/disable context menu
	override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		if enableContextMenu {
			return super.canPerformAction(action, withSender: sender)
		} else {
			return false
		}
	}
	
	// enable/disable text selection
	override open func selectionRects(for range: UITextRange) -> [Any] {
		if enableSelection {
			return super.selectionRects(for: range)
		} else {
			return []
		}
	}
	
	// enable/disable magnifier
	override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
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
