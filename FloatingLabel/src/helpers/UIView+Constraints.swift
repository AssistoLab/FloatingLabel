//
//  UIView+Constraints.swift
//  FloatingLabel
//
//  Created by Kevin Hirsch on 20/07/15.
//  Copyright (c) 2015 Kevin Hirsch. All rights reserved.
//

import UIKit

internal extension UIView {
	
	func addConstraints(#format: String, options: NSLayoutFormatOptions = nil, metrics: [NSObject: AnyObject]? = nil, views: [String: UIView]) {
		addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: metrics, views: views))
	}
	
	func addUniversalConstraints(#format: String, options: NSLayoutFormatOptions = nil, metrics: [NSObject: AnyObject]? = nil, views: [String: UIView]) {
		addConstraints(format: "H:\(format)", options: options, metrics: metrics, views: views)
		addConstraints(format: "V:\(format)", options: options, metrics: metrics, views: views)
	}
	
}